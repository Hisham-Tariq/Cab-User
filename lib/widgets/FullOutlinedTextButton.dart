import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import '../customization/customization.dart';

class FullOutlinedTextButton extends StatelessWidget {
  final Callback onPressed;
  final String text;
  final Color? buttonColor;

  const FullOutlinedTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.buttonColor,
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
                color: this.buttonColor ?? AppColors.primary,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              primary: this.buttonColor ?? AppColors.primary,
              shape: StadiumBorder(
                side: BorderSide(
                  color: this.buttonColor ?? AppColors.primary,
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
