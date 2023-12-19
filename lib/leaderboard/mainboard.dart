import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:readquest/leaderboard/regboard.dart';
import 'package:readquest/models/user.dart';
import 'package:readquest/user_var.dart';
import 'package:readquest/models/board.dart';
import 'package:http/http.dart' as http;
import 'package:readquest/widgets/drawer.dart';
import 'package:collection/collection.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<Display>> _futureProduct;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureProduct = fetchProduct();
  }

  Future<User?> fetchData(int entry) async {
    print(entry);
    var url = Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/user/json/$entry/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      User user = User.fromJson(data[0]);
      return user;
    } else {
      // Handle errors, you can return null or throw an exception
      print('Failed to load user data');
      return null;
    }
  }

  Future<List<Display>> fetchProduct() async {
    var url = Uri.parse('https://readquest-f02-tk.pbp.cs.ui.ac.id/leaderboard/all-json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Display> listLeaderboard = [];
    for (var d in data) {
      if (d != null) {
        listLeaderboard.add(Display.fromJson(d));
      }
    }
    return listLeaderboard;
  }

  @override
  Widget build(BuildContext context) {
    if (SharedVariable.user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: const Text('Leaderboard'),
        ),
        backgroundColor: Colors.greenAccent,
        drawer: const Option(),
        body: FutureBuilder<List<Display>>(
          future: _futureProduct,
          builder: (context, AsyncSnapshot<List<Display>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No leaderboard data available.'));
            } else {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        'TOP USERS',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.0),

                      ...snapshot.data!.sorted(
                        (a, b) => b.fields.akun.compareTo(a.fields.akun),
                      ).asMap().entries.map((entry) {
                        int index = entry.key;
                        String readerName = entry.value.fields.nickname;
                        Color tileColor = Color.fromARGB(225, 247, 247, 247);

                        return FutureBuilder<User?>(
                          future: fetchData(entry.value.fields.akun),
                          builder: (context, AsyncSnapshot<User?> userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (userSnapshot.hasError) {
                              return Text('Error: ${userSnapshot.error}');
                            } else if (!userSnapshot.hasData || userSnapshot.data == null) {
                              return Text('Loading user data...');
                            } else {
                              User user = userSnapshot.data!;
                              if (index == 0) {
                                tileColor = Colors.amber;
                              } else if (index == 1) {
                                tileColor = Color.fromARGB(255, 192, 192, 192);
                              } else if (index == 2) {
                                tileColor = Color.fromARGB(255, 205, 127, 50);
                              }

                              return Center(
                                child: Card(
                                  elevation: 3.0,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 75.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: tileColor,
                                  child: ListTile(
                                    title: Center(
                                      child: Text(
                                        readerName,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    subtitle: Center(
                                      child: Text(
                                        '${user.fields.point} points',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }).toList(),

                      const SizedBox(height: 20.0),
                      const Text(
                        'Login as User to participate in the Leaderboard',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
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
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('Leaderboard'),
      ),
      backgroundColor: Colors.greenAccent,
      drawer: const Option(),
      body: FutureBuilder<List<Display>>(
        future: _futureProduct,
        builder: (context, AsyncSnapshot<List<Display>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No leaderboard data available.'));
          } else {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      'TOP USERS',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.0),

                    ...snapshot.data!.sorted(
                      (a, b) => b.fields.akun.compareTo(a.fields.akun),
                    ).asMap().entries.map((entry) {
                      int index = entry.key;
                      String readerName = entry.value.fields.nickname;
                      Color tileColor = Color.fromARGB(225, 247, 247, 247);

                      return FutureBuilder<User?>(
                        future: fetchData(entry.value.fields.akun),
                        builder: (context, AsyncSnapshot<User?> userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (userSnapshot.hasError) {
                            return Text('Error: ${userSnapshot.error}');
                          } else if (!userSnapshot.hasData || userSnapshot.data == null) {
                            return Text('Loading user data...');
                          } else {
                            User user = userSnapshot.data!;
                            if (index == 0) {
                              tileColor = Colors.amber;
                            } else if (index == 1) {
                              tileColor = Color.fromARGB(255, 192, 192, 192);
                            } else if (index == 2) {
                              tileColor = Color.fromARGB(255, 205, 127, 50);
                            }

                            return Center(
                              child: Card(
                                elevation: 3.0,
                                margin: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 75.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: tileColor,
                                child: ListTile(
                                  title: Center(
                                    child: Text(
                                      readerName,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Center(
                                    child: Text(
                                      '${user.fields.point} points',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  } else {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('Leaderboard'),
      ),
      backgroundColor: Colors.greenAccent,
      drawer: const Option(),
      body: FutureBuilder<List<Display>>(
        future: _futureProduct,
        builder: (context, AsyncSnapshot<List<Display>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text(
                    'No leaderboard data available.',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegLeaderboardPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    child: Text('Register to Leaderboard'),
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 30.0),
                    Text(
                      'TOP USERS',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),

                    ...snapshot.data!.sorted(
                      (a, b) => b.fields.akun.compareTo(a.fields.akun),
                    ).asMap().entries.map((entry) {
                      int index = entry.key;
                      String readerName = entry.value.fields.nickname;
                      Color tileColor = Color.fromARGB(225, 247, 247, 247);
                      FontWeight subtitleFontWeight = FontWeight.normal;
                      Color subtitleColor = Colors.blue;
                      return FutureBuilder<User?>(
                        future: fetchData(entry.value.fields.akun),
                        builder: (context, AsyncSnapshot<User?> userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (userSnapshot.hasError) {
                            return Text('Error: ${userSnapshot.error}');
                          } else if (!userSnapshot.hasData || userSnapshot.data == null) {
                            return Text('Loading user data...');
                          } else {
                            User user = userSnapshot.data!;
                            if (index == 0) {
                              tileColor = Colors.amber;
                            } else if (index == 1) {
                              tileColor = Color.fromARGB(255, 192, 192, 192);
                            } else if (index == 2) {
                              tileColor = Color.fromARGB(255, 205, 127, 50);
                            }

                            return Center(
                              child: Card(
                                elevation: 3.0,
                                margin: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 75.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: tileColor,
                                child: ListTile(
                                  title: Center(
                                    child: Text(
                                      readerName,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Center(
                                    child: Text(
                                      '${user.fields.point} points',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegLeaderboardPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal[200],
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      child: Text('Register to Leaderboard'),
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
}
  }
}
