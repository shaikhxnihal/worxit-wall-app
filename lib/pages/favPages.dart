import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/router/myRoutes.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List data = [];
  List<String> imgUrl = [];
  bool showImg = false;
  getData() async{
    http.Response response = await http.get(Uri.parse('https://api.unsplash.com/photos/?client_id=oawDJYo_xEMbmiFOhkyWQGHR_mDsKMELjDXbZe8vW7Y'));
    data = json.decode(response.body);
    _assign();
    setState(() {
      showImg = true;
    });
  }
  _assign(){
    for(var i = 0; i < data.length; i++){
      imgUrl.add(data.elementAt(i)["urls"]["regular"]);
    }
  }
  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.popAndPushNamed(context, MyRoutes.homepage);
        }, icon: Icon(Icons.arrow_back_ios_new),),
        title: Text("Favourites", style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          physics: BouncingScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
        children:
          List.generate(data.length, (index) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imgUrl.elementAt(index)),
                  fit: BoxFit.cover
                ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(20.0)
              ),
            ),);
          })
        ,),
      ),
    );
  }
}
