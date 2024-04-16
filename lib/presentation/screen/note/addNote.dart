import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:quill_pdf_converter/quill_pdf_converter.dart';
import 'package:share_plus/share_plus.dart';

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

  @override
  void initState() {
    _quillDynamicController = widget.quillController;
    print("_quillDynamicController ::: $_quillDynamicController");
    super.initState();
  }

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
                  'Small': '7',
                  'Medium': '20.5',
                  'Large': '40'
                },
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

  double getBottomInsets() {
    if (MediaQuery.of(context).viewInsets.bottom >
        MediaQuery.of(context).viewPadding.bottom) {
      return MediaQuery.of(context).viewInsets.bottom -
          MediaQuery.of(context).viewPadding.bottom;
    }
    return 0;
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
                      _shareDocument(context);
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

  // Future<void> _shareDocument(BuildContext context) async {
  //   var jsonData = _quillController.document.toDelta().toJson();
  //   var json = jsonEncode(jsonData);
  //
  //   final pdf = pw.Document();
  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Center(
  //           child: pw.Text(json),
  //         );
  //       },
  //     ),
  //   );
  //
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //
  //   File pdfFile = File('$tempPath/document.pdf');
  //   await pdfFile.writeAsBytes(await pdf.save());
  //
  //   Share.shareFiles([pdfFile.path]);
  // }

  Future<void> _shareDocument(BuildContext context) async {
    final pdfWidgets = await _quillController.document.toDelta().toPdf();

    // Generate a PDF document from the Quill document content
    final pdf = pw.Document();
    for (var widget in pdfWidgets) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return widget;
          },
        ),
      );
    }

    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Write the PDF document to a file in the temporary directory
    File pdfFile = File('$tempPath/document.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Share the temporary PDF file
    Share.shareFiles([pdfFile.path]);

    // Save the PDF file to the downloads directory
    await _saveToDownloads(pdfFile);
  }

  Future<void> _saveToDownloads(File pdfFile) async {
    // Get the application documents directory
    final dir = await getApplicationDocumentsDirectory();

    // Generate a filename for the PDF file
    final filename = 'document.pdf';

    // Write the PDF file to the application documents directory
    final savedFile = await _storeFile(filename, await pdfFile.readAsBytes());

    // Show a notification or message indicating the file has been saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF file saved to ${savedFile.path}'),
      ),
    );
    print("savedFile.path ::: ${savedFile.path}");
  }

  Future<File> _storeFile(String filename, List<int> bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
