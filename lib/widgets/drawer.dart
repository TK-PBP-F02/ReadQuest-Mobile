import 'package:flutter/material.dart';
import 'package:readquest/inventory/list_inventory.dart';
import 'package:readquest/journal/list_books_journal.dart';
import 'package:readquest/leaderboard/mainboard.dart';
import 'package:readquest/discussion/discussion.dart';
import 'package:readquest/main/Profile.dart';
import 'package:readquest/main/homepage.dart';
import 'package:readquest/main/list_books.dart';
import 'package:readquest/quest/queses.dart';
import 'package:readquest/user_var.dart';

class Option extends StatelessWidget {
  const Option({super.key});

  @override
  Widget build(BuildContext context) {
    if (SharedVariable.user == null) {
      return Drawer(
        backgroundColor: const Color.fromARGB(255, 47, 196, 241),
        child: ListView(
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 137, 225, 213),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Homepage',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                    ],
                  ),
                )),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Homepage'),
              // Bagian redirection ke MyHomePage
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_outlined),
              title: const Text('Books'),
              // Bagian redirection ke MyHomePage
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductPage(),
                    ));
              },
            ),

            ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: const Text('Discussion'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForumPage(),
                    ));
              },
            ),
            ListTile(
            leading: const Icon(Icons.backpack_outlined),
            title: const Text('Inventory'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InventoryPage(),
                )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.play_lesson_outlined),
            title: Text('Journal'),
            onTap: () {
              if (SharedVariable.user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JournalPage(books: []),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Login First!'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),

            ListTile(
              leading: const Icon(Icons.format_list_numbered_outlined),
              title: const Text('Leader Board'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaderboardPage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Quest'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuestPage(),
                    ));
              },
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        backgroundColor: const Color.fromARGB(255, 47, 196, 241),
        child: ListView(
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 137, 225, 213),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Homepage',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Silkscreen',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text("Hallo, ${SharedVariable.user?.fields.username}", style: TextStyle(
                          fontFamily: 'Silkscreen',
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),),
                      const Padding(padding: EdgeInsets.all(10)),
                    ],
                  ),
                )),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Homepage'),
              // Bagian redirection ke MyHomePage
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_outlined),
              title: const Text('Books'),
              // Bagian redirection ke MyHomePage
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductPage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_3_outlined),
              title: const Text('Profile'),
              // Bagian redirection ke MyHomePage
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.chat_outlined),
              title: Text('Discussion'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForumPage(),
                    ));
              },
            ),
            ListTile(
            leading: Icon(Icons.backpack_outlined),
            title: Text('Inventory'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InventoryPage(),
                )
              );
            },
          ),
            ListTile(
              leading: Icon(Icons.play_lesson_outlined),
              title: Text('Journal'),
              onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalPage(books: []),
                )
              );
            },
            ),
            ListTile(
              leading: const Icon(Icons.format_list_numbered_outlined),
              title: const Text('Leader Board'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaderboardPage(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Quest'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuestPage(),
                    ));
              },
            ),
          ],
        ),
      );
    }
  }
}
