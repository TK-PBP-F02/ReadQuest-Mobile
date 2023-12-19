import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readquest/main/homepage.dart';
import 'package:readquest/widgets/drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
    Widget build(BuildContext context) {
        return Provider(
          create: (_) {
              CookieRequest request = CookieRequest();
              return request;
          },
          child: MaterialApp(
              title: 'Read Quest',
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 75, 183, 58)),
                  useMaterial3: true,
              ),
              home: MyHomePage()),
        );
    }
}

