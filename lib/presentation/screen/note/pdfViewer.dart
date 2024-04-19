import 'dart:typed_data';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Viewer extends StatefulWidget {
  final List deltaJson;

  const Viewer({Key? key, required this.deltaJson}) : super(key: key);

  @override
  State<Viewer> createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    final htmlData = DeltaToHTML.encodeJson(widget.deltaJson);
    print("htmlData ::: $htmlData");

    // pdf.addPage(
    //   pw.Page(
    //     build: (pw.Context context) {
    //       return pw.Center(
    //         child: pw.Document(title: htmlData),
    //       );
    //     },
    //   ),
    // );

    // Save the PDF as bytes
    return await pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Viewer'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              final pdfBytes = await generatePdf();
              Printing.sharePdf(bytes: pdfBytes, filename: 'document.pdf');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Html(
            data: DeltaToHTML.encodeJson(widget.deltaJson),
          ),
        ),
      ),
    );
  }
}
