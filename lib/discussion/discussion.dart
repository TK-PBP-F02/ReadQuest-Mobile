// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readquest/discussion/forum_detailpage.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:readquest/models/forum.dart';
import 'package:readquest/widgets/drawer.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  String _query = "";

  Future<List<Forum>> fetchForums() async {
    var url = Uri.parse('http://127.0.0.1:8000/forum/get-forum/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Forum> listForum = [];
    for (var d in data) {
      if (d != null) {
        listForum.add(Forum.fromJson(d));
      }
    }

    if (_query.isNotEmpty) {
      listForum = listForum.where((forum) {
        return forum.title.toLowerCase().contains(_query.toLowerCase()) ||
            forum.content.toLowerCase().contains(_query.toLowerCase()) ||
            forum.author.toLowerCase().contains(_query.toLowerCase()) ||
            forum.bookTitle.toLowerCase().contains(_query.toLowerCase());
        // Add more fields to search if needed
      }).toList();
    }
    return listForum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
        backgroundColor: const Color.fromARGB(255, 90, 229, 237),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: const Option(),
      backgroundColor: const Color.fromARGB(208, 99, 231, 101),
      body: Column(children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  bottom: 10,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search forums...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: ElevatedButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                      shadowColor: MaterialStatePropertyAll(Colors.grey)),
                  child: const Text(
                    "Add\nForum",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  )),
            )
          ],
        ),
        Expanded(
          child: FutureBuilder(
              future: fetchForums(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.data!.length == 0) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        _query.isNotEmpty
                            ? Text(
                                "No results found for '$_query'. Try again with other keywords",
                                style: const TextStyle(fontSize: 20),
                              )
                            : const Text(
                                "No forum yet",
                                style: TextStyle(fontSize: 20),
                              ),
                        const SizedBox(height: 10),
                      ],
                    );
                  } else {
                    List<Forum> forums = snapshot.data!;
                    return ListView.builder(
                        itemCount: forums.length,
                        itemBuilder: (_, index) => Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 15),
                            child: InkWell(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ForumPageDetail(
                                                forumId: forums[index].id,
                                                bookTitle: snapshot
                                                    .data![index].bookTitle,
                                                bookAuthor: snapshot
                                                    .data![index].bookAuthor,
                                                bookThumbnail: snapshot
                                                    .data![index].bookThumbnail,
                                                title: forums[index].title,
                                                content: forums[index].content,
                                                author: forums[index].author,
                                                createdAt: snapshot
                                                    .data![index].createdAt,
                                                isOwner: forums[index].isOwner,
                                              )));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: const Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        forums[index].title,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                          "Discussing ${forums[index].bookTitle} by ${forums[index].bookAuthor}"),
                                      const SizedBox(height: 10),
                                      Text(
                                          "${forums[index].author} - Posted on ${formatDateTime(forums[index].createdAt)}"),
                                      const SizedBox(height: 10),
                                      Text(forums[index].content)
                                    ],
                                  ),
                                ))));
                  }
                }
              }),
        )
      ]),
    );
  }
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('dd MMMM yyyy');
  return formatter.format(dateTime);
}
