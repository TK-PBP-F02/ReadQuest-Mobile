// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/auth/login.dart';
import 'package:readquest/discussion/discussion.dart';
import 'package:readquest/discussion/widgets/reply_form.dart';

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
    var url = Uri.parse(
        'https://readquest-f02-tk.pbp.cs.ui.ac.id/forum/${widget.forumId}/get-replies/');
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
    final request = context.watch<CookieRequest>();

    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            'Forum',
            style: TextStyle(fontWeight: FontWeight.w600),
          )),
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
        backgroundColor: Color.fromARGB(208, 219, 219, 219),
        body: SingleChildScrollView(
            child: Column(
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
                        Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Color(0xFF36FBFF),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.title,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                    if (widget.author ==
                                        request.getJsonData()['username'])
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () async {
                                          // Perform the DELETE request
                                          final url = Uri.parse(
                                              'https://readquest-f02-tk.pbp.cs.ui.ac.id/forum/delete-forum-flutter/${widget.forumId}/');
                                          await http.delete(
                                            url,
                                            headers: {
                                              'Content-Type':
                                                  'application/json',
                                            },
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ForumPage()),
                                          );
                                        },
                                        child: const Text("X"),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Discussing ${widget.bookTitle} by ${widget.bookAuthor}",
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${widget.author} - Posted on ${formatDateTime(widget.createdAt)}",
                                ),
                              ],
                            )),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              widget.bookThumbnail,
                            ),
                          ],
                        ),
                        Text(widget.content),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (request.loggedIn) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReplyFormPage(
                                                  forumId: widget.forumId,
                                                  title: widget.title,
                                                  content: widget.content,
                                                  bookTitle: widget.bookTitle,
                                                  bookAuthor: widget.author,
                                                  bookThumbnail:
                                                      widget.bookThumbnail,
                                                  author: widget.author,
                                                  createdAt: widget.createdAt,
                                                  isOwner: widget.isOwner,
                                                )),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(120, 30),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                          style: BorderStyle.solid)),
                                  child: const Text(
                                    "Add Reply",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]),
                  child: const Text("Replies"),
                )
              ],
            ),
            FutureBuilder(
                future: fetchReplies(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data!.length == 0) {
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No one have replied yet...",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      );
                    } else {
                      List<Replies> replies = snapshot.data!;
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: replies.length,
                          itemBuilder: (_, index) => Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${replies[index].author} - Replied on ${formatDateTime(replies[index].createdAt)}"),
                                  const SizedBox(height: 10),
                                  Text(replies[index].content)
                                ],
                              )));
                    }
                  }
                })
          ],
        )));
  }
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('dd MMMM yyyy');
  return formatter.format(dateTime);
}
