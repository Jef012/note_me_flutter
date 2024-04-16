import 'package:note_me/constants/appUrl.dart';

import '../../models/NotesListModel.dart';
import '../../models/authModel.dart';

import '../../networking/api_base_helper.dart';

class NoteRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<NotesListModel>> getNoteList(userId) async {
    final res = await _helper.get(
      "notes/list?userId=$userId",
    );
    if (res["meta"]["statusCode"] == 200) {
      List<NotesListModel>? list = NotesListApiModel.fromJson(res).values;
      return list!;
    } else {
      throw ('${res["meta"]['message']}');
    }
  }

  Future addNote(data) async {
    final res = await _helper.post("notes/add", data);
    print("res :: $res");
    if (res["meta"]["statusCode"] == 200) {
      var auth = UserModel.fromJson(res["values"]);
      print("Auth ::${auth}");
      return auth;
    } else {
      throw ('${res["meta"]['message']}');
    }
  }

  Future editNote(data, noteId) async {
    final res = await _helper.put("notes/edit/$noteId", data);
    print("res :: $res");
    if (res["meta"]["statusCode"] == 200) {
      var auth = UserModel.fromJson(res["values"]);
      print("Auth ::${auth}");
      return auth;
    } else {
      throw ('${res["meta"]['message']}');
    }
  }

  Future deleteNote(userId) async {
    final res = await _helper.delete("notes/delete?userId=$userId");
    print("res :: $res");
    if (res["meta"]["statusCode"] == 200) {
      var auth = UserModel.fromJson(res["values"]);
      print("Auth ::${auth}");
      return auth;
    } else {
      throw ('${res["meta"]['message']}');
    }
  }
}

//1499
