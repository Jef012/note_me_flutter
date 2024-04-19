import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/provider/appProvider.dart';
import '../../../controller/repository/authenticationRepo.dart';
import '../../../controller/repository/noteRepo.dart';
import '../../../models/NotesListModel.dart';
import '../../../models/authModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final user = Provider.of<AppProvider>(context, listen: false).userModel;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          InkWell(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: const Icon(Icons.menu)),
          const SizedBox(width: 10)
        ],

        automaticallyImplyLeading: false,
        // title: RichText(
        //   text: TextSpan(children: [
        //     TextSpan(
        //         text: "Note",
        //         style: GoogleFonts.robotoCondensed(
        //             fontSize: height * 0.045,
        //             color: Colors.black,
        //             fontWeight: FontWeight.w700)),
        //     TextSpan(
        //         text: "Me",
        //         style: GoogleFonts.robotoCondensed(
        //             fontSize: height * 0.045,
        //             fontWeight: FontWeight.bold,
        //             foreground: Paint()
        //               ..shader = LinearGradient(
        //                 colors: [HexColor("#fb7396"), HexColor("#fca272")],
        //               ).createShader(
        //                   Rect.fromLTWH(50.0, 100.0, 50.0, 0.0)))),
        //   ]),
        // ),
      ),
      body: FutureBuilder<List<NotesListModel>>(
        future: NoteRepository().getNoteList(user?.sId),
        builder: (BuildContext context, snapshot) {
          print("getNoteList :: ${snapshot.data}");
          print("usersId :: ${user?.sId}");
          print("token :: ${user?.token}");
          if (snapshot.hasData) {
            List<Color> gridColors = [
              Colors.cyan,
              Colors.redAccent,
              Colors.limeAccent,
              Colors.lightGreenAccent,
              Colors.purpleAccent,
            ];
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.01,
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04),
              child: GridView.custom(
                gridDelegate: SliverWovenGridDelegate.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  pattern: [
                    const WovenGridTile(1),
                    const WovenGridTile(
                      5 / 7,
                      crossAxisRatio: 0.9,
                      alignment: AlignmentDirectional.bottomEnd,
                    ),
                  ],
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < snapshot.data!.length) {
                      var data = snapshot.data![index];
                      Delta delta = Delta.fromJson(jsonDecode(data.content!));

                      var quillController = QuillController(
                        document: Document.fromDelta(delta),
                        selection: const TextSelection.collapsed(offset: 0),
                      );
                      return InkWell(
                        onTap: () {
                          print("object");
                          Navigator.of(context).pushNamed("/addNote",
                              arguments: {
                                "quillController": quillController,
                                "isNewNote": false,
                                "noteId": "${data.sId}"
                              });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: gridColors[index % gridColors.length]
                                .withOpacity(0.1),
                          ),
                          child: QuillEditor.basic(
                            configurations: QuillEditorConfigurations(
                              controller: quillController,
                              readOnly: true,
                              disableClipboard: true,
                              paintCursorAboveText: true,
                              showCursor: false,
                              scrollPhysics: const BouncingScrollPhysics(),
                            ),
                          ),

                          // QuillEditor.basic(
                          //   configurations: QuillEditorConfigurations(
                          //     controller: quillController,
                          //     readOnly: true,
                          //     disableClipboard: true,
                          //     paintCursorAboveText: true,
                          //     showCursor: false,
                          //     scrollPhysics: const BouncingScrollPhysics(),
                          //   ),
                          // ),
                        ),
                      );
                    } else {
                      return null;
                    }
                  },
                  childCount: snapshot.data?.length,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed("/addNote", arguments: {"isNewNote": true});
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: Drawer(
        child: Container(
          width: 200,
          decoration: const BoxDecoration(color: Colors.white),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Option 1'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('getUserId'),
                onTap: () async {
                  // SharedPreferences sharedUser =
                  //     await SharedPreferences.getInstance();
                  //
                  // var getUserDetails = sharedUser.getString('user');
                  // if (getUserDetails != null) {
                  //   UserModel userData =
                  //       UserModel.fromJson(jsonDecode(getUserDetails));
                  //
                  //   print('User ID: ${userData.sId}');
                  //   print('User Name: ${userData.name}');
                  // } else {
                  //   print('User data not found in SharedPreferences.');
                  // }

                  var userIdFromSf =
                      await AppProvider().updateNotificationCount("sId");

                  print("UserIdFromSf ::: $userIdFromSf");
                  print("user ::: ${user?.token}");
                },
              ),
              const Spacer(),
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  AuthenticationRepository().logOut().then((value) async {
                    print("value >>>> $value");
                    Navigator.of(context).pushReplacementNamed("/");
                    SharedPreferences sharedUser =
                        await SharedPreferences.getInstance();
                    sharedUser.remove('user');
                  });
                  Navigator.of(context).pushReplacementNamed("/");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
