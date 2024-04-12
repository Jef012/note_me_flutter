import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

QuillController _quillController = QuillController.basic();

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
