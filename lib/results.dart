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
  
  @override
  initState(){
    print(results);
  }
  
  ResultScreenState({this.imageFile, this.results});
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Results"
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: results["results"].length,
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            child: ListTile(
              title: Text(
                results["results"][index]["class"]
              ),
            ),
          );
        },
      ),
    );
  }

}