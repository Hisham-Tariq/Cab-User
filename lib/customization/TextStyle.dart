import 'package:driving_app_its/customization/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static final TextStyle appName = GoogleFonts.catamaran(
    fontSize: 28,
    fontWeight: FontWeight.w900,
  );

  static final TextStyle appNamePrimary = AppTextStyle.appName.copyWith(
    color: AppColors.primary,
  );

  static final TextStyle description = GoogleFonts.catamaran(
    textStyle: TextStyle(
      fontSize: 11,
      color: Colors.black45,
    ),
  );

  static final TextStyle emphasisDescription =
      AppTextStyle.description.copyWith(
    color: AppColors.emphasis,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle button = GoogleFonts.catamaran(
    fontWeight: FontWeight.bold,
    color: AppColors.buttonText,
  );

  static final TextStyle outlinedButton = GoogleFonts.catamaran(
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}
