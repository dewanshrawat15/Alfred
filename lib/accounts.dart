class Person{
  // Basic Details
  String name;
  String username;

  // Constructor
  Person({this.name, this.username});

  Map <String, dynamic> toMap(){
    return {
      'name': name,
      'username': username
    };
  }
}