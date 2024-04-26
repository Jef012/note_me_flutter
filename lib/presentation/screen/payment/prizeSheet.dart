import 'package:carousel_slider/carousel_slider.dart';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note_me/controller/repository/paymentDetailsRepo.dart';
import '../../../models/paymentDetailModels.dart';

class PrizeSheet extends StatefulWidget {
  final QuillController quillDynamicController;

  const PrizeSheet({super.key, required this.quillDynamicController});

  @override
  State<PrizeSheet> createState() => _PrizeSheetState();
}

class _PrizeSheetState extends State<PrizeSheet> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  Future<List<PaymentDetailModel>>? _futurePaymentDetails;

  @override
  void initState() {
    super.initState();
    _futurePaymentDetails = PaymentDetailsRepository().getPaymentDetailList();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<PaymentDetailModel>>(
        future: _futurePaymentDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }
          return Stack(
            children: [
              CarouselSlider.builder(
                itemCount: snapshot.data?.length,
                carouselController: _controller,
                options: CarouselOptions(
                  height: height,
                  enlargeCenterPage: true,
                  animateToClosest: true,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                itemBuilder:
                    (BuildContext context, int index, int pageViewIndex) {
                  var items = snapshot.data![index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            top: height * 0.06,
                            left: width * 0.195,
                            child: Row(
                              children: [
                                Text(
                                  '₹',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: height * 0.15,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          HexColor("#b52d4b").withOpacity(0.4)),
                                ),
                                Text(
                                  '${items.rate}',
                                  style: TextStyle(
                                      fontSize: height * 0.2,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          HexColor("#b52d4b").withOpacity(0.4)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              height: height * 0.27,
                              width: width,
                              decoration: BoxDecoration(
                                  color: HexColor("#b52d4b").withOpacity(0.6),
                                  // gradient: LinearGradient(colors: [
                                  //   HexColor("#b52d4b"),
                                  //   Colors.white10,
                                  //   HexColor("#b52d4b")
                                  // ]),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '₹',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontSize: height * 0.12,
                                          height: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${items.rate}',
                                        style: TextStyle(
                                          fontSize: height * 0.15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Per month",
                                    style: TextStyle(
                                      fontSize: height * 0.03,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      Container(
                          height: height / 2.1,
                          width: width,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 50,
                                    spreadRadius: 5,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: height * 0.05),
                              Text(
                                '${items.title}',
                                style: TextStyle(
                                    fontSize: height * 0.05,
                                    fontWeight: FontWeight.w700,
                                    shadows: const [
                                      // Shadow(
                                      //     color: Colors.black12, blurRadius: 25)
                                    ],
                                    color: Colors.black),
                              ),
                              html.Html(
                                data: """${items.details}""",
                                style: {
                                  "ul": html.Style(
                                    padding: html.HtmlPaddings.only(
                                        left: width * 0.09),
                                    alignment: Alignment.center,
                                  ),
                                },
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  var document =
                                      widget.quillDynamicController.document;
                                  generatePDF(document);
                                },
                                child: Container(
                                    height: height * 0.052,
                                    margin: EdgeInsets.only(
                                      left: width * 0.1,
                                      right: width * 0.1,
                                      // top: height * 0.04,
                                      bottom: width * 0.05,
                                    ),
                                    decoration: BoxDecoration(
                                        color: HexColor("#b52d4b")
                                            .withOpacity(0.8),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "GET",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: height * 0.02),
                                          ),
                                          SizedBox(width: width * 0.02),
                                          Text(
                                            "Started",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: height * 0.02),
                                          ),
                                        ])),
                              ),
                            ],
                          )),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  snapshot.data?.length ?? 0,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: width * 0.01),
                    child: GestureDetector(
                      onTap: () => _controller.animateToPage(index),
                      child: Container(
                        width: height * 0.012,
                        height: height * 0.012,
                        margin: EdgeInsets.only(bottom: height * 0.04),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(_current == index ? 0.9 : 0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> generatePDF(Document document) async {
    try {
      List<Map<String, dynamic>> deltaJson =
          widget.quillDynamicController.document.toDelta().toJson();

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
