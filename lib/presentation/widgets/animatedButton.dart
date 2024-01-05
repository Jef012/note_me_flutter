import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AnimatedButton extends StatefulWidget {
  final Function(bool) onResult;

  AnimatedButton({Key? key, required this.onResult}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool isLoading = false;
  bool isSuccess = false;
  bool isFailed = false; // Set to true initially

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    if (isLoading) {
      buttonColor = HexColor("#fb7396");
    } else if (isSuccess) {
      buttonColor = Colors.green; // Set success color
    } else if (isFailed) {
      buttonColor = Colors.red; // Set error color
    } else {
      buttonColor = Colors.blue; // Set initial color
    }

    return ElevatedButton(
      onPressed: () {
        if (!isLoading) {
          setLoading(true);

          // Simulate asynchronous operation (replace with your actual logic)
          Future.delayed(Duration(seconds: 2), () {
            // Simulate success or fail condition
            bool conditionResult = true; // Replace with your actual condition
            if (conditionResult) {
              setSuccess(true);
            } else {
              setSuccess(false);
            }

            setLoading(false);

            widget.onResult(conditionResult);
          });
        }
      },
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        primary: buttonColor, // Set the background color based on the state
      ),
      child: buildButtonChild(),
    );
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;

      isSuccess = false;
      isFailed = false;
    });
  }

  void setSuccess(bool value) {
    setState(() {
      isSuccess = value;
      isFailed = !value; // Set isFailed opposite to isSuccess
    });
  }

  Widget buildButtonChild() {
    if (isLoading) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else if (isSuccess) {
      return Icon(Icons.check, color: Colors.white);
    } else if (isFailed) {
      return Icon(Icons.error_outline_rounded, color: Colors.white);
    } else {
      return Icon(Icons.arrow_forward,
          color: Colors.white); // Initial arrow icon
    }
  }
}
