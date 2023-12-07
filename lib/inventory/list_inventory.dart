import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:readquest/models/book.dart';
import 'package:readquest/models/Inventory.dart';
import 'package:readquest/models/InventoryBook.dart';
import 'package:readquest/inventory/book_detail.dart';
import 'package:readquest/inventory/inventory_form.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Future<List<Inventory>> fetchInventories() async {
    var url = Uri.parse('http://127.0.0.1:8000/get-user-inventory/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Inventory> listInventories = [];
    for (var d in data) {
      if (d != null) {
        listInventories.add(Inventory.fromJson(d));
      }
    }
    return listInventories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventories'),
      ),
      body: FutureBuilder(
        future: fetchInventories(),
        builder: (context, AsyncSnapshot<List<Inventory>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada data inventory.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: ListTile(
                  title: Text("${snapshot.data![index].fields.name}"),
                  // subtitle: Text("Additional info"),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman formulir inventaris baru
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InventoryFormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
