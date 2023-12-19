import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:readquest/models/Inventory.dart';
import 'package:readquest/inventory/inventory_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/models/InventoryBook.dart';
import 'package:readquest/models/book.dart';
import 'package:readquest/user_var.dart';
import 'package:readquest/widgets/drawer.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Future<List<Inventory>> fetchInventories() async {
    var url = Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/get-inventory-all/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(response.body);

    List<Inventory> listInventories = [];
    int loggedInUserId = SharedVariable.user!.pk;

    for (var inventoryJson in data) {
      if (inventoryJson != null) {
        var inventory = Inventory.fromJson(inventoryJson);

        if (inventory.fields.user == loggedInUserId) {
          listInventories.add(inventory);
        }
      }
    }
    return listInventories;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventories'),
        backgroundColor: Color.fromARGB(255, 90, 229, 237),
      ),
      drawer: const Option(),
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      body: FutureBuilder<List<Inventory>>(
      future: fetchInventories(),
      builder: (context, AsyncSnapshot<List<Inventory>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(
          child: Text(
            "Tidak ada data inventoris",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
          ),
        );
      } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: ListTile(
                  title: Text("${snapshot.data![index].fields.name}"),
                  onTap: () async {
                    int inventoryId = snapshot.data![index].pk;
                    final response = await request.get(
                      "https://readquest-f02-tk.pbp.cs.ui.ac.id/get-inventory-books/${inventoryId}"
                    );
                    
                    List<dynamic> bookIdsInInventory = response.map((inventoryBook) {
                      return inventoryBook['fields']['book'] as dynamic;
                    }).toList();

                    List<Widget> booksInInventory = [];

                    for (var bookId in bookIdsInInventory) {
                      List<String> bookData = [];
                      final bookResponse = await request.get(
                        "https://readquest-f02-tk.pbp.cs.ui.ac.id/json-book/${bookId}/"
                      );

                      var book = bookResponse[0];
                      var imageUrl = book['fields']['image_url'];
                      var title = book['fields']['title'];
                      var author = book['fields']['author'];
                      bookData.add(imageUrl);
                      bookData.add(title);
                      bookData.add(author);
                      booksInInventory.add(BookDetailsWidget(
                        imageUrl: imageUrl,
                        title: title,
                        author: author,
                        bookId: bookId,
                        inventoryId: inventoryId,

                      ));
                    }

                    if (booksInInventory.isEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text("Books in Inventory"),
                              backgroundColor: Color.fromARGB(255, 90, 229, 237),
                            ),
                            backgroundColor: Color.fromARGB(208, 99, 231, 101),
                            body: Center(
                              child: Text(
                                "Tidak ada buku di dalam inventoris",
                                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text("Books in Inventory"),
                              backgroundColor: Color.fromARGB(255, 90, 229, 237),
                            ),
                            backgroundColor: Color.fromARGB(208, 99, 231, 101),
                            body: ListView(
                              children: booksInInventory,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (SharedVariable.user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InventoryFormPage()),
            );
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
            content: Text("Login untuk menambahkan inventoris."),
            ));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BookDetailsWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final int bookId;
  final int inventoryId;

  const BookDetailsWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.bookId,
    required this.inventoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final request = context.read<CookieRequest>();
      return Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: ListTile(
          leading: Image.network(imageUrl),
          title: Text(title),
          subtitle: Text(author),
          trailing: ElevatedButton(
          onPressed: () async {
            final response = await request.postJson(
              "https://readquest-f02-tk.pbp.cs.ui.ac.id/delete-inventory-flutter/${bookId}/",
              jsonEncode(<String, dynamic>{
                'Inventory.inventorybook': [
                  {
                    "pk": 0,
                    "fields": {
                      "inventory": inventoryId,
                      "book": bookId,
                    }
                  }
                ],
              }
              )
            );

            
            if (response['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Buku berhasil dihapus dari inventoris!"),
                ),
              );
              Navigator.pop(context);
            } else if (response['status'] == 'exist') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Buku tidak ditemukan di inventoris"),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Terdapat kesalahan, silakan coba lagi"),
                ),
              );
            }
          },
          child: Text('Delete'),
        ),
        ),
      );
  }
}
