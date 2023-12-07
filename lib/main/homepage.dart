import 'package:flutter/material.dart';
import 'package:readquest/inventory/list_inventory.dart';
import 'package:readquest/main/list_books.dart';
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

  const Guild(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
          if(item.name == "Books"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductPage()),
            );
          }
          if(item.name == "Inventory"){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InventoryPage()),
            );
          }
        },
        
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
    MyHomePage({Key? key}) : super(key: key);
    final List<OptionList> items = [
        OptionList("Books", Colors.lightBlue,Icons.book_outlined),
        OptionList("Discussion", const Color.fromARGB(255, 0, 255, 132), Icons.chat_outlined),
        OptionList("Inventory", Colors.orangeAccent, Icons.backpack_outlined),
        OptionList("Journal", Colors.tealAccent, Icons.play_lesson_outlined),
        OptionList("Quest", Colors.amberAccent, Icons.privacy_tip_rounded),
        OptionList("Leader Board", Colors.deepOrangeAccent, Icons.format_list_numbered_outlined),
        OptionList("Login", Colors.lightGreen, Icons.login),
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
                      children: items.map((OptionList item) {
                        // Iterasi untuk setiap item
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