import 'dart:convert';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../../controller/provider/appProvider.dart';
import '../../../controller/repository/noteRepo.dart';

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

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppProvider>(context, listen: false).userModel;

    return Hero(
      tag: widget.noteId,
      child: Material(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context, true);
                },
                icon: Icon(Icons.arrow_back_ios)),
            actions: [
              TextButton(
                onPressed: () {
                  addNote(user?.sId);

                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Text("Save"),
              ),
            ],
            scrolledUnderElevation: 0,
            bottom: PreferredSize(
                preferredSize: Size(double.infinity,
                    MediaQuery.of(context).size.height * 0.065),
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 12)),
                  ], color: Colors.white),
                  child: QuillToolbar.simple(
                    configurations: QuillSimpleToolbarConfigurations(
                        controller: _quillDynamicController!,
                        toolbarIconCrossAlignment: WrapCrossAlignment.end,
                        fontSizesValues: const {
                          'Extra Small': '8',
                          'Small': '13',
                          'Medium': '17',
                          'Large': '24',
                          'Extra Large': '32',
                          'Huge': '48',
                          // 'Small': '12',
                          // 'Medium': '20.5',
                          // 'Large': '40'
                        },
                        headerStyleType: HeaderStyleType.buttons,
                        toolbarSize: MediaQuery.of(context).size.height * 0.06,
                        multiRowsDisplay: false,
                        toolbarIconAlignment: WrapAlignment.spaceBetween,
                        sectionDividerColor: Colors.white,
                        color: Colors.white),
                  ),
                )),
          ),
          body: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _quillDynamicController!,
                scrollBottomInset: 50,
                scrollPhysics: BouncingScrollPhysics(),
                readOnly: false,
                autoFocus: false,
                expands: true,
                maxHeight: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  addNote(userId) {
    print("widget.isNewNote :: ${widget.isNewNote}");
    String quillDocumentJson =
        jsonEncode(_quillDynamicController!.document.toDelta().toJson());
    // print("quillDocumentJson ::: $quillDocumentJson");
    if (_quillDynamicController!.document.isEmpty()) {
      print("Note is Empty");
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          FocusScope.of(context).unfocus();
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.47,
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -MediaQuery.of(context).size.height * 0.12,
                    left: MediaQuery.of(context).size.width * 0.01,
                    child: Image.asset(
                      "assets/image/savePopup.png",
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2),
                        Text(
                          "Save Changes",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.024,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Do you want to Save changes?",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.018,
                              color: Colors.black26,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.018),
                            Expanded(
                              child: customButton(
                                  title: "Save",
                                  backgroundColor: HexColor("#b52d4b"),
                                  textColor: Colors.white,
                                  onTap: () {
                                    print("Note is not Empty");
                                    if (widget.isNewNote) {
                                      print("addNote");
                                      NoteRepository().addNote({
                                        "userId": userId,
                                        "title": "Title",
                                        "content": quillDocumentJson
                                      });
                                    } else {
                                      print("editNote");
                                      NoteRepository().editNote({
                                        "userId": userId,
                                        "title": "Title",
                                        "content": quillDocumentJson
                                      }, widget.noteId);
                                    }
                                  }),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.017),
                            Expanded(
                              child: customButton(
                                  title: "Cancel",
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  onTap: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.018),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.018),
                        InkWell(
                          onTap: () {
                            final deltaOps = _quillDynamicController!.document;

                            Navigator.of(context).pushNamed("/prizeSheet",
                                arguments: {
                                  "quillController": _quillDynamicController
                                });
                            // generatePDF(deltaOps);
                            print("deltaOps ::::: $deltaOps");
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.048,
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.018,
                              right: MediaQuery.of(context).size.height * 0.018,
                            ),
                            decoration: BoxDecoration(
                              color: HexColor("#b52d4b").withOpacity(0.2),
                              border: Border.all(
                                  color: HexColor("#b52d4b").withOpacity(0.5)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/image/export-pdf.png",
                                    color: HexColor("#b52d4b"),
                                    height: MediaQuery.of(context).size.height *
                                        0.02),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.015),
                                Text(
                                  "Export",
                                  style: GoogleFonts.robotoCondensed(
                                    color: HexColor("#b52d4b"),
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.017,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        // customButton(
                        //     title: "Cancel",
                        //     backgroundColor: Colors.black,
                        //     textColor: Colors.white,
                        //     onTap: () {
                        //       final deltaOps = _quillDynamicController!.document;
                        //       generatePDF(deltaOps);
                        //       print("deltaOps ::::: $deltaOps");
                        //     }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget customButton({onTap, title, textColor, backgroundColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.048,
        width: MediaQuery.of(context).size.width * 0.22,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.047,
        ),
        decoration: BoxDecoration(
            color: backgroundColor, //HexColor("#b52d4b"),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.robotoCondensed(
                color: textColor, //Colors.black54,
                fontSize: MediaQuery.of(context).size.height * 0.017,
              ),
            ),
          ],
        ),
      ),
    );
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

      print(
          "htmlContent with padding :: <div style='padding: 20px;'>$htmlContent</div>");
      print('PDF generated successfully at $filePath');
    } catch (e, stackTrace) {
      print('Error generating PDF: $e');
      print(stackTrace);
    }
  }
}
