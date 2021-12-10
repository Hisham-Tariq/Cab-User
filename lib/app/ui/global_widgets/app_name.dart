import 'package:driving_app_its/app/controllers/controllers.dart';
import 'package:driving_app_its/app/ui/utils/utils.dart';
import 'package:flutter/material.dart';

import '../theme/text_theme.dart';

class AppName extends StatelessWidget {
  const AppName({Key? key}) : super(key: key);
  final textSize = 36.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'C',
          style: AppTextStyle(
            fontSize: ResponsiveSize.height(textSize),
            fontWeight: FontWeight.bold,
            color: ThemeController.CurrentTheme(context).primary,
          ),
        ),
        Text(
          'AB',
          style: AppTextStyle(
            fontSize: ResponsiveSize.height(textSize),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
