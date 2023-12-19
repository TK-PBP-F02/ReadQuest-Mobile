
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:readquest/models/book.dart';
import 'package:readquest/models/quest.dart';
import 'package:readquest/quest/quest_form.dart';
import 'package:readquest/user_var.dart';
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
  late Future<List<Quest>> _futureProduct2;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureProduct = fetchProduct();
    _futureProduct2 = fetchProduct2();
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
    var url = Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/quest/json-world/');
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

  Future<List<Quest>> searchProduct2(String query) async {
    if (query.isEmpty) {
      return await fetchProduct2();
    } else {
      List<Quest> allQuest = await fetchProduct2();
      return allQuest.where((quest) {
        return quest.fields.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<List<Quest>> fetchProduct2() async {
    var url = Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/quest/json-book/');
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
    const itemWidth = 290.0;
    if(SharedVariable.user == null){
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quest', style: TextStyle(fontFamily: 'Silkscreen')),
          backgroundColor: const Color.fromARGB(255, 90, 229, 237),
        ),
        drawer: const Option(),
        backgroundColor: Color.fromARGB(255, 219, 218, 218),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _futureProduct = searchProduct(query);
                    _futureProduct2 = searchProduct2(query);
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search Quest',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("World Quest", style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'VT323'))
              ],
            ),
            const SizedBox(height: 10),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 125, 240, 255),
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
                                        fontFamily: 'Silkscreen',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      "Description: ${snapshot.data![index].fields.desc}",
                                      style: const TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Books Quest", style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'VT323'))
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: _futureProduct2,
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
                        scrollDirection: Axis.horizontal,
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
                                builder: (context) => QuestDetailPageBook(
                                  equipment: snapshot.data![index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 125, 240, 255),
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
                                      fontFamily: 'Silkscreen',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 137, 137, 137),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "Description: ${snapshot.data![index].fields.desc}",
                                    style: const TextStyle(
                                      fontFamily: 'Silkscreen',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 137, 137, 137),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
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
    }else if(SharedVariable.user?.fields.role == "ADMIN"){
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quest'),
          backgroundColor: const Color.fromARGB(255, 90, 229, 237),
        ),
        drawer: const Option(),
        backgroundColor: Color.fromARGB(208, 234, 234, 234),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _futureProduct = searchProduct(query);
                    _futureProduct2 = searchProduct2(query);
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search Quest',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestWorldFormPage()),
                      );
                    },
                    child: const Text("Add Worlds Quest"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestBookFormPage()),
                      );
                    },
                    child: const Text("Add Books Quest"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("World Quest", style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'VT323')),
              ],
            ),
            const SizedBox(height: 5),
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
                        scrollDirection: Axis.horizontal,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 125, 240, 255),
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
                                      fontFamily: 'Silkscreen',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 137, 137, 137),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "Description: ${snapshot.data![index].fields.desc}",
                                    style: const TextStyle(
                                      fontFamily: 'Silkscreen',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 137, 137, 137),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Books Quest", style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'VT323')),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: FutureBuilder(
                future: _futureProduct2,
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
                        scrollDirection: Axis.horizontal,
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
                                builder: (context) => QuestDetailPageBook(
                                  equipment: snapshot.data![index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 125, 240, 255),
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
                                      fontFamily: 'Silkscreen',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 137, 137, 137),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "Description: ${snapshot.data![index].fields.desc}",
                                    style: const TextStyle(
                                      fontFamily: 'Silkscreen',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 137, 137, 137),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
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
    }else{
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quest'),
          backgroundColor: const Color.fromARGB(255, 90, 229, 237),
        ),
        drawer: const Option(),
        backgroundColor: Color.fromARGB(255, 238, 238, 238),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _futureProduct = searchProduct(query);
                    _futureProduct2 = searchProduct2(query);
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search Quest',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("World Quest", style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'VT323')),
              ],
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
                        scrollDirection: Axis.horizontal,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 125, 240, 255),
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
                                      fontFamily: 'Silkscreen',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 137, 137, 137),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "Description: ${snapshot.data![index].fields.desc}",
                                    style: const TextStyle(
                                      fontFamily: 'Silkscreen',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 137, 137, 137),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (snapshot.data![index].fields.goal == "Readded")
                                    Column(
                                      children: [
                                        Text('${SharedVariable.user?.fields.readed} / ${snapshot.data![index].fields.amount}', style: const TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                    textAlign: TextAlign.center,),
                                        if (SharedVariable.user!.fields.readed >= snapshot.data![index].fields.amount)
                                          const Text("Completed", style: const TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                    textAlign: TextAlign.center,)
                                        else
                                          const Text("Not Complete", style: TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                    textAlign: TextAlign.center,),
                                      ],
                                    ),
                                  if (snapshot.data![index].fields.goal == "Buyed")
                                  Column(
                                      children: [
                                        Text('${SharedVariable.user?.fields.buyed} / ${snapshot.data![index].fields.amount}', style: const TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                    textAlign: TextAlign.center,),
                                        if (SharedVariable.user!.fields.buyed >= snapshot.data![index].fields.amount)
                                          const Text("Completed", style: TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                    textAlign: TextAlign.center,)
                                        else
                                          const Text("Not Complete", style: TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                    textAlign: TextAlign.center,),
                                      ],
                                    ),
                                    
                                  if (snapshot.data![index].fields.goal == "Review")
                                  Column(
                                      children: [
                                        Text('${SharedVariable.user?.fields.reviewed} / ${snapshot.data![index].fields.amount}', style: const TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                    textAlign: TextAlign.center,),
                                        if (SharedVariable.user!.fields.reviewed >= snapshot.data![index].fields.amount)
                                          const Text("Completed", style: TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                    textAlign: TextAlign.center,)
                                        else
                                          const Text("Not Complete", style: TextStyle(
                                        fontFamily: 'Silkscreen',
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 137, 137, 137),
                                      ),
                                    textAlign: TextAlign.center,),
                                      ],
                                    ),
                                    
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Books Quest", style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'VT323'))
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: _futureProduct2,
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
                        scrollDirection: Axis.horizontal,
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
                                builder: (context) => QuestDetailPageBook(
                                  equipment: snapshot.data![index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 125, 240, 255),
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
                                      fontFamily: 'Silkscreen',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 137, 137, 137),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "Description: ${snapshot.data![index].fields.desc}",
                                    style: const TextStyle(
                                      fontFamily: 'Silkscreen',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromARGB(255, 137, 137, 137),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
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
}

class QuestDetailPage extends StatelessWidget {
  final Quest equipment;
  const QuestDetailPage({Key? key, required this.equipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(equipment.fields.name, style: TextStyle(fontFamily: 'Silkscreen')),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Color.fromARGB(255, 236, 236, 236),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(equipment.fields.name,
                style: const TextStyle(
                    fontFamily: 'Silkscreen',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(179, 0, 0, 0),
                  ),
                  textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text("Description: ${equipment.fields.desc}",
                style: const TextStyle(
                    fontFamily: 'Silkscreen',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(179, 0, 0, 0),
                  ),
                  textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Goal: ${equipment.fields.goal}",
                style: const TextStyle(
                  fontFamily: 'Silkscreen',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Point: ${equipment.fields.point}",
                style: const TextStyle(
                  fontFamily: 'Silkscreen',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Needed to Complete: ${equipment.fields.amount}",
                style: const TextStyle(
                  fontFamily: 'Silkscreen',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
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

class QuestDetailPageBook extends StatelessWidget {
  final Quest equipment;

  const QuestDetailPageBook({Key? key, required this.equipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(equipment.fields.name, style: TextStyle(fontFamily: 'Silkscreen')),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
      body: FutureBuilder<Books>(
        future: fetchBook(),
        builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the Future is still running, show a loading indicator
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurred, show an error message
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // If there is no data yet, return an empty or loading state
          return CircularProgressIndicator(); // or any other appropriate widget
        } else {
          // If data is available, continue with the widget tree
          Books book = snapshot.data!;
          return SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: Uri.encodeFull(book.fields.imageUrl),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(height: 30,),
                  Text(book.fields.title, style: const TextStyle(
                  fontFamily: 'Silkscreen',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                textAlign: TextAlign.center,),
                SizedBox(height: 15,),
                  Text(equipment.fields.name, style: const TextStyle(
                  fontFamily: 'Silkscreen',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                textAlign: TextAlign.center,),
                SizedBox(height: 15,),
                  Text("Description: ${equipment.fields.desc}", style: const TextStyle(
                  fontFamily: 'Silkscreen',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                textAlign: TextAlign.center,),
                SizedBox(height: 15,),
                Text("Goal: ${equipment.fields.goal}", style: const TextStyle(
                  fontFamily: 'Silkscreen',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                textAlign: TextAlign.center,),
                SizedBox(height: 15,),
                Text("Point: ${equipment.fields.point}", style: const TextStyle(
                  fontFamily: 'Silkscreen',
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(179, 0, 0, 0),
                ),
                textAlign: TextAlign.center,),
                SizedBox(height: 15,),
                  ElevatedButton(
                    child: const Text("Back To Quest List"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
      ),
    );
  }

  Future<Books> fetchBook() async {
    var containerUrl =
        Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/quest/container/${equipment.fields.container}');
    var containerResponse = await http.get(
      containerUrl,
      headers: {"Content-Type": "application/json"},
    );

    if (containerResponse.statusCode == 200) {
      var containerData = jsonDecode(utf8.decode(containerResponse.bodyBytes));

      var bookId = containerData[0]['fields']['book_key'];

      var bookUrl = Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/json-book/$bookId');
      var bookResponse = await http.get(
        bookUrl,
        headers: {"Content-Type": "application/json"},
      );

      if (bookResponse.statusCode == 200) {
        var bookData = jsonDecode(utf8.decode(bookResponse.bodyBytes));
        return Books.fromJson(bookData[0]);
      } else {
        throw Exception('Failed to load book details');
      }
    } else {
      throw Exception('Failed to load container data');
    }
  }
}
