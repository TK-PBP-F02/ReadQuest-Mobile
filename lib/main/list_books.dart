import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/main/homepage.dart';
import 'package:readquest/models/Inventory.dart';
import 'package:readquest/user_var.dart';
import 'package:readquest/quest/queses.dart';
import 'dart:convert';

import 'package:readquest/widgets/drawer.dart';
import 'package:readquest/models/book.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Books>> _futureProduct;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureProduct = fetchProduct();
  }

  Future<List<Books>> searchProduct(String query) async {
    if (query.isEmpty) {
      // If the search bar is empty, return all books
      return await fetchProduct();
    } else {
      // If the search bar is not empty, filter books based on the query
      List<Books> allBooks = await fetchProduct();
      return allBooks.where((book) {
        return book.fields.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<List<Books>> fetchProduct() async {
    var url = Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/json-all/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Books> listEquipment = [];
    for (var d in data) {
      if (d != null) {
        listEquipment.add(Books.fromJson(d));
      }
    }
    
    return listEquipment;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const itemWidth = 200.0; // Set your desired item width
    final crossAxisCount = (screenWidth / itemWidth).floor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books', style: TextStyle(fontFamily: 'Silkscreen')),
        backgroundColor: Color.fromARGB(167, 123, 243, 249),
      ),
      drawer: const Option(),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _futureProduct = searchProduct(query);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search Books',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Books>>(
              future: _futureProduct,
              builder: (context, AsyncSnapshot<List<Books>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EquipmentDetailPage(
                              equipment: snapshot.data![index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: itemWidth,
                        padding: const EdgeInsets.all(12.0),
                        color: Color.fromARGB(255, 111, 218, 239),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                imageUrl: Uri.encodeFull('${snapshot.data![index].fields.imageUrl}'),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "${snapshot.data![index].fields.title}",
                              style: const TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class EquipmentDetailPage extends StatefulWidget {
  final Books equipment;

  EquipmentDetailPage({Key? key, required this.equipment}) : super(key: key);

  @override
  _EquipmentDetailPageState createState() => _EquipmentDetailPageState();
}

class _EquipmentDetailPageState extends State<EquipmentDetailPage> {
  late Inventory? selectedFolder = null;
  late List<Inventory> listInventories = [];

  @override
  void initState() {
    super.initState();
    listInventories = [];
    fetchInventories();
  }

  Future<void> fetchInventories() async {
    if (SharedVariable.user != null) {
      List<Inventory> inventories = await _fetchInventories();
      setState(() {
        listInventories = inventories;
        selectedFolder = inventories.isNotEmpty ? inventories.first : null;
      });
    }
  }

  Future<List<Inventory>> _fetchInventories() async {
    var url = Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/get-inventory-all/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(response.body);

    List<Inventory> inventories = [];
    int loggedInUserId = SharedVariable.user!.pk;

    for (var inventoryJson in data) {
      if (inventoryJson != null) {
        var inventory = Inventory.fromJson(inventoryJson);
        if (inventory.fields.user == loggedInUserId) {
          inventories.add(inventory);
        }
      }
    }
    return inventories;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.equipment.fields.title),
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              CachedNetworkImage(
                placeholder: (context, url) => const CircularProgressIndicator(),
                imageUrl: Uri.encodeFull('${widget.equipment.fields.imageUrl}'),
              ),
              SizedBox(height: 15),
              Text("${widget.equipment.fields.title}"),
              SizedBox(height: 5),
              Text("Author: ${widget.equipment.fields.author}"),
              SizedBox(height: 5),
              Text("Published Date: ${widget.equipment.fields.publishedDate}"),
              SizedBox(height: 5),
              Text("Publisher: ${widget.equipment.fields.publisher}"),
              SizedBox(height: 5),
              Text("Publication Date: ${widget.equipment.fields.publicationDate}"),
              SizedBox(height: 5),
              Text("Page: ${widget.equipment.fields.pageCount}"),
              SizedBox(height: 5),
              Text("Category: ${widget.equipment.fields.category}"),
              SizedBox(height: 10),
              Text("Description: ${widget.equipment.fields.description}"),
              SizedBox(height: 10),
              Text(""),
              if (SharedVariable.user != null)
                Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Add to Inventory:'),
                                DropdownButtonFormField<Inventory>(
                                  value: selectedFolder,
                                  items: listInventories.map((inventory) {
                                    return DropdownMenuItem<Inventory>(
                                      value: inventory,
                                      child: Text(inventory.fields.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFolder = value;
                                      // print(selectedFolder?.pk); // Access the pk of the selected folder
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final response = await request.postJson(
                                "https://readquest-f02-tk.pbp.cs.ui.ac.id/add-book-to-inventory-flutter/${widget.equipment.pk}/",
                                jsonEncode(<String, dynamic>{
                                  'Inventory.inventorybook': [
                                    {
                                      "pk": 0,
                                      "fields": {
                                        "inventory": selectedFolder?.pk,
                                        "book": widget.equipment.pk,
                                      }
                                    }
                                  ],
                                }),
                              );

                              // print(response);

                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Buku berhasil disimpan di inventoris!"),
                                  ),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EquipmentDetailPage(
                                      equipment: widget.equipment,
                                    ),
                                  ),
                                );
                              } else if (response['status'] == 'exist') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Anda telah menyimpan buku ini pada inventoris yang Anda pilih"),
                                  ),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EquipmentDetailPage(
                                      equipment: widget.equipment,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Terdapat kesalahan, silakan coba lagi."),
                                  ),
                                );
                              }
                            },
                            child: Text('Add to Inventory'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Container(),
              Center(
                child: ElevatedButton(
                  child: const Text("Back To Equipment List"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
