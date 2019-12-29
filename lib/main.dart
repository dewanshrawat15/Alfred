import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  TextEditingController nameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();

  FocusNode nameFocusNode = new FocusNode();
  FocusNode usernameFocusNode = new FocusNode();
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: theme,
        accentColor: theme,
      ),
      home: Scaffold(
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
          onPressed: (){},
          child: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
      )
    );
  }

}

// Scaffold(
//   appBar: AppBar(
//     title: Text(
//       "Alfred",
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 24
//       ),
//     ),
//     centerTitle: true,
//   ),
//   floatingActionButton: FloatingActionButton(
//     onPressed: (){},
//     child: Icon(Icons.chevron_right),
//   ),
// ),