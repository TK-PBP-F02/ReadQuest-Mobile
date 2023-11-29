import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

                        // Image.network('${snapshot.data![index].fields.thumbnail}'),

                        // CachedNetworkImage(
                        //   placeholder: (context, url) => const CircularProgressIndicator(),
                        //   imageUrl: '${snapshot.data![index].fields.thumbnail}',
                        // )

                        

                        // const SizedBox(height: 10),
                        // Text("Amount : ${snapshot.data![index].fields.amount}"),
                        // const SizedBox(height: 10),
                        // Text("Description : ${snapshot.data![index].fields.description}")
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

class EquipmentDetailPage extends StatelessWidget {
  final Books equipment;

  const EquipmentDetailPage({Key? key, required this.equipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement the UI for the equipment detail page using the 'equipment' data.
    return Scaffold(
      appBar: AppBar(
        title: Text(equipment.fields.title),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.greenAccent,
      body: SingleChildScrollView(
        child: Center(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                placeholder: (context, url) => const CircularProgressIndicator(),
                imageUrl: Uri.encodeFull('${equipment.fields.imageUrl}'),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Text("${equipment.fields.title}"),
              Text("Author: ${equipment.fields.author}"),
              Text("Published Date: ${equipment.fields.publishedDate}"),
              Text("Publisher: ${equipment.fields.publisher}"),
              Text("Publication Date: ${equipment.fields.publicationDate}"),
              Text("Page: ${equipment.fields.pageCount}"),
              Text("Category: ${equipment.fields.category}"),
              Text("Description: ${equipment.fields.description}"),
              Center(
                child: ElevatedButton(
                  child: Text("Back To Equipment List"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              )
              // Add more details as needed
            ],
          )
        ),
      ),
    );
  }
}
