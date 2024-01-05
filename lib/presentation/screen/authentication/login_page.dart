import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/utils.dart';
import '../../../models/arguments.dart';
import '../../widgets/animatedButton.dart';

class LoginPage extends StatefulWidget {
  final Function updateWidget;
  final UserArguments userDetails;
  LoginPage({super.key, required this.updateWidget, required this.userDetails});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double containerWidth = 0.3;
  String? mobile;
  String? password;
  bool isSuccess = false;
  final formKey = GlobalKey<FormState>();

  void animateContainer() {
    setState(() {
      containerWidth = 0.85;
    });
  }

  Future<bool> yourAsyncConditionFunction() async {
    await Future.delayed(Duration(seconds: 2));
    return isSuccess;
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
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            height: MediaQuery.of(context).size.height * 0.16,
            width: MediaQuery.of(context).size.width * containerWidth,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(80),
                    bottomRight: Radius.circular(80)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, spreadRadius: 10, blurRadius: 25)
                ]),
            child: Form(
                key: formKey,
                child: Stack(
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          mobileField(),
                          // Divider(
                          //   color: Colors.black54,
                          // ),
                          mobileField(),
                        ]),
                    CustomAnimatedButton(
                      initialIcon: Icons.play_arrow,
                      loadingIcon: Icons.hourglass_empty,
                      successIcon: Icons.check,
                      errorIcon: Icons.error,
                      initialColor: Colors.blue,
                      loadingColor: Colors.orange,
                      successColor: Colors.green,
                      errorColor: Colors.red,
                      onPressed: () {
                        print("isSuccess :: $isSuccess");
                        setState(() {
                          isSuccess = true;
                        });
                      },
                      successCondition: yourAsyncConditionFunction(),
                    ),
                    // FloatingActionButton(
                    //   onPressed: () {
                    //     if (formKey.currentState!.validate()) {
                    //       formKey.currentState!.save();
                    //       print("Mobile ::: $mobile");
                    //       FocusScope.of(context).requestFocus(FocusNode());
                    //     }
                    //   },
                    //   child: Icon(Icons.arrow_forward),
                    // ),
                  ],
                )),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: ElevatedButton(
            onPressed: () {
              widget.updateWidget(0, UserArguments(newUser: true));
            },
            child: Text("Animate"),
          ),
        ),
      ],
    );
  }

  Widget mobileField() {
    return TextFormField(
      decoration: const InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.phone_iphone,
            color: Colors.black38,
          ),
        ),
        hintText: 'Mobile number',
        counterText: '',
        border: InputBorder.none,
      ),
      style: TextStyle(
        color: Colors.black38,
        fontWeight: FontWeight.w500,
        fontSize: 18.0,
      ),
      cursorColor: Colors.black,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (dynamic value) {
        String pattern = r'(^[0-9]*$)';
        RegExp regExp = RegExp(pattern);
        if (value!.isEmpty) {
          Utils.flushBarErrorMessage("Mobile number is Required", context);
          return "";
        } else if (value.length != 10) {
          Utils.flushBarErrorMessage("Mobile number must 10 digits", context);
          return "";
        } else if (!regExp.hasMatch(value)) {
          Utils.flushBarErrorMessage(
              "Mobile number must be in numbers", context);
          return "";
        }
        return null;
      },
      onSaved: (String? value) {
        mobile = value!;
      },
    );
  }

  void showValidationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
