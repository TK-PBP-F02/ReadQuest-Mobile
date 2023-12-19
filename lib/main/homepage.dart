import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/auth/login.dart';
import 'package:readquest/leaderboard/mainboard.dart';
import 'package:readquest/main/list_books.dart';
import 'package:readquest/models/user.dart';
import 'package:readquest/quest/queses.dart';
import 'package:readquest/user_var.dart';
import 'package:readquest/widgets/drawer.dart';
import 'package:readquest/widgets/drawer.dart';

class OptionList {
  final String name;
  final IconData icon;
  final Color color;

  OptionList(this.name, this.color, this.icon);
}

class Guild extends StatelessWidget {
  final OptionList item;

  const Guild(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Container(
      decoration: BoxDecoration(
        color: item.color,
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 4,
            offset: Offset(5, 3),
            spreadRadius: 0,
          )
        ],
        borderRadius: BorderRadius.circular(34),
      ),
      child: InkWell(
        onTap: () async {
          if (item.name == "Books") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductPage()),
            );
          }
          if (item.name == "Quest") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const QuestPage(),
              ),
            );
          }
          if (item.name == "Leader Board") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LeaderboardPage()));
          }
          if (item.name == "Login") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
          if (item.name == "Log Out") {
            final response =
                await request.logout("http://127.0.0.1:8000/logout-flutter/");
            String message = response["message"];
            if (response['status']) {
              String uname = response["username"];
              // ignore: use_build_context_synchronously
              SharedVariable.setSharedValue(null);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message Sampai jumpa, $uname."),
              ));
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(message),
              ));
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.1,
              ),
              const SizedBox(height: 8), // Added spacing
              Flexible(
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final List<OptionList> items = [
    OptionList("Books", Colors.lightBlue, Icons.book_outlined),
    OptionList("Discussion", const Color.fromARGB(255, 0, 255, 132),
        Icons.chat_outlined),
    OptionList("Inventory", Colors.orangeAccent, Icons.backpack_outlined),
    OptionList("Journal", Colors.tealAccent, Icons.play_lesson_outlined),
    OptionList("Quest", Colors.amberAccent, Icons.privacy_tip_rounded),
    OptionList("Leader Board", Colors.deepOrangeAccent,
        Icons.format_list_numbered_outlined),
    OptionList("Login", Colors.lightGreen, Icons.login),
    OptionList("Log Out", Colors.redAccent, Icons.logout_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 62, 2, 2),
        title: const Text(
          'ReadQuest',
        ),
      ),
      drawer: const Option(),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              Image.asset('assets/images/logo.png'),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Welcome to ReadQuest', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (SharedVariable.user != null)
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    '${SharedVariable.user?.fields.username}', // Text yang menandakan toko
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // Grid layout
              Center(
                child: GridView.count(
                  // Container pada card kita.
                  primary: true,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: items
                      .where((OptionList item) =>
                          !(SharedVariable.user != null &&
                              item.name == "Login") &&
                          !(SharedVariable.user == null &&
                              item.name == "Log Out"))
                      .map((OptionList item) {
                    // Return a Guild widget based on the current 'item'
                    return Guild(item);
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
