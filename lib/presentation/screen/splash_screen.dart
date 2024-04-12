import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:note_me/models/arguments.dart';
import 'package:note_me/models/authModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/provider/appProvider.dart';

class SplashScreen extends StatefulWidget {
  final Function updateWidget;
  const SplashScreen({super.key, required this.updateWidget});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool checkUser = false;
  bool isLoading = false;
  checkUserData() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    var userDataString = sharedUser.getString('user');
    var userString = sharedUser.getString('authToken');

    print("userDataString :::::::: $userDataString");
    print("userString :::::::: $userString");
    if (userDataString != null) {
      checkUser = true;
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.updateUser(userFromJson(userDataString));
      // appProvider.updateUser(UserModel(token: userDataString));
    } else {
      checkUser = false;
    }
  }

  void navigate() {
    checkUserData();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isLoading = true;
      });
      if (checkUser) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        widget.updateWidget(1, UserArguments(newUser: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("WELCOME TO",
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 25, color: HexColor("#a9a8a8"))),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Note",
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 60,
                          color: Colors.black,
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: "Me",
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [
                                HexColor("#fb7396"),
                                HexColor("#fca272")
                              ],
                            ).createShader(
                                Rect.fromLTWH(50.0, 100.0, 50.0, 0.0)))),
                ]),
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.25,
                right: MediaQuery.of(context).size.width * 0.06),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  textAlign: TextAlign.right,
                  "Words penned, \nthoughts captured, \nstories begin",
                  style: GoogleFonts.firaSans(
                      color: Colors.black54, fontSize: 28, height: 1.3),
                ))),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
                onPressed: () {
                  navigate();
                },
                child: !isLoading
                    ? Icon(Icons.arrow_forward_ios_rounded)
                    : CircularProgressIndicator()),
          ),
        )
      ],
    );
  }
}
