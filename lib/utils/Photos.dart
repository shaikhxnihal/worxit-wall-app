// ignore_for_file: prefer_const_constructors, file_names

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/router/myRoutes.dart';
import 'package:dio/dio.dart';
import 'package:wallpaperplugin/wallpaperplugin.dart';


class PhotoList extends StatefulWidget {

  const PhotoList({Key? key,}) : super(key: key);

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {

  double spaceBetween = 10.0;
  final _duration = Duration(milliseconds: 1000);
  _onStartScroll(ScrollMetrics metrics) {
    // if you need to do something at the start
  }
  _onUpdateScroll(ScrollMetrics metrics) {
    // do your magic here to change the value
    if(spaceBetween == 50.0) return;
    spaceBetween = 50.0;
    setState((){

    });
  }
  _onEndScroll(ScrollMetrics metrics) {
    // do your magic here to return the value to normal
    spaceBetween = 10.0;
    setState((){});
  }
  late String _localPath;

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

  //Storage Permission
  static Future<bool?> _checkAndGetPermission() async{
    final PermissionStatus permission= await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if(permission!=PermissionStatus.granted){
      final Map<PermissionGroup,PermissionStatus> permissions=await PermissionHandler()
          .requestPermissions(<PermissionGroup>[PermissionGroup.storage]);
      if(permissions[PermissionGroup.storage] != PermissionStatus.granted){
        return null;
      }
    }
    return true;
  }
  //

  //-----------//
  //AlertBox
  final _platform = Platform.operatingSystem;

  _onTapProcess(context, values) {
    return CupertinoAlertDialog(
      title: new Text("Set As Wallpaper"),
      content: Text('click Yes to set wallpaper'),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes!'),
          onPressed: () async {
            if (_checkAndGetPermission() != null) {
              Dio dio = Dio();
              final Directory? appdirectory =
              await getExternalStorageDirectory();
              final Directory directory =
              await Directory(appdirectory!.path + '/wallpapers')
                  .create(recursive: true);
              final String dir = directory.path;
              String localPath = '$dir/myImages.jpeg';
              try {
                dio.download(values, localPath);
                setState(() {
                  _localPath = localPath;
                });
                Wallpaperplugin.setAutoWallpaper(localFile: _localPath);
              } on PlatformException catch (e) {
                print(e);
              }
              Navigator.pop(context);
            } else {}
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  //-------//
  bool _isFav = true;
  @override
  Widget build(BuildContext context) {
    final height =  MediaQuery.of(context).size.height;
    final width =  MediaQuery.of(context).size.width;
    getData();

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollStartNotification) {
          _onStartScroll(scrollNotification.metrics);
        } else if (scrollNotification is ScrollUpdateNotification) {
          _onUpdateScroll(scrollNotification.metrics);
        } else if (scrollNotification is ScrollEndNotification) {
          _onEndScroll(scrollNotification.metrics);
        }
        return true; // see docs
      },
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index){

            return

              Column(
                children: [
                  Card(
                    color: Colors.transparent,
                    elevation: 0,
                    margin: EdgeInsets.all(10),
                    child: Container(

                        color: Colors.transparent,


                        child: Stack(children: [
                          Container(
                              height: height / 1.4,
                              width: width / 1,
                              child: ClipRRect(child: !showImg ? Text("loading...") : Image.network(imgUrl.elementAt(index), fit: BoxFit.cover, ), borderRadius: BorderRadius.circular(30), )),
                          Padding(
                            padding:  EdgeInsets.only(top: height / 1.6, left: width / 40),
                            child: GestureDetector(
                              onTap: (){
                                showDialog(context: context, builder: (context) => _onTapProcess(context, data[index]['urls']['regular']));
                              },
                              child: Container(
                                height: height / 15,
                                width: width / 2,
                                decoration: BoxDecoration(
                                    color:  Colors.amber,
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Center(
                                  child: Text("Set as Wallpaper", style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top: height / 1.6, left: width / 1.3),
                            child: CircleAvatar(
                              radius: height / 30,
                              backgroundColor: Colors.amber,
                              child: Center(
                                child: IconButton(onPressed: (){
                                  setState(() {
                                    _isFav = !_isFav;
                                  });
                                  Fluttertoast.showToast(msg: _isFav ? "Removed from favourites": "Added to favourites");
                                }, icon: Icon( _isFav ? Icons.favorite_outline : Icons.favorite, size: 28, color: _isFav ? Colors.black : Colors.pink,)),
                              ),
                            )
                          )
                        ]) ),


                  ),
                  AnimatedContainer(duration: _duration, height: spaceBetween),
                ],
              );


          }),
    );
  }
}

