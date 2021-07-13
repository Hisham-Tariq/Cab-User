import 'package:driving_app_its/customization/colors.dart';
import 'package:driving_app_its/widgets/color_loader.dart';
import 'package:driving_app_its/widgets/color_loader_2.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    Key? key,
    this.child,
    this.backgroundColor = AppColors.primary,
  }) : super(key: key);
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: this.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: this.child ??
          ColorLoader(
            colors: [Colors.white],
            duration: Duration(seconds: 1),
          ),
    );
  }
}
