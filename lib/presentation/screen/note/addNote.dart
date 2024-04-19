import 'dart:convert';
import 'dart:io';

import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_me/presentation/screen/note/pdfViewer.dart';
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';

import '../../../controller/provider/appProvider.dart';

class AddNote extends StatefulWidget {
  final QuillController quillController;
  final bool isNewNote;
  final String noteId;

  const AddNote(
      {super.key,
      required this.quillController,
      required this.isNewNote,
      required this.noteId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  QuillController _quillController = QuillController.basic();
  QuillController? _quillDynamicController;
  String? generatedPdfFilePath;

  @override
  void initState() {
    _quillDynamicController = widget.quillController;
    print("_quillDynamicController ::: $_quillDynamicController");

    super.initState();
  }

  // FlutterNativeHtmlToPdf? _flutterNativeHtmlToPdfPlugin;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppProvider>(context, listen: false).userModel;
    return Scaffold(
      backgroundColor: Colors.white,
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
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
            preferredSize: Size(
                double.infinity, MediaQuery.of(context).size.height * 0.06),
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _quillDynamicController!,
                toolbarIconCrossAlignment: WrapCrossAlignment.end,
                fontSizesValues: const {
                  'Small': '12',
                  'Medium': '25.5',
                  'Large': '45'
                  // 'Small': '7',
                  //   'Medium': '20.5',
                  //   'Large': '40'
                },
                headerStyleType: HeaderStyleType.buttons,
                toolbarSize: MediaQuery.of(context).size.height * 0.06,
                multiRowsDisplay: false,
                toolbarIconAlignment: WrapAlignment.spaceBetween,
                sectionDividerColor: Colors.black,
              ),
            )),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 15, spreadRadius: 5)
        ]),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        child: QuillEditor.basic(
          configurations: QuillEditorConfigurations(
            controller: _quillDynamicController!,
            scrollBottomInset: 50,
            scrollPhysics: BouncingScrollPhysics(),
            readOnly: false,
            autoFocus: true,
            expands: true,
            maxHeight: 25,
          ),
        ),
      ),
    );
  }

  addNote(userId) {
    print("widget.isNewNote :: ${widget.isNewNote}");
    String quillDocumentJson =
        jsonEncode(_quillDynamicController!.document.toDelta().toJson());
    print("quillDocumentJson ::: $quillDocumentJson");
    if (_quillDynamicController!.document.isEmpty()) {
      print("Note is Empty");
    } else {
      showDialog(
        context: context,
        barrierColor: Colors.black12,
        builder: (BuildContext context) {
          List deltaJson = _quillDynamicController!.document.toDelta().toJson();
          print(DeltaToHTML.encodeJson(deltaJson));
          return Dialog(
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black38),
              ),
              child: Column(
                children: [
                  Text(
                    "Successfully saved",
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      final deltaOps = _quillDynamicController!.document;
                      generatePDF(deltaOps);
                      print("deltaOps ::::: $deltaOps");
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );

      // print("Note is not Empty");
      // if (widget.isNewNote) {
      //   NoteRepository().addNote(
      //       {"userId": userId, "title": "Title", "content": quillDocumentJson});
      // } else {
      //   NoteRepository().editNote(
      //       {"userId": userId, "title": "Title", "content": quillDocumentJson},
      //       widget.noteId);
      // }
    }
  }

  Future<void> generatePDF(Document document) async {
    try {
      List<Map<String, dynamic>> deltaJson =
          _quillDynamicController!.document.toDelta().toJson();

      List<Map<String, dynamic>> removeFFfromColor(
          List<Map<String, dynamic>> deltaJson) {
        List<Map<String, dynamic>> modifiedDeltaJson =
            List<Map<String, dynamic>>.from(deltaJson);

        for (var item in modifiedDeltaJson) {
          if (item.containsKey('attributes') && item['attributes'] != null) {
            var attributes = item['attributes'];

            if (attributes.containsKey('color') &&
                attributes['color'] != null) {
              var color = attributes['color'];
              if (color is String &&
                  color.length == 9 &&
                  color.startsWith('#FF')) {
                var newColor = '#${color.substring(3)}';
                attributes['color'] = newColor;
              }
            }
            if (attributes.containsKey('background') &&
                attributes['background'] != null) {
              var backgroundColor = attributes['background'];
              if (backgroundColor is String &&
                  backgroundColor.length == 9 &&
                  backgroundColor.startsWith('#FF')) {
                var newBackgroundColor = '#${backgroundColor.substring(3)}';
                attributes['background'] = newBackgroundColor;
              }
            }
          }
        }

        return modifiedDeltaJson;
      }

      String htmlContent = DeltaToHTML.encodeJson(removeFFfromColor(deltaJson));
      print("htmlContent :: $htmlContent");
      const filePath = '/storage/emulated/0/Download/';

      await FlutterHtmlToPdf.convertFromHtmlContent(
          "<div style='padding: 30px;'>$htmlContent</div>",
          filePath,
          "newDocument6");

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => Viewer(
      //               deltaJson: deltaJson,
      //             )));
      print(
          "htmlContent with padding :: <div style='padding: 20px;'>$htmlContent</div>");
      print('PDF generated successfully at $filePath');
    } catch (e, stackTrace) {
      print('Error generating PDF: $e');
      print(stackTrace);
    }
  }
}
