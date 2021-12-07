import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import '../customization/customization.dart';

class AppTextOutlinedButton extends StatelessWidget {
  final Callback onPressed;
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final Size minSize;

  const AppTextOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.buttonColor,
    this.textColor,
    this.minSize = const Size(150, 45),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: AppTextStyle.button.copyWith(
          color: buttonColor ?? AppColors.primary,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: minSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(
            color: buttonColor ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
