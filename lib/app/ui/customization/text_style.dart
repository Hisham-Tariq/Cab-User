import 'colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static final TextStyle normal = GoogleFonts.catamaran(
    fontSize: 13,
  );

  static final TextStyle appName = GoogleFonts.catamaran(
    fontSize: 28,
    fontWeight: FontWeight.w900,
  );

  static final TextStyle appNamePrimary = AppTextStyle.appName.copyWith(
    color: AppColors.primary,
  );

  static final TextStyle description = GoogleFonts.catamaran(
    textStyle: const TextStyle(
      fontSize: 11,
      color: Colors.black45,
    ),
  );

  static final TextStyle emphasisDescription = AppTextStyle.description.copyWith(
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

  static final TextStyle textField = GoogleFonts.catamaran(
    fontSize: 13.0,
  );

  static final TextStyle disabledTextField = GoogleFonts.catamaran(
    fontSize: 13.0,
    color: Colors.grey,
  );

  static final TextStyle textFieldHint = GoogleFonts.catamaran(
    color: Colors.grey,
    fontSize: 13.0,
  );

  static final TextStyle heading1 = GoogleFonts.catamaran(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static final TextStyle small = GoogleFonts.catamaran(
    fontSize: 12,
  );

  static final TextStyle title = GoogleFonts.catamaran(
    fontSize: 14,
  );

  static final TextStyle subtitle = GoogleFonts.catamaran(
    fontSize: 12,
  );

  static final TextStyle primaryHeading = GoogleFonts.catamaran(
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    fontSize: 20,
  );

  static const TextStyle emphasisText = TextStyle(
    color: AppColors.emphasis,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle emphasisTitle = TextStyle(
    color: AppColors.emphasis,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );
}
