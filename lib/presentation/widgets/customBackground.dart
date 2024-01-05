import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomBackground extends StatelessWidget {
  final double curlyWaveHeight;
  final Color bottomColor;
  CustomBackground(
      {super.key, required this.curlyWaveHeight, required this.bottomColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 700),
            height: MediaQuery.of(context).size.height * curlyWaveHeight,
            child: CustomPaint(
              size: Size(400, MediaQuery.of(context).size.height),
              painter: CurlyWavePainter(),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [bottomColor, HexColor("#fb7396")],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurlyWavePainter extends CustomPainter {
  //HexColor("F378A1FF")F378A1FF
  //HexColor("F3955FFF")F3955FFF
  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [HexColor("#fb7396"), HexColor("#fca272")],
      begin: Alignment.bottomRight,
      end: Alignment.topRight,
    );
    final paint = Paint()
      ..shader = gradient
          .createShader(Rect.fromPoints(Offset(0, 0), Offset(0, size.height)))
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, size.height * 0.5);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.7,
      size.width * 0.35,
      size.height * 0.6,
    );

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.42,
      size.width * 0.8,
      size.height * 0.48,
    );

    path.quadraticBezierTo(
      size.width * 1,
      size.height * 0.52,
      size.width * 1,
      size.height * 0.35,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
