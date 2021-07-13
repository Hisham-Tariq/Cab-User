import 'package:driving_app_its/customization/customization.dart';
import 'package:flutter/material.dart';

class AppTagLine extends StatelessWidget {
  const AppTagLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Designed for living in a better world.',
      style: AppTextStyle.description,
    );
  }
}
