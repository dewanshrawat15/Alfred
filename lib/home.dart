import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'login.dart';
import 'api.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

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

  fetchMovies() async{
    var data = await http.get(apiEndpoint);
    var result = json.decode(data.body.toString());
    return result["results"];
  }

  File imageFile;

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageFile = image;
    });
  }

  fetchResults() async{
    var stream = http.ByteStream.fromBytes(imageFile.readAsBytesSync());
    var length = await imageFile.length();
    var uri = Uri.parse(modelEndpointAPI);

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('image', stream, length, filename: basename(imageFile.path));
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);

  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageFile = image;
    });
  }

  fetchShows() async{
    var data = await http.get(tvShowsEndpoint);
    var result = json.decode(data.body.toString());
    return result["results"];
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 32,
              ),
              Text(
                "Top 5 Movies",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Google Sans"
                ),
              ),
              SizedBox(
                height: 32,
              ),
              StreamBuilder(
                stream: fetchMovies().asStream(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        if(index < 5){
                          return ListTile(
                            title: Text(
                              snapshot.data[index]["title"]
                            ),
                            subtitle: Text(
                              snapshot.data[index]["overview"]
                            ),
                            trailing: Text(
                              snapshot.data[index]["vote_average"].toString()
                            ),
                          );
                        }
                        else{
                          return null;
                        }
                      },
                    );
                  }
                  else{
                    return Center(
                      child: Column(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 42,
                          ),
                          Text(
                            "Fetching the latest data"
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                "Top 5 TV Shows",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Google Sans"
                ),
              ),
              SizedBox(
                height: 32,
              ),
              StreamBuilder(
                stream: fetchShows().asStream(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        if(index < 5){
                          return ListTile(
                            title: Text(
                              snapshot.data[index]["name"]
                            ),
                            subtitle: Text(
                              snapshot.data[index]["overview"]
                            ),
                            trailing: Text(
                              snapshot.data[index]["vote_average"].toString()
                            ),
                          );
                        }
                        else{
                          return null;
                        }
                      },
                    );
                  }
                  else{
                    return Center(
                      child: Column(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 42,
                          ),
                          Text(
                            "Fetching the latest data"
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 150,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'From Gallery',
            onPressed: () async {
              if(imageFile != null){
                await fetchResults();
                print("Recieved gallery results");
              }
            },
            backgroundColor: Colors.orange,
            child: Icon(
              Icons.photo_library,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          FloatingActionButton(
            heroTag: 'From Camera',
            onPressed: () async {
              getImageFromCamera();
              print("Camera request");
              await fetchResults();
              print("Recieved camera results");
            },
            backgroundColor: Colors.orange,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          )
        ],
      )
    );
  }

}