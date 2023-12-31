import 'package:flutter/material.dart';
import 'package:readquest/inventory/list_inventory.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/auth/login.dart';
import 'package:readquest/journal/list_books_journal.dart';
import 'package:readquest/leaderboard/mainboard.dart';
import 'package:readquest/discussion/discussion.dart';
import 'package:readquest/main/Profile.dart';
import 'package:readquest/main/list_books.dart';
import 'package:readquest/models/user.dart';
import 'package:readquest/quest/queses.dart';
import 'package:readquest/user_var.dart';
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
          if(item.name == "Inventory"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InventoryPage()),
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
          if (item.name == "Discussion") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ForumPage()));
          }
          if (item.name == "Profile") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
          if (item.name == "Journal") {
            if(SharedVariable.user != null){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JournalPage(books: [],)),
              );
            } else{
              showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Login First!'),
                      //content: Text(response['message']),
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
          }
          if (item.name == "Log Out") {
            final response = await request.logout(
                "https://readquest-f02-tk.pbp.cs.ui.ac.id/logout-flutter/");
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
            children: <Widget>[
              if(item.name == 'Books')
                Image.asset('assets/gif/doc.gif', width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1,),
              if(item.name == 'Profile')
                Image.asset('assets/gif/person.gif', width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1,),
              if(item.name == 'Discussion')
                Image.asset('assets/gif/discus.gif', width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1,),
              if(item.name == 'Inventory')
                Image.asset('assets/gif/stack.gif', width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1,),
              if(item.name == 'Journal')
                Image.asset('assets/gif/pencil.gif', width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1,),
              if(item.name == 'Quest')
                Image.asset('assets/gif/quest.gif', width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1,),
              if(item.name == 'Leader Board')
                Image.asset('assets/gif/globe.gif', width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1,),
              if(item.name == 'Login')
                Image.asset('assets/gif/home.gif', width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1,),
              if(item.name == 'Log Out')
                Image.asset('assets/gif/home.gif', width: MediaQuery.of(context).size.width * 0.1, height: MediaQuery.of(context).size.width * 0.1,),
              const SizedBox(height: 8), // Added spacing
              Flexible(
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontFamily: 'VT323'
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
    OptionList("Profile", Colors.cyanAccent, Icons.person_3_outlined),
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 217, 231),
        title: const Text(
          'ReadQuest',
          style: TextStyle(fontFamily: 'Silkscreen')
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
                    fontFamily: 'Silkscreen',
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
                      fontFamily: 'Silkscreen',
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
