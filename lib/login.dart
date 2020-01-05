import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

  showAlertDialog(context){
    Widget okButton = FlatButton(
      textColor: Colors.orange,
      child: Text("OK"),
      onPressed: (){
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Please fill in your details."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context){
        return alert;
      }
    );
  }

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
                  fontFamily: "Google Sans"
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
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "Google Sans"
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
                          color: theme,
                          fontFamily: "Google Sans"
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
                          color: theme,
                          fontFamily: "Google Sans"
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
          if(tempProfile.name.length > 0 && tempProfile.username.length > 0){
            createProfile(tempProfile);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Home()
              )
            );
          }
          else{
            showAlertDialog(context);
          }
        },
        child: Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
      ),
    );
  }
}