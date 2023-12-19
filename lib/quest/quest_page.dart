import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:readquest/models/quest.dart';
import 'package:readquest/user_var.dart';
import 'package:readquest/widgets/drawer.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  Future<List<Quest>> fetchQuests() async {
    var url = Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/quest/json-all/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Quest> questList = [];
    for (var d in data) {
      if (d != null) {
        questList.add(Quest.fromJson(d));
      }
    }
    return questList;
  }

  @override
  Widget build(BuildContext context) {
    if (SharedVariable.user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quest'),
        ),
        drawer: const Option(),
        backgroundColor: const Color.fromARGB(208, 99, 231, 101),
        body: FutureBuilder(
          future: fetchQuests(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "Tidak ada data quest.",
                  style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                ),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 2, // Adjust the aspect ratio
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestDetailPage(
                          quest: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    color: const Color.fromARGB(255, 68, 146, 71),
                    child: Container(
                      height: 120.0, // Set a fixed height for the quest container
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            "${snapshot.data![index].fields.desc}",
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
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
          },
        ),
      );
    } else {
      if (SharedVariable.user?.fields.role == "ADMIN") {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Quest'),
          ),
          drawer: const Option(),
          backgroundColor: const Color.fromARGB(208, 99, 231, 101),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(
                "Hallo admin ${SharedVariable.user?.fields.username}, what do you wanna do ?",
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle button click
                    },
                    child: const Text("Add New Quest"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle button click
                    },
                    child: const Text("Remove Quest"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder(
                  future: fetchQuests(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "Tidak ada data quest.",
                          style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                      );
                    } else {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.8, // Adjust the aspect ratio
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuestDetailPage(
                                  quest: snapshot.data![index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(8.0),
                            color: const Color.fromARGB(255, 68, 146, 71),
                            child: Container(
                              height: 120.0, // Set a fixed height for the quest container
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                    "${snapshot.data![index].fields.desc}",
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
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
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Quest'),
          ),
          drawer: const Option(),
          backgroundColor: const Color.fromARGB(208, 99, 231, 101),
          body: FutureBuilder(
            future: fetchQuests(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "Tidak ada data quest.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                );
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.8, // Adjust the aspect ratio
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestDetailPage(
                            quest: snapshot.data![index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      color: const Color.fromARGB(255, 68, 146, 71),
                      child: Container(
                        height: 120.0, // Set a fixed height for the quest container
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                              "${snapshot.data![index].fields.desc}",
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
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
            },
          ),
        );
      }
    }
  }
}

class QuestDetailPage extends StatelessWidget {
  final Quest quest;

  const QuestDetailPage({Key? key, required this.quest}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quest.fields.name),
      ),
      backgroundColor: Colors.greenAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                quest.fields.name,
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'Description: ${quest.fields.desc}',
                style: TextStyle(fontSize: 16.0),
              ),
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
