import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/main/homepage.dart';
import 'package:readquest/models/Inventory.dart';
import 'package:readquest/user_var.dart';
import 'dart:convert';

import 'package:readquest/widgets/drawer.dart';
import 'package:readquest/models/book.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        backgroundColor: Color.fromARGB(255, 90, 229, 237),
      ),
      drawer: const Option(),
      backgroundColor: Color.fromARGB(208, 99, 231, 101),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    "Tidak ada data produk.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
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
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    color: Color.fromARGB(255, 68, 146, 71),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          imageUrl: Uri.encodeFull('${snapshot.data![index].fields.imageUrl}'),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          
                          httpHeaders: const {
                            "Access-Control-Allow-Origin": "*",
                          },
                        ),

                        
                        Text(
                          "${snapshot.data![index].fields.title}",
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        Text(
                          "${snapshot.data![index].fields.author}",
                          style: const TextStyle(
                            fontSize: 18.0,
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
          }
        },
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
    var url = Uri.parse('http://127.0.0.1:8000/get-inventory-all/');
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
      backgroundColor: Colors.greenAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                placeholder: (context, url) => const CircularProgressIndicator(),
                imageUrl: Uri.encodeFull('${widget.equipment.fields.imageUrl}'),
              ),
              Text("${widget.equipment.fields.title}"),
              Text("Author: ${widget.equipment.fields.author}"),
              Text("Published Date: ${widget.equipment.fields.publishedDate}"),
              Text("Publisher: ${widget.equipment.fields.publisher}"),
              Text("Publication Date: ${widget.equipment.fields.publicationDate}"),
              Text("Page: ${widget.equipment.fields.pageCount}"),
              Text("Category: ${widget.equipment.fields.category}"),
              Text("Description: ${widget.equipment.fields.description}"),
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
                                "http://127.0.0.1:8000/add-book-to-inventory-flutter/${widget.equipment.pk}/",
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
                  child: Text("Back To Equipment List"),
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
