// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:untitled/pages/favPages.dart';
import 'package:untitled/pages/homePage.dart';
import 'package:untitled/pages/itemPage.dart';
import 'package:untitled/router/myRoutes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      home: const HomePage(),
      routes: {
        MyRoutes.homepage: (context) => HomePage(),
        MyRoutes.itempage: (context) => ItemPage(itemHolder: '',),
        MyRoutes.favpage: (context) => FavouritesPage(),
      },
    );
  }
}

