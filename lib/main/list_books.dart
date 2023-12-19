import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
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
        title: const Text('Books'),
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
            child: FutureBuilder(
              future: _futureProduct,
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
                                  fontSize: 12.0,
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
          ),
        ],
      ),
    );
  }
}

class EquipmentDetailPage extends StatelessWidget {
  final Books equipment;

  const EquipmentDetailPage({Key? key, required this.equipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(equipment.fields.title),
        backgroundColor: Colors.lightBlueAccent,
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
                imageUrl: Uri.encodeFull(equipment.fields.imageUrl),
              ),
              const SizedBox(height: 10),
              Text(equipment.fields.title),
              const SizedBox(height: 5),
              Text("Author: ${equipment.fields.author}"),
              const SizedBox(height: 5),
              Text("Published Date: ${equipment.fields.publishedDate}"),
              const SizedBox(height: 5),
              Text("Publisher: ${equipment.fields.publisher}"),
              const SizedBox(height: 5),
              Text("Publication Date: ${equipment.fields.publicationDate}"),
              const SizedBox(height: 5),
              Text("Page: ${equipment.fields.pageCount}"),
              const SizedBox(height: 5),
              Text("Category: ${equipment.fields.category}"),
              const SizedBox(height: 30),
              Text("Description: ${equipment.fields.description}"),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  child: const Text("Back To Equipment List"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
