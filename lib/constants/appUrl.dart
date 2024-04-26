import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrls {
  static var baseApi =
      "http://192.168.5.108:5000/api"; //dotenv.get('BASE_URL');
  static var signUp = "signup";
  static var logIn = "login";
  static var getAllNotes = "notes/list";
  static var addNote = "notes/add";
  static var deleteNote = "notes/delete";
}
