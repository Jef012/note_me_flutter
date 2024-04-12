import 'package:note_me/constants/appUrl.dart';

import '../../models/authModel.dart';

import '../../networking/api_base_helper.dart';

class AuthenticationRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future login(data) async {
    final res = await _helper.postLogin("login", data);
    print("res :: $res");
    if (res["meta"]["statusCode"] == 200) {
      UserModel auth = UserModel.fromJson(res["values"]);
      print("Auth ::${auth}");
      return auth;
    } else {
      throw ('${res["meta"]['message']}');
    }
  }

  Future guestUserOtp(data) async {
    final res = await _helper.authenticationPost("guestuser/confirm-otp", data);
    if (res["meta"]["statusCode"] == 200) {
      return res;
    } else {
      throw '${res["meta"]['message']}';
    }
  }

  Future resetPassword(data) async {
    return await _helper.authenticationPost("user/reset-password", data);
  }

  Future signUp(data) async {
    final res = await _helper.authenticationPost("signup", data);
    print("res ::: $res");
    if (res["meta"]["statusCode"] == 200) {
      UserModel auth = UserModel.fromJson(res["values"]);
      print("Auth ::${auth}");
      return auth;
    } else {
      throw ('${res["meta"]["message"]}');
    }
  }

  Future logOut() async {
    final res = await _helper.postWithoutBody("user/logout");
    if (res["meta"]["statusCode"] == 200) {
      return res;
    } else {
      throw ('${res["meta"]['message']}');
    }
  }
}
