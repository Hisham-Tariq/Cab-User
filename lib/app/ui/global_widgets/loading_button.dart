import 'package:driving_app_its/app/ui/customization/customization.dart';
import 'package:flutter/material.dart';

import 'color_loader.dart';

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
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: child ??
          ColorLoader(
            colors: const [Colors.white],
            duration: const Duration(seconds: 1),
          ),
    );
  }
}
