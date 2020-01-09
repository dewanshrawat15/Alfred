import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget{
  
  Map results;
  File imageFile;
  ResultScreen({this.imageFile, this.results});

  @override
  ResultScreenState createState() => ResultScreenState(imageFile: imageFile, results: results);

}

class ResultScreenState extends State<ResultScreen>{
  Map results;
  File imageFile;

  List<Widget> listOfTiles = [];

  @override
  void initState(){
    int i = 0;
    for(i = 0; i < results["results"].length; i++){
      var temp = ListTile(
        title: Text(
          results["results"][i]["class"],
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Google Sans"
          ),
        ),
        subtitle: Text(
          "I am " + results["results"][i]["confidence"] + "% confident.",
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Google Sans"
          )
        ),
      );
      listOfTiles.add(temp);
    }
  }
  
  ResultScreenState({this.imageFile, this.results});
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text(
          "Results",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12
                ),
                child: Text(
                  "I feel this Movie / TV show has genre",
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: "Google Sans"
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16
                ),
                child: Image.file(File(imageFile.path)),
              ),
              SizedBox(
                height: 20,
              ),
              for (Widget i in listOfTiles) i
            ],
          ),
        ),
      )
    );
  }

}