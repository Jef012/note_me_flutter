import 'dart:convert';

class UserApiModel {
  late UserModel auth;

  UserApiModel({required this.auth});

  UserApiModel.fromJson(Map<String, dynamic> json) {
    if (json['values'] != null) {
      auth = UserModel.fromJson(json['values']);
    }
  }
}

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  String? sId;
  String? mobile;
  String? email;
  String? password;
  int? iV;
  String? token;

  UserModel(
      {this.sId, this.mobile, this.email, this.password, this.iV, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    iV = json['__v'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['password'] = this.password;
    data['__v'] = this.iV;
    data['token'] = this.token;
    return data;
  }
}
