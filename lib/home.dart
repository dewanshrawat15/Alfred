import 'package:alfred/login.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget{
  
  @override
  HomeState createState() => HomeState();

}

class HomeState extends State<Home>{

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

  Future<void> deleteAccount() async{
    final Database db = await connectDatabase();
    db.execute(
      "DELETE from accountDetails"
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontFamily: "Google Sans",
            fontSize: 22,
            color: Colors.white
          )
        ),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: (){
              deleteAccount();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login()
                )
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18, vertical: 8
              ),
              child: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

}