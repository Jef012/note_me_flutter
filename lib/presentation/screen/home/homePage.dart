import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    /// Hello git
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios),
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Note",
                  style: GoogleFonts.robotoCondensed(
                      fontSize: height * 0.045,
                      color: Colors.black,
                      fontWeight: FontWeight.w700)),
              TextSpan(
                  text: "Me",
                  style: GoogleFonts.robotoCondensed(
                      fontSize: height * 0.045,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [HexColor("#fb7396"), HexColor("#fca272")],
                        ).createShader(Rect.fromLTWH(50.0, 100.0, 50.0, 0.0)))),
            ]),
          )),
    );
  }
}
