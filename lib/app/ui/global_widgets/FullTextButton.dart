import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import '../customization/customization.dart';

class FullTextButton extends StatelessWidget {
  final Callback onPressed;
  final String text;
  final Color? buttonColor;
  final Color? textColor;

  const FullTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: AppTextStyle.button.copyWith(
                color: this.textColor ?? AppTextStyle.button.color,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: this.buttonColor ?? AppColors.primary,
              shape: StadiumBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
