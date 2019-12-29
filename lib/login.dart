import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';
import 'accounts.dart';
import 'home.dart';

final theme = Color(0xffFB8604);

class Login extends StatefulWidget{
  
  @override
  LoginState createState() => LoginState();
  
}

class LoginState extends State<Login>{
  
  TextEditingController nameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();

  FocusNode nameFocusNode = new FocusNode();
  FocusNode usernameFocusNode = new FocusNode();

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

  Future<void> createProfile(Person basicPerson) async{
    final Database db = await connectDatabase();
    await db.insert(
      'accountDetails',
      basicPerson.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 96,
              ),
              Text(
                "Alfred",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40
                ),
                child: Text(
                  "Alfred is a mobile app which helps predict different genres of TV Shows or Movies by just they're poster",
                  style: TextStyle(
                    fontSize: 18
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      autocorrect: false,
                      focusNode: nameFocusNode,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: (){
                        nameFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(usernameFocusNode);
                      },
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: theme
                        )
                      ),
                      controller: nameController,
                    ),
                    SizedBox(
                      height: 32
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      focusNode: usernameFocusNode,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: (){
                        usernameFocusNode.unfocus();
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: theme
                        )
                      ),
                      controller: usernameController,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Person tempProfile = new Person();
          tempProfile.name = nameController.text;
          tempProfile.username = usernameController.text;
          createProfile(tempProfile);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Home()
            )
          );
        },
        child: Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
      ),
    );
  }
}