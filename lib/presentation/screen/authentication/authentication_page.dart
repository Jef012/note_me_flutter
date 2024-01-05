import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/customBackground.dart';

import 'package:hexcolor/hexcolor.dart';
import 'package:note_me/models/arguments.dart';
import 'package:note_me/presentation/screen/splash_screen.dart';

import 'login_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  UserArguments? userDetails;
  int _selectedIndex = 0;
  double _curlyWaveHeight = 1.0;
  Color _bottomColor = HexColor("#fca272");
  _selectedPage(int index, UserArguments details) {
    setState(() {
      userDetails = details;
      _selectedIndex = index;
      _updateBackground();
    });
  }

  _updateBackground() {
    setState(() {
      _curlyWaveHeight = (_selectedIndex == 0) ? 1.0 : 0.5;
      _bottomColor =
          (_selectedIndex == 0) ? HexColor("#fca272") : HexColor("#fca272");
    });
  }

  _selectedWidget(index) {
    switch (index) {
      case 0:
        return SplashScreen(
          updateWidget: (index, details) => _selectedPage(index, details),
        );
      case 1:
        return LoginPage(
          updateWidget: (index, details) => _selectedPage(index, details),
          userDetails: userDetails ?? UserArguments(),
        );
      // case 2:
      //   return OtpVerification(
      //     updateWidget: (index, details) => _selectedPage(index, details),
      //     userDetails: userDetails,
      //   );
      // case 3:
      //   return ResetPassword(
      //     updateWidget: (index, details) => _selectedPage(index, details),
      //     userDetails: userDetails,
      //   );
      // case 4:
      //   return SignUp(
      //     updateWidget: (index, details) => _selectedPage(index, details),
      //     userDetails: userDetails,
      //   );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [HexColor("#fb7396"), HexColor("#fca272")],
      begin: Alignment.bottomRight,
      end: Alignment.topRight,
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomBackground(
            curlyWaveHeight: _curlyWaveHeight,
            bottomColor: _bottomColor,
          ),
          _selectedWidget(_selectedIndex),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //
      //     },
      //     child: Icon(Icons.arrow_forward_ios_rounded)),
    );
  }
}
