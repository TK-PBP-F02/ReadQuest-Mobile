import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:readquest/leaderboard/regboard.dart';
import 'package:readquest/models/user.dart';
import 'package:readquest/user_var.dart';
import 'package:readquest/models/board.dart';
// ignore: depend_on_referenced_packages
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

  Future<List<Display>> searchProduct(String query) async {
    if (query.isEmpty) {
      return await fetchProduct();
    } else {
      List<Display> allLeaderboard = await fetchProduct();
      return allLeaderboard.where((quest) {
        return quest.fields.nickname
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<List<Display>> fetchProduct() async {
    var url = Uri.parse('http://127.0.0.1:8000/leaderboard/all-json/');
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

  Future<List<User>> fetchPoint() async {
    // final response = Uri.parse('http://127.0.0.1:8000/leaderboard/user-json/');

    // int point = response['point'];

    var url = Uri.parse('http://127.0.0.1:8000/leaderboard/user-json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<User> listLeaderboard = [];
    for (var d in data) {
      if (d != null) {
        listLeaderboard.add(User.fromJson(d));
      }
    }
    return listLeaderboard;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (SharedVariable.user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: const Text('Leaderboard'),
        ),
        backgroundColor: Colors.greenAccent,
        drawer: const Option(),
        body: FutureBuilder<List<Display>>(
          future: fetchProduct(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No leaderboard data available.'));
            } else {
              return SingleChildScrollView(
                // Wrap the Column with SingleChildScrollView
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.0), // Add spacing at the top
                      Text(
                        'TOP USERS',
                        style: TextStyle(
                          fontSize: 28.0, // Increased font size
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                          height: 10.0), // Add spacing between title and list

                      // Sort the leaderboard data based on points in descending order

                      ...(snapshot.data! as List<Display>)
                          .sorted(
                            (a, b) => b.fields.akun.compareTo(a.fields.akun),
                          )
                          .asMap()
                          .entries
                          .map((entry) {
                        int upk = entry.value.pk;

                        // var url =
                        //     Uri.parse('http://127.0.0.1:8000/user/json/$upk');
                        // var responses = await http.get(
                        //   url,
                        //   headers: {"Content-Type": "application/json"},
                        // );
                        // var data = jsonDecode(utf8.decode(responses.bodyBytes));

                        // User user = User.fromJson(data[0]);
                        int index = entry.key;
                        String readerName = entry.value.fields.nickname;
                        int readerPoint = entry.value.fields.akun;
                        Color tileColor = Color.fromARGB(225, 247, 247, 247);
                        FontWeight subtitleFontWeight = FontWeight.normal;
                        if (index == 0) {
                          tileColor = Colors.amber; // Gold for the first entry
                        } else if (index == 1) {
                          tileColor = Color.fromARGB(255, 192, 192,
                              192); // Silver for the second entry
                        } else if (index == 2) {
                          tileColor = Color.fromARGB(
                              255, 205, 127, 50); // Bronze for the third entry
                        }
                        // int point = user.fields.point;
                        return Center(
                          // Wrap the ListTile with Center widget
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
                                // Wrap the title with Center widget
                                child: Text(
                                  readerName,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Center(
                                // Wrap the subtitle with Center widget
                                child: Text(
                                  '$readerPoint points',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(
                          height:
                              20.0), // Add spacing between list and the text

                      const Text(
                        'Login as User to participate in the Leaderboard',
                        style: TextStyle(
                          fontSize: 20.0, // Increased font size
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
            future: fetchProduct(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No leaderboard data available.'));
              } else {
                return SingleChildScrollView(
                  // Wrap the Column with SingleChildScrollView
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.0), // Add spacing at the top
                        Text(
                          'TOP USERS',
                          style: TextStyle(
                            fontSize: 28.0, // Increased font size
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                            height: 10.0), // Add spacing between title and list

                        // Sort the leaderboard data based on points in descending order
                        ...(snapshot.data! as List<Display>)
                            .sorted(
                              (a, b) => b.fields.akun.compareTo(a.fields.akun),
                            )
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          String readerName = entry.value.fields.nickname;
                          int readerPoint = entry.value.fields.akun;
                          Color tileColor = Color.fromARGB(225, 247, 247, 247);

                          if (index == 0) {
                            tileColor =
                                Colors.amber; // Gold for the first entry
                          } else if (index == 1) {
                            tileColor = Color.fromARGB(255, 192, 192,
                                192); // Silver for the second entry
                          } else if (index == 2) {
                            tileColor = Color.fromARGB(255, 205, 127,
                                50); // Bronze for the third entry
                          }
                          return Center(
                            // Wrap the ListTile with Center widget
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
                                  // Wrap the title with Center widget
                                  child: Text(
                                    readerName,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                subtitle: Center(
                                  // Wrap the subtitle with Center widget
                                  child: Text(
                                    '$readerPoint points',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
            backgroundColor: Colors.lightBlueAccent, // Updated app bar color
            title: const Text('Leaderboard'),
          ),
          backgroundColor: Colors.greenAccent, // Updated background color
          drawer: const Option(),
          body: FutureBuilder<List<Display>>(
            future: fetchProduct(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          primary: Colors.teal, // Match app bar color
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color for the button
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30.0), // Increased margin
                        Text(
                          'TOP USERS',
                          style: TextStyle(
                            fontSize: 28.0, // Increased font size
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                            height: 20.0), // Larger margin beneath the text

                        // Sort the leaderboard data based on points in descending order
                        ...(snapshot.data! as List<Display>)
                            .sorted(
                              (a, b) => b.fields.akun.compareTo(a.fields.akun),
                            )
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          String readerName = entry.value.fields.nickname;
                          int readerPoint = entry.value.fields.akun;
                          Color tileColor = Color.fromARGB(225, 247, 247, 247);
                          FontWeight subtitleFontWeight = FontWeight.normal;
                          Color subtitleColor =
                              Colors.blue; // Default subtitle color

                          if (index == 0) {
                            tileColor =
                                Colors.amber; // Gold for the first entry
                          } else if (index == 1) {
                            tileColor = Color.fromARGB(255, 192, 192,
                                192); // Silver for the second entry
                          } else if (index == 2) {
                            tileColor = Color.fromARGB(255, 205, 127,
                                50); // Bronze for the third entry
                          }

                          return Center(
                            child: Card(
                              elevation:
                                  5.0, // Add elevation for a shadow effect
                              margin: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 75.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ), // Rounded corners
                              color: tileColor,
                              child: ListTile(
                                title: Center(
                                  child: Text(
                                    readerName,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .black, // Text color for the title
                                    ),
                                  ),
                                ),
                                subtitle: Center(
                                  child: Text(
                                    '$readerPoint Points',
                                    style: TextStyle(
                                      fontWeight: subtitleFontWeight,
                                      color: subtitleColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegLeaderboardPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal[200], // Match app bar color
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text color for the button
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
