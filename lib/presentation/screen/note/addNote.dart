import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_quill/flutter_quill.dart';

import 'package:hexcolor/hexcolor.dart';

import 'package:note_me/presentation/widgets/customExpansionTile.dart';
import 'package:provider/provider.dart';
import '../../../controller/provider/appProvider.dart';
import '../../../controller/repository/noteRepo.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  QuillController _quillController = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppProvider>(context, listen: false).userModel;
    return Scaffold(
      backgroundColor: Colors.white10, //HexColor("EDF5FCFF"),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(Icons.arrow_back_ios)),
        actions: [
          TextButton(
            onPressed: () {
              print("<<<<<<<<<< ${user?.sId}");
              addNote(user?.sId);
            },
            child: Text("Done"),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _quillController,
                toolbarIconCrossAlignment: WrapCrossAlignment.start,
                fontSizesValues: const {
                  'Small': '7',
                  'Medium': '20.5',
                  'Large': '40'
                },
                toolbarSize: MediaQuery.of(context).size.height * 0.1,
                sectionDividerSpace: 2,
                multiRowsDisplay: false,
                sectionDividerColor: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: _quillController,
                  readOnly: false,
                  maxHeight: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  addNote(userId) {
    String quillDocumentJson =
        jsonEncode(_quillController.document.toDelta().toJson());
    NoteRepository().addNote(
        {"userId": userId, "title": "Title", "content": quillDocumentJson});
  }
}
