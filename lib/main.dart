import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/main/homepage.dart';
import 'package:readquest/models/book.dart';
import 'package:readquest/user_var.dart';
void main() async {
  // Fetch the books data
  List<Books> books = await fetchProduct();

  // Set the value in SharedVariable
  SharedVariable.setList(books);

  // Run the app
  runApp(const MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
    Widget build(BuildContext context) {
        return Provider(
          create: (_) {
              CookieRequest request = CookieRequest();
              return request;
          },
          child: MaterialApp(
              title: 'Read Quest',
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 75, 183, 58)),
                  useMaterial3: true,
              ),
              home: MyHomePage()),
        );
    }
}

