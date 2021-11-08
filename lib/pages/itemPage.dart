// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:untitled/pages/homePage.dart';
import 'package:untitled/router/myRoutes.dart';




class ItemPage extends StatelessWidget {
  final String itemHolder ;
  const ItemPage({Key? key, required this.itemHolder}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    goBack(BuildContext context){
      Navigator.popAndPushNamed(context, MyRoutes.homepage);
    }
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(itemHolder), fit: BoxFit.cover)
              
        ),
        child: IconButton(onPressed: (){goBack(context);}, icon: Icon(Icons.arrow_back_ios_new, size: 28, color: Colors.black,) ),
      ),
    );
  }
}

