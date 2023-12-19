import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/quest/queses.dart';
import 'package:readquest/user_var.dart';

class QuestBookFormPage extends StatefulWidget {
  @override
  _QuestBookFormPageState createState() => _QuestBookFormPageState();
}

class _QuestBookFormPageState extends State<QuestBookFormPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quest'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _fbKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'desc',
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderDropdown(
                  name: 'goal',
                  decoration: InputDecoration(labelText: 'Goal'),
                  items: [
                    DropdownMenuItem(value: 'Readded', child: Text('Readded')),
                    DropdownMenuItem(value: 'Buyed', child: Text('Buyed')),
                    DropdownMenuItem(value: 'Review', child: Text('Review')),
                  ],
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'point',
                  decoration: InputDecoration(labelText: 'Point'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                ),
                FormBuilderDropdown(
                  name: 'bookId',
                  decoration: InputDecoration(labelText: 'Book Title'),
                  items: SharedVariable.books!
                      .map(
                        (book) => DropdownMenuItem(
                          value: book.fields.title, // Set the value to book title
                          child: Text(book.fields.title),
                        ),
                      )
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_fbKey.currentState?.saveAndValidate() ?? false) {
                      // Form is valid, you can create the Quest object
                      Map<String, dynamic> formData = _fbKey.currentState!.value;
                      final response = await request.postJson(
                        "https://readquest-f02-tk.pbp.cs.ui.ac.id/quest/create-book-quest/",
                        jsonEncode(<String, String>{
                            'name': formData['name'],
                            'desc': formData['desc'],
                            'goal': formData['goal'],
                            'point': formData['point'],
                            'book_id': formData['bookId']
                        })
                      );
                      if(response['status'] == 'success'){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                        content: Text("Berhasil menambahkan World Quest!"),
                        ));
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const QuestPage()),
                        );
                      }else{
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                            content:
                                Text("Terdapat kesalahan, silakan coba lagi."),
                        ));
                      }
                      print(formData);
                      
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuestWorldFormPage extends StatefulWidget {
  @override
  _QuestWorldFormPageState createState() => _QuestWorldFormPageState();
}

class _QuestWorldFormPageState extends State<QuestWorldFormPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Create World Quest'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _fbKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'desc',
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderDropdown(
                  name: 'goal',
                  decoration: InputDecoration(labelText: 'Goal'),
                  items: [
                    DropdownMenuItem(value: 'Readded', child: Text('Readded')),
                    DropdownMenuItem(value: 'Buyed', child: Text('Buyed')),
                    DropdownMenuItem(value: 'Review', child: Text('Review')),
                  ],
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'point',
                  decoration: InputDecoration(labelText: 'Point'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'amount',
                  decoration: InputDecoration(labelText: 'Amount'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_fbKey.currentState?.saveAndValidate() ?? false) {
                      // Form is valid, you can create the Quest object
                      Map<String, dynamic> formData = _fbKey.currentState!.value;
                      print(formData['name']);
                      final response = await request.postJson(
                        "https://readquest-f02-tk.pbp.cs.ui.ac.id/quest/create-world-quest/",
                        jsonEncode(<String, String>{
                            'name': formData['name'],
                            'desc': formData['desc'],
                            'goal': formData['goal'],
                            'point': formData['point'],
                            'amount': formData['amount']
                        })
                      );
                      if(response['status'] == 'success'){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                        content: Text("Berhasil menambahkan World Quest!"),
                        ));
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const QuestPage()),
                        );
                      }else{
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                            content:
                                Text("Terdapat kesalahan, silakan coba lagi."),
                        ));
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: QuestWorldFormPage(),
  ));
}
