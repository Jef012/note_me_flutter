import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note_me/presentation/widgets/customButton.dart';
import 'package:note_me/presentation/widgets/customDivider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../models/arguments.dart';

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
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

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
        child: Form(
            key: formKey,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.09),
                child: Text(widget.title,
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.black,
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: height * 0.15),
              customTextField(height, width, 'User name', Icons.email_outlined,
                  [FilteringTextInputFormatter.singleLineFormatter],
                  (dynamic value) {
                String pattern = r'^[a-zA-Z0-9_-]{3,16}$';
                RegExp regExp = RegExp(pattern);
                if (value!.isEmpty) {
                  return 'Username is required';
                } else if (!regExp.hasMatch(value)) {
                  return 'Enter a valid username (3-16 characters)';
                }
                return null;
              }, (String? value) {
                userName = value!;
              }, TextInputType.text),
              customTextField(
                  height,
                  width,
                  'abc@gmail.com',
                  Icons.email_outlined,
                  [FilteringTextInputFormatter.singleLineFormatter],
                  (dynamic value) {
                String pattern =
                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                RegExp regExp = RegExp(pattern);
                if (value!.isEmpty) {
                  return "Email is required";
                } else if (!regExp.hasMatch(value)) {
                  return "Enter a valid email address";
                }
                return null;
              }, (String? value) {
                emailId = value!;
              }, TextInputType.emailAddress),
              customTextField(height, width, 'Password', Icons.password, [
                FilteringTextInputFormatter.singleLineFormatter
              ], (dynamic value) {
                if (value!.isEmpty) {
                  return 'Password is required';
                } else if (value.length < 8 || value.length > 16) {
                  return 'Password must be between 8 and 16 characters';
                } else if (!value.contains(RegExp(r'[A-Z]'))) {
                  return 'Password must contain at least one uppercase letter';
                } else if (!value.contains(RegExp(r'[a-z]'))) {
                  return 'Password must contain at least one lowercase letter';
                } else if (!value.contains(RegExp(r'[0-9]'))) {
                  return 'Password must contain at least one digit';
                } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  return 'Password must contain at least one special character';
                }
                return null;
              }, (String? value) {
                password = value!;
              }, TextInputType.visiblePassword),
              RoundedLoadingButton(
                  controller: _btnController,
                  successIcon: Icons.check,
                  failedIcon: Icons.error_outline_outlined,
                  resetDuration: Duration(seconds: 2),
                  resetAfterDuration: true,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      print("UserName ::: $userName");
                      print("EmailId ::: $emailId");
                      print("Password ::: $password");
                      _btnController.success();
                      FocusScope.of(context).requestFocus(FocusNode());
                    } else {
                      _btnController.error();
                    }
                  },
                  height: height * 0.058,
                  width: width * 0.85,
                  color: HexColor("#ff6187"),
                  child: Text("Sign up",
                      style: GoogleFonts.robotoCondensed(
                          color: Colors.white,
                          fontSize: height * 0.015,
                          fontWeight: FontWeight.bold))),
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
            ])),
      ),
    );
  }

  Widget customTextField(double height, double width, hintText, icon,
      inputFormatters, validator, onSaved, keyboardType) {
    return Padding(
      padding: EdgeInsets.only(
        left: width * 0.07,
        right: width * 0.07,
        bottom: height * 0.03,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 10,
              // offset: Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          width: width * 0.85,
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              errorStyle: TextStyle(color: Colors.white),
              errorMaxLines: 1,

              enabledBorder: commonInputBorder,
              disabledBorder: commonInputBorder,
              focusedBorder: commonInputBorder,
              focusedErrorBorder: commonInputBorder,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(35)),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  left: width * 0.09,
                  right: width * 0.05,
                ),
                child: Icon(
                  icon,
                  color: Colors.black26,
                  size: height * 0.028,
                ),
              ),
              hintText: hintText, //,
              hintStyle: TextStyle(
                color: Colors.black26,
                fontSize: height * 0.022,
              ),
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            style: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.w500,
              fontSize: height * 0.022,
            ),
            cursorColor: Colors.black,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            onSaved: onSaved,
          ),
        ),
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
}
