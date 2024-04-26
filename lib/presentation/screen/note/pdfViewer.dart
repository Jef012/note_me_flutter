import 'dart:typed_data';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';

class Viewer extends StatefulWidget {
  final List deltaJson;

  const Viewer({Key? key, required this.deltaJson}) : super(key: key);

  @override
  State<Viewer> createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Viewer'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(20), child: Container()),
      ),
    );
  }
}
