// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:readquest/discussion/forum_detailpage.dart';
import 'package:readquest/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReplyFormPage extends StatefulWidget {
  final int forumId;
  final String bookTitle;
  final String bookAuthor;
  final String bookThumbnail;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final bool isOwner;

  const ReplyFormPage(
      {super.key,
      required this.forumId,
      required this.title,
      required this.content,
      required this.bookTitle,
      required this.bookAuthor,
      required this.bookThumbnail,
      required this.author,
      required this.createdAt,
      required this.isOwner});

  @override
  State<ReplyFormPage> createState() => _ReplyFormPageState();
}

class _ReplyFormPageState extends State<ReplyFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _content = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add New Reply',
          ),
        ),
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 2),
                  Text("Your Reply:"),
                  SizedBox(height: 2),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Your text here...",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _content = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Reply cannot be empty!";
                  }
                  return null;
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Kirim ke Django dan tunggu respons
                      final response = await request.postJson(
                          "http://127.0.0.1:8000/forum/create-replies/",
                          jsonEncode(<String, String>{
                            'parent_forum': widget.forumId.toString(),
                            'content': _content,
                          }));
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Reply is saved!"),
                        ));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForumPageDetail(
                                    forumId: widget.forumId,
                                    title: widget.title,
                                    content: widget.content,
                                    bookTitle: widget.bookTitle,
                                    bookAuthor: widget.author,
                                    bookThumbnail: widget.bookThumbnail,
                                    author: widget.author,
                                    createdAt: widget.createdAt,
                                    isOwner: widget.isOwner,
                                  )),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text("Reply failed to save. Please try again"),
                        ));
                      }
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
