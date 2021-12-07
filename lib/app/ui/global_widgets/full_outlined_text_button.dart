import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import '../customization/customization.dart';

class FullOutlinedTextButton extends StatelessWidget {
  final Callback onPressed;
  final String text;
  final Color? buttonColor;
  final Color? backgroundColor;

  const FullOutlinedTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.buttonColor,
    this.backgroundColor,
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
              style: AppTextStyle.outlinedButton.copyWith(
                color: buttonColor ?? AppColors.primary,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor ?? Colors.white,
              primary: buttonColor ?? AppColors.primary,
              shape: StadiumBorder(
                side: BorderSide(
                  color: buttonColor ?? AppColors.primary,
                  width: 1,
                ),
              ),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(5.0),
              //   side: BorderSide(
              //     color: this.buttonColor ?? AppColors.primary,
              //     width: 1,
              //   ),
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
