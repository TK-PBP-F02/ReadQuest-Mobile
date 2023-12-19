import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/inventory/list_inventory.dart';
import 'package:readquest/user_var.dart';

class InventoryFormPage extends StatefulWidget {
  const InventoryFormPage({super.key});
  
  @override
  _InventoryFormPageState createState() => _InventoryFormPageState();
}

class _InventoryFormPageState extends State<InventoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
    @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
      return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Form Tambah Inventory',
            ),
          ),
          backgroundColor: Color.fromARGB(255, 90, 229, 237),
        ),
        backgroundColor: Color.fromARGB(208, 99, 231, 101),
        // drawer: const LeftDrawer(),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Name",
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _name = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Nama tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(                    
                      onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                              final response = await request.postJson(
                              "http://127.0.0.1:8000/create-inventory-flutter/",
                              jsonEncode(<String, dynamic>{
                                  'Inventory.inventory': [
                                    {
                                      "pk": 0,
                                      "fields": {
                                        "user": SharedVariable.user?.pk,
                                        "name": _name,
                                      }
                                    }
                                  ],
                                }));
                              if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                  content: Text("Inventory baru berhasil disimpan!"),
                                  ));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => InventoryPage()),
                                  );
                              } else if (response['status'] == 'exist') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                  content: Text("Anda telah memiliki inventoris dengan nama tersebut"),
                                  ));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => InventoryFormPage()),
                                  );
                              } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content:
                                          Text("Terdapat kesalahan, silakan coba lagi."),
                                  ));
                              }
                          }
                      },

                      child: const Text(
                        "Save",
                        style: TextStyle(color: Color.fromARGB(0, 0, 0, 0)),
                      ),
                    ),
                  ),
                ),
              ]
            )
          ),
        ),
      );
  }
}
