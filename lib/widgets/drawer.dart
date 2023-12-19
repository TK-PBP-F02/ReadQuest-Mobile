import 'package:flutter/material.dart';
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
        backgroundColor: const Color.fromARGB(255, 130, 185, 93),
        child: ListView(
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 78, 192, 176),
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
            const ListTile(
              leading: Icon(Icons.backpack_outlined),
              title: Text('Inventory'),
            ),
            const ListTile(
              leading: Icon(Icons.play_lesson_outlined),
              title: Text('Journal'),
            ),
            const ListTile(
              leading: Icon(Icons.format_list_numbered_outlined),
              title: Text('Leader Board'),
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
        backgroundColor: const Color.fromARGB(255, 130, 185, 93),
        child: ListView(
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 78, 192, 176),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Homepage',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text("Hallo, ${SharedVariable.user?.fields.username}"),
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
            const ListTile(
              leading: Icon(Icons.backpack_outlined),
              title: Text('Inventory'),
            ),
            const ListTile(
              leading: Icon(Icons.play_lesson_outlined),
              title: Text('Journal'),
            ),
            const ListTile(
              leading: Icon(Icons.format_list_numbered_outlined),
              title: Text('Leader Board'),
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
