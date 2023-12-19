import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/leaderboard/mainboard.dart';
import 'package:readquest/user_var.dart';
import 'package:readquest/models/board.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:readquest/widgets/drawer.dart';
import 'package:collection/collection.dart';

class RegLeaderboardPage extends StatefulWidget {
  const RegLeaderboardPage({super.key});

  @override
  State<RegLeaderboardPage> createState() => _RegLeaderboardPageState();
}

class _RegLeaderboardPageState extends State<RegLeaderboardPage> {
  final _formKey = GlobalKey<FormState>();
  String _nickname = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('Register'),
      ),
      backgroundColor: Colors.greenAccent,
      drawer: const Option(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Nickname",
                labelText: "Nickname",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  _nickname = value!;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Nickname tidak boleh kosong!";
                }
                return null;
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Kirim ke Django dan tunggu respons
                    final response = await request.postJson(
                        "http://127.0.0.1:8000/leaderboard/regboard-flutter/",
                        jsonEncode(<String, String>{
                          'nickname': _nickname,
                        }));
                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Nickname berhasil disimpan!"),
                      ));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaderboardPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Terdapat kesalahan, silakan coba lagi."),
                      ));
                    }
                  }
                },
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ])),
      ),
    );
  }
}
