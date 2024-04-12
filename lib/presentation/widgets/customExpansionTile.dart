import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CustomExpansionTile extends StatefulWidget {
  final QuillController quillController;
  final String content;

  const CustomExpansionTile(
      {super.key, required this.content, required this.quillController});

  @override
  CustomExpansionTileState createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  bool isExpand = false;
  late AnimationController _controller;
  double begin = 0.0;
  double end = 0.25;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (status) {
        setState(() {
          isExpand = status;
          _controller.reset();
          if (isExpand) {
            begin = 0.0;
            end = 0.25;
            _controller.forward();
          } else {
            begin = 0.25;
            end = 0.0;
            _controller.forward();
          }
        });
      },
      trailing: RotationTransition(
        turns: Tween(begin: begin, end: end).animate(_controller),
        child: Icon(
          Icons.arrow_forward_ios,
          size: 16.0,
          // color: isExpand ? kPurple : kDusk,
        ),
      ),
      initiallyExpanded: false,
      title: QuillToolbar.simple(
          configurations: QuillSimpleToolbarConfigurations(
        controller: widget.quillController,
        showSubscript: false,
        showColorButton: true,
        showDirection: false,
        showDividers: false,
        showIndent: false,
        showItalicButton: false,
        showJustifyAlignment: false,
        showRightAlignment: false,
        showLeftAlignment: false,
        showLink: false,
        showListBullets: false,
        showListCheck: false,
        showListNumbers: false,
        showQuote: false,
        showSmallButton: false,
        showUnderLineButton: false,
        showStrikeThrough: false,
        showCodeBlock: false,
        showInlineCode: false,
        showSuperscript: false,
        showFontFamily: false,
        showBackgroundColorButton: false,
        sectionDividerColor: Colors.black,
      )),
      children: [
        QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
          controller: widget.quillController,
          showSubscript: false,
          showCodeBlock: false,
          showInlineCode: false,
          showSuperscript: false,
          showFontFamily: false,
          showRedo: false,
          showUndo: false,
          showFontSize: false,
          showHeaderStyle: false,
          showColorButton: false,
          showBackgroundColorButton: false,
          sectionDividerColor: Colors.black,
        )),
      ],
    );
  }
}
