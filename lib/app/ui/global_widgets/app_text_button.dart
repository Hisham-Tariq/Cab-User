import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import '../customization/customization.dart';

class AppTextButton extends StatelessWidget {
  final Callback onPressed;
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final Size minSize;

  const AppTextButton({
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
          color: textColor ?? AppTextStyle.button.color,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: buttonColor ?? AppColors.primary,
        minimumSize: minSize,
      ),
    );
  }
}
