import 'package:flutter/material.dart';
import 'package:readquest/main/homepage.dart';
import 'package:readquest/main/list_books.dart';

class Option extends StatelessWidget {
  const Option({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 130, 185, 93),
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
                
                Text("Name :"),
                Text("Role :"),
                Text("Point :"),
                Padding(padding: EdgeInsets.all(10)),
              ],
            ),
            )
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Homepage'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                )
              );
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
                  builder: (context) => ProductPage(),
                )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat_outlined),
            title: const Text('Discussion'),
          ),
          ListTile(
            leading: const Icon(Icons.backpack_outlined),
            title: const Text('Inventory'),
          ),
          ListTile(
            leading: const Icon(Icons.play_lesson_outlined),
            title: const Text('Journal'),
          ),
          ListTile(
            leading: const Icon(Icons.format_list_numbered_outlined),
            title: const Text('Leader Board'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Quest'),
          ),
        ],
      ),
    );
  }
}