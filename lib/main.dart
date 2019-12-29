import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'login.dart';
import 'home.dart';

final theme = Color(0xffFB8604);

void main(){
  runApp(App());
}

class App extends StatefulWidget{
  
  @override
  AppState createState() => AppState();

}

class AppState extends State<App>{

  connectDatabase() async{
    Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE accountDetails(name TEXT, username TEXT)",
        );
      },
      version: 1
    );
    return database;
  }

  Future<int> getNumberOfRecords() async{
    final Database db = await connectDatabase();

    final List<Map<String, dynamic>> maps = await db.query('accountDetails');
    return maps.length;
  }

  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: theme,
        accentColor: theme,
      ),
      home: FutureBuilder(
        future: getNumberOfRecords(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          print(snapshot.data);
          if(snapshot.data == 0){
            return Login();
          }
          else{
            return Home();
          }
        },
      )
    );
  }

}