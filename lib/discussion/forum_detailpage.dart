// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:readquest/models/replies.dart';
import 'package:readquest/widgets/drawer.dart';

class ForumPageDetail extends StatefulWidget {
  final int forumId;
  final String bookTitle;
  final String bookAuthor;
  final String bookThumbnail;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final bool isOwner;

  const ForumPageDetail(
      {Key? key,
      required this.forumId,
      required this.bookTitle,
      required this.bookAuthor,
      required this.bookThumbnail,
      required this.title,
      required this.content,
      required this.author,
      required this.createdAt,
      required this.isOwner})
      : super(key: key);

  @override
  State<ForumPageDetail> createState() => _ForumPageDetailState();
}

class _ForumPageDetailState extends State<ForumPageDetail> {
  Future<List<Replies>> fetchReplies() async {
    var url =
        Uri.parse('http://127.0.0.1:8000/forum/${widget.forumId}/get-replies/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Replies> listReply = [];
    for (var d in data) {
      if (d != null) {
        listReply.add(Replies.fromJson(d));
      }
    }
    return listReply;
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Discussing ${widget.bookTitle} by ${widget.bookAuthor}",
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${widget.author} - Posted on ${formatDateTime(widget.createdAt)}",
                        ),
                        const SizedBox(height: 10),
                        Image.network(
                          "https://books.google.com/books/content?id=qtNCDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api/",
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Failed to load image');
                          },
                        ),
                        Text(widget.content),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Replies")],
            ),
            Expanded(
                child: FutureBuilder(
                    future: fetchReplies(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (!snapshot.hasData) {
                          return const Column(
                            children: [
                              Text(
                                "No one have replied yet...",
                                style: TextStyle(
                                    color: Color(0xff59A5D8), fontSize: 20),
                              ),
                              SizedBox(height: 8),
                            ],
                          );
                        } else {
                          List<Replies> replies = snapshot.data!;
                          return ListView.builder(
                              itemCount: replies.length,
                              itemBuilder: (_, index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  padding: const EdgeInsets.all(20.0),
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
                                          "${replies[index].author} - Replied on ${formatDateTime(replies[index].createdAt)}"),
                                      const SizedBox(height: 10),
                                      Text(replies[index].content)
                                    ],
                                  )));
                        }
                      }
                    }))
          ],
        ));
  }
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('dd MMMM yyyy');
  return formatter.format(dateTime);
}
