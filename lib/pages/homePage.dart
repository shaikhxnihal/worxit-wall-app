// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:getwidget/getwidget.dart';
import 'package:untitled/pages/itemPage.dart';
import 'package:untitled/router/myRoutes.dart';
import 'package:untitled/utils/Photos.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isClicked = true;
  double spaceBetween = 10.0;
  List data = [];

  bool showImg = false;
  getData() async{
    http.Response response = await http.get(Uri.parse('https://api.unsplash.com/photos/?client_id=oawDJYo_xEMbmiFOhkyWQGHR_mDsKMELjDXbZe8vW7Y'));
    data = json.decode(response.body);
    setState(() {
      showImg = true;
    });
  }
  final _duration = Duration(milliseconds: 200);
  _onStartScroll(ScrollMetrics metrics) {
    // if you need to do something at the start
  }
  _onUpdateScroll(ScrollMetrics metrics) {
    // do your magic here to change the value
    if(spaceBetween == 30.0) return;
    spaceBetween = 30.0;
    setState((){});
  }
  _onEndScroll(ScrollMetrics metrics) {
    // do your magic here to return the value to normal
    spaceBetween = 10.0;
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    Color BTNcolor = isClicked ? Colors.black: Colors.white;
    final height =  MediaQuery.of(context).size.height;
    final width =  MediaQuery.of(context).size.width;

    getItemAndNavigate(String item, BuildContext context){
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ItemPage(itemHolder: item)),
                (route) => false);
      });
    }

    return Scaffold(
      backgroundColor: isClicked ? Colors.white: Colors.black12,


      appBar: AppBar(
        backgroundColor: isClicked ?  Colors.white: Colors.black,
        elevation: 0,
        title: Text("Worxit", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),),
        actions: [Padding(
          padding: const EdgeInsets.only(top: 20, right: 20),
          child: GFToggle(
            enabledThumbColor: Colors.amber,
              disabledThumbColor: Colors.amber,
              enabledTrackColor: Colors.black ,
              disabledTrackColor: Colors.white,
              onChanged: (value){
            setState(() {
              isClicked = !isClicked;
            }
            );
          }, value: true),
        ),]
      ),
      
      body: showImg ? Text("loading..."): PhotoList(),

      bottomNavigationBar: BottomAppBar(

        color: Colors.transparent,
        child: Container(
          height: height / 15,
          decoration: BoxDecoration(
              color: isClicked ? Colors.white : Colors.black,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: IconButton(onPressed: (){}, icon: Icon(Icons.home_outlined, color: BTNcolor, size: 32,)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: IconButton(onPressed: (){
                  Navigator.popAndPushNamed(context, MyRoutes.favpage);
                }, icon: Icon(Icons.favorite_outline, color: BTNcolor, size: 32,)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: IconButton(onPressed: (){}, icon: Icon(Icons.search_outlined, color: BTNcolor, size: 32,)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: IconButton(onPressed: (){}, icon: Icon(Icons.person_outline, color: BTNcolor, size: 32,)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}