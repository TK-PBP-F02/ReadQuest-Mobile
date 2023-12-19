import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:readquest/models/quest.dart';
import 'dart:convert';

import 'package:readquest/widgets/drawer.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  late Future<List<Quest>> _futureProduct;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureProduct = fetchProduct();
  }

  Future<List<Quest>> searchProduct(String query) async {
    if (query.isEmpty) {
      return await fetchProduct();
    } else {
      List<Quest> allQuest = await fetchProduct();
      return allQuest.where((quest) {
        return quest.fields.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<List<Quest>> fetchProduct() async {
    var url = Uri.parse('http://127.0.0.1:8000/quest/json-all/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Quest> listQuest = [];
    for (var d in data) {
      if (d != null) {
        listQuest.add(Quest.fromJson(d));
      }
    }
    return listQuest;
  }

  @override
  Widget build(BuildContext context) {
    const itemWidth = 180.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quest'),
        backgroundColor: const Color.fromARGB(255, 90, 229, 237),
      ),
      drawer: const Option(),
      backgroundColor: const Color.fromARGB(208, 99, 231, 101),
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
                labelText: 'Search Quest',
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
                          "No quest data available.",
                          style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: itemWidth,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestDetailPage(
                                equipment: snapshot.data![index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${snapshot.data![index].fields.name}",
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "Description: ${snapshot.data![index].fields.desc}",
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white70,
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

class QuestDetailPage extends StatelessWidget {
  final Quest equipment;

  const QuestDetailPage({Key? key, required this.equipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(equipment.fields.name),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.greenAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(equipment.fields.name),
              Text("Description: ${equipment.fields.desc}"),
              Center(
                child: ElevatedButton(
                  child: const Text("Back To Quest List"),
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
