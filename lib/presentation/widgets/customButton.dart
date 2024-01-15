import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final dynamic icon;
  final Color color;
  final double width;
  final double height;
  final VoidCallback onTap;
  const CustomButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.color,
      required this.width,
      required this.height,
      required this.onTap});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: AssetImage(widget.icon),
                width: width * 0.055,
                height: height * 0.055,
                color: Colors.black54,
                fit: BoxFit.contain),
            SizedBox(width: width * 0.01),
            Text(
              widget.title,
              style: GoogleFonts.robotoCondensed(
                color: Colors.black54,
                fontSize: height * 0.017,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
