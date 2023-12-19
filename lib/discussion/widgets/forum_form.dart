// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:readquest/discussion/discussion.dart';
import 'package:readquest/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ForumFormPage extends StatefulWidget {
  const ForumFormPage({super.key});

  @override
  State<ForumFormPage> createState() => _ForumFormPageState();
}

class _ForumFormPageState extends State<ForumFormPage> {
  final _formKey = GlobalKey<FormState>();
  Map<int, String> mapData = {};
  String _title = "";
  int _book = 2;
  String _content = "";

  Future<Map<int, String>> fetchBookData() async {
    final url = Uri.parse(
        'https://readquest-f02-tk.pbp.cs.ui.ac.id/json-all/'); // Replace with your API endpoint
    final response = await http.get(url);

    final List<dynamic> bookList = jsonDecode(response.body);
    final Map<int, String> bookMap = {};

    for (var book in bookList) {
      bookMap[book['pk']] = book['fields']['title'];
    }

    return bookMap;
  }

  @override
  void initState() {
    super.initState();
    fetchBookData().then((bookData) {
      setState(() {
        mapData = bookData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add New Forum',
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
                  Text("Book:"),
                  SizedBox(height: 2),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<int>(
                icon: const Icon(Icons.book),
                value: _book,
                onChanged: (int? value) {
                  setState(() {
                    _book = value!;
                  });
                },
                items: mapData.entries
                    .map<DropdownMenuItem<int>>((MapEntry<int, String> entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(
                      entry.value,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                isExpanded: true,
                underline: Container(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 2),
                  Text("Title:"),
                  SizedBox(height: 2),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Your text here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _title = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Title cannot be empty!";
                  }
                  return null;
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 2),
                  Text("Description:"),
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
                    return "Description cannot be empty!";
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
                          "https://readquest-f02-tk.pbp.cs.ui.ac.id/forum/create-forum/",
                          jsonEncode(<String, String>{
                            'title': _title,
                            'book': _book.toString(),
                            'content': _content,
                          }));
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Forum is saved!"),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForumPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text("Forum failed to save. Please try again"),
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
