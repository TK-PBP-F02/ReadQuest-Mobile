import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/auth/login.dart';
import 'package:readquest/main/homepage.dart';
import 'package:readquest/main/list_books.dart';
import 'package:readquest/models/user.dart';
import 'package:readquest/quest/queses.dart';
import 'package:readquest/user_var.dart';
import 'package:http/http.dart' as http;
import 'package:readquest/widgets/drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> fetchData() async {
    if (SharedVariable.user != null) {
      if (SharedVariable.user?.fields.role == "PENGGUNA") {
        var url = Uri.parse(
            'https://readquest-f02-tk.pbp.cs.ui.ac.id/user/json/${SharedVariable.user?.pk}');
        try {
          var response = await http.get(
            url,
            headers: {"Content-Type": "application/json"},
          );

          if (response.statusCode == 200) {
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            SharedVariable.setSharedValue(User.fromJson(data[0]));
          } else {
            // Handle error, maybe show an error message
          }
        } catch (e) {
          // Handle exceptions
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(250, 101, 212, 242),
        title: const Text('ReadQuest'),
      ),
      drawer: const Option(),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (SharedVariable.user == null)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Column(
                              children: [
                                const Text("You need to Login first"),
                                SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyHomePage(),
                                      ),
                                    );
                                  },
                                  child: const Text("HomePage"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (SharedVariable.user?.fields.role == "PENGGUNA")
                    Column(
                      children: [
                        Image.asset('assets/gif/person.gif'),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            'Profile User',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_2_outlined),
                            Text(
                              ' Nama : ${SharedVariable.user?.fields.username}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.control_point_duplicate_outlined),
                            Text(
                              ' Point : ${SharedVariable.user?.fields.point}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.monetization_on_outlined),
                            Text(
                              ' Buyed : ${SharedVariable.user?.fields.buyed}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_box_outlined),
                            Text(
                              ' Reviewed : ${SharedVariable.user?.fields.reviewed}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.menu_book_sharp),
                            Text(
                              ' Read : ${SharedVariable.user?.fields.readed}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/gif/person.gif'),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            'Profile Admin',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_2_outlined),
                            Text(
                              'Authority',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_2_outlined),
                            Text(
                              ' Nama : ${SharedVariable.user?.fields.username}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_outlined),
                            Text(
                              ' Authorize the app the way you want to...',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
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
