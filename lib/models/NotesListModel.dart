class NotesListApiModel {
  List<NotesListModel>? values;
  NotesListApiModel({this.values});
  NotesListApiModel.fromJson(Map<String, dynamic> json) {
    if (json['values'] != null) {
      values = <NotesListModel>[];
      json['values'].forEach((v) {
        values!.add(NotesListModel.fromJson(v));
      });
    }
  }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.values != null) {
  //     data['values'] = this.values!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class NotesListModel {
  String? sId;
  String? userId;
  String? title;
  String? content;
  String? date;

  NotesListModel({this.sId, this.userId, this.title, this.content, this.date});

  NotesListModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    title = json['title'];
    content = json['content'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date'] = this.date;
    return data;
  }
}
