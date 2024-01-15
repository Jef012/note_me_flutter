import 'package:flutter/material.dart';

class CustomDivider extends StatefulWidget {
  final double indentWidth;
  final double endIndentWidth;
  final double thickness;
  const CustomDivider(
      {super.key,
      required this.thickness,
      required this.indentWidth,
      required this.endIndentWidth});

  @override
  State<CustomDivider> createState() => _CustomDividerState();
}

class _CustomDividerState extends State<CustomDivider> {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.black26,
      thickness: widget.thickness,
      indent: widget.indentWidth,
      endIndent: widget.endIndentWidth,
    );
  }
}
