import 'package:flutter/material.dart';

enum ButtonState { initial, loading, success, error }

class CustomAnimatedButton extends StatefulWidget {
  final IconData initialIcon;
  final IconData loadingIcon;
  final IconData successIcon;
  final IconData errorIcon;
  final Color initialColor;
  final Color loadingColor;
  final Color successColor;
  final Color errorColor;
  final Future<bool> successCondition;
  final VoidCallback onPressed;

  const CustomAnimatedButton({
    Key? key,
    required this.initialIcon,
    required this.loadingIcon,
    required this.successIcon,
    required this.errorIcon,
    required this.initialColor,
    required this.loadingColor,
    required this.successColor,
    required this.errorColor,
    required this.successCondition,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomAnimatedButtonState createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _successController;
  late ButtonState _buttonState;

  @override
  void initState() {
    super.initState();
    _buttonState = ButtonState.initial;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _successController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    setState(() {
      _buttonState = ButtonState.loading;
      _animationController.repeat();
    });

    bool isSuccess = await widget.successCondition;
    _animationController.stop();

    setState(() {
      _buttonState = isSuccess ? ButtonState.success : ButtonState.error;
    });

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getButtonColor(),
        ),
        child: _buildIcon(),
      ),
    );
  }

  Color _getButtonColor() {
    switch (_buttonState) {
      case ButtonState.initial:
        return widget.initialColor;
      case ButtonState.loading:
        return widget.loadingColor;
      case ButtonState.success:
        return widget.successColor;
      case ButtonState.error:
        return widget.errorColor;
    }
  }

  Widget _buildIcon() {
    switch (_buttonState) {
      case ButtonState.initial:
        return Icon(Icons.play_arrow, color: Colors.white);
      case ButtonState.loading:
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        );
      case ButtonState.success:
        return Icon(Icons.check, color: Colors.white);
      case ButtonState.error:
        return Icon(Icons.error, color: Colors.white);
    }
  }
}
