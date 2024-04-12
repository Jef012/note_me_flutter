import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:note_me/models/authModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  UserModel? userModel;
  // late Account account;

  void updateUser(UserModel user) {
    userModel = user;
    notifyListeners();
  }

  // void updateAccount(Account data) {
  //   account = data;
  //   notifyListeners();
  // }

  // void updateUserProfileDashboard(UserProfileDashboard data) {
  //   userProfileDashboard = data;
  //   notifyListeners();
  // }

  // void updateLocationWithUser(User newUser) {
  //   user = newUser;
  //   notifyListeners();
  // }

  Future<String?> updateNotificationCount(String userDetail) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    var getUserDetails = sharedUser.getString('user');

    if (getUserDetails != null) {
      UserModel userData = UserModel.fromJson(jsonDecode(getUserDetails));

      switch (userDetail) {
        case "sId":
          return userData.sId.toString();

        default:
          return null;
      }
    } else {
      print('User data not found in SharedPreferences.');
      return null;
    }
  }

  void clearState() {
    // user = null;
    // account = null;
    // userWallet = null;
  }
}
