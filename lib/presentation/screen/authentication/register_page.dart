import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note_me/controller/repository/authenticationRepo.dart';
import 'package:note_me/presentation/router/app_router.dart';
import 'package:note_me/presentation/widgets/customButton.dart';
import 'package:note_me/presentation/widgets/customDivider.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/utils.dart';
import '../../../controller/provider/appProvider.dart';
import '../../../models/arguments.dart';
import '../../../models/authModel.dart';

class RegisterPage extends StatefulWidget {
  final Function updateWidget;
  final UserArguments userDetails;
  final String title;
  RegisterPage(
      {super.key,
      required this.updateWidget,
      required this.userDetails,
      required this.title});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double containerWidth = 0.3;
  String? userName;
  String? emailId;
  String? password;
  final formKey = GlobalKey<FormState>();
  // final RoundedLoadingButtonController _btnController =
  //     RoundedLoadingButtonController();

  void animateContainer() {
    setState(() {
      containerWidth = 0.85;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animateContainer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.09),
            child: Text(widget.title,
                style: GoogleFonts.robotoCondensed(
                    color: Colors.black87.withOpacity(0.7),
                    fontSize: height * 0.05,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: height * 0.15),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: height * 0.4,
            width: width * containerWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(height * 0.03)),
            ),
            child: Form(
                key: formKey,
                child: Stack(
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.01),
                          inputField(
                              title: 'Mobile number',
                              icon: Icons.phone_iphone,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          inputField(
                              title: 'Email ID',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              maxLength: 30,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter
                              ]),
                          inputField(
                              title: 'Password',
                              icon: Icons.lock,
                              keyboardType: TextInputType.text,
                              maxLength: 20,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter
                              ]),
                          SizedBox(height: height * 0.045),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  // print("Mobile ::: $mobile");
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  signUp();
                                }
                              },
                              child: Container(
                                  padding: EdgeInsets.only(
                                      top: height * 0.013,
                                      bottom: height * 0.013,
                                      right: width * 0.05,
                                      left: width * 0.05),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        HexColor("#c94f0e").withOpacity(0.7),
                                        HexColor("#b52d4b").withOpacity(0.7)
                                      ]),
                                      // color: HexColor("#c94f0e"),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(40))
                                      // borderRadius: BorderRadius.only(
                                      //     topRight: Radius.circular(40),
                                      //     bottomRight: Radius.circular(40))
                                      ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Signup",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: height * 0.0215)),
                                      SizedBox(width: width * 0.02),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: height * 0.018,
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                          SizedBox(height: height * 0.015),
                        ]),
                  ],
                )),
          ),
          SizedBox(height: height * 0.08),
          Row(
            children: [
              Expanded(
                  child: CustomDivider(
                      thickness: 2,
                      indentWidth: height * 0.04,
                      endIndentWidth: height * 0.01)),
              Text(
                "or connect with",
                style: GoogleFonts.robotoCondensed(
                  color: Colors.black54,
                  fontSize: height * 0.017,
                ),
              ),
              Expanded(
                  child: CustomDivider(
                      thickness: 2,
                      indentWidth: height * 0.01,
                      endIndentWidth: height * 0.04))
            ],
          ),
          SizedBox(height: height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                  title: "Google",
                  icon: "assets/image/icons8-google-48.png",
                  color: HexColor("#ffe3ea"),
                  width: width * 0.35,
                  height: height * 0.05,
                  onTap: () {}),
              CustomButton(
                  title: "Facebook",
                  icon: "assets/image/icons-facebook.png",
                  color: HexColor("#ffe3ea"),
                  width: width * 0.35,
                  height: height * 0.05,
                  onTap: () {
                    widget.updateWidget(0, UserArguments(newUser: true));
                  }),
            ],
          ),
          SizedBox(height: height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Have an account?  ",
                style: GoogleFonts.robotoCondensed(
                  color: Colors.white,
                  fontSize: height * 0.017,
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.updateWidget(1, UserArguments(newUser: true));
                },
                child: Text(
                  "Login",
                  style: GoogleFonts.robotoCondensed(
                    color: HexColor("#f93467"),
                    fontSize: height * 0.019,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget inputField(
      {String? title,
      IconData? icon,
      TextInputType? keyboardType,
      int? maxLength,
      inputFormatters}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.05,
                left: MediaQuery.of(context).size.width * 0.05),
            child: Icon(
              icon,
              color: Colors.black38,
            ),
          ),
          hintText: title,
          hintStyle: TextStyle(color: Colors.black38),
          counterText: '',
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontSize: MediaQuery.of(context).size.height * 0.0225,
        ),
        cursorColor: Colors.black,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        validator: (dynamic value) {
          if (value!.isEmpty) {
            Utils.flushBarErrorMessage("Field is required", context);
          } else if (value.length != maxLength && title == "Mobile number") {
            Utils.flushBarErrorMessage(
                "Field must be $maxLength characters", context);
          } else if (title == 'Mobile number') {
            String pattern = r'(^[0-9]*$)';
            RegExp regExp = RegExp(pattern);
            if (!regExp.hasMatch(value)) {
              Utils.flushBarErrorMessage("Field must be in numbers", context);
            }
          } else if (title == 'Password') {
            if (value.length < 6) {
              Utils.flushBarErrorMessage(
                  "Password must be at least 6 characters", context);
            } else if (!value.contains(RegExp(r'[A-Z]'))) {
              Utils.flushBarErrorMessage(
                  "Password must contain at least one uppercase letter",
                  context);
            } else if (!value.contains(RegExp(r'[a-z]'))) {
              Utils.flushBarErrorMessage(
                  "Password must contain at least one lowercase letter",
                  context);
            } else if (!value.contains(RegExp(r'[0-9]'))) {
              Utils.flushBarErrorMessage(
                  "Password must contain at least one digit", context);
            }
          }
          return null;
        },
        onSaved: (String? value) {
          if (title == "Mobile number") {
            userName = value!;
          } else if (title == "Password") {
            password = value!;
          }
        },
      ),
    );
  }

  OutlineInputBorder commonInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(35)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ));

  void showValidationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  signUp() {
    AuthenticationRepository().signUp({
      "name": "$userName",
      "email": "$emailId",
      "password": "$password"
    }).then((value) {
      // value != "" ? _btnController.success() : _btnController.error();
      saveData(value);
      Navigator.pushReplacementNamed(context, "/home");
      print(" value[values] :: $value");
    });
  }

  saveData(UserModel authtoken) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setString('user', jsonEncode(authtoken));
    sharedUser.setString('authToken', 'Bearer ${authtoken.token}');
    Provider.of<AppProvider>(context, listen: false).updateUser(authtoken);
  }
}
