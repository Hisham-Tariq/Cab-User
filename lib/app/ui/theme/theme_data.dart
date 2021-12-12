import 'text_theme.dart';
import 'package:flutter/material.dart';
import 'colors/colors_interface.dart';

TextTheme textTheme(TextTheme textTheme) {
  return TextTheme(
    headline1: AppTextStyle(textStyle: textTheme.headline1),
    headline2: AppTextStyle(textStyle: textTheme.headline2),
    headline3: AppTextStyle(textStyle: textTheme.headline3),
    headline4: AppTextStyle(textStyle: textTheme.headline4),
    headline5: AppTextStyle(textStyle: textTheme.headline5),
    headline6: AppTextStyle(textStyle: textTheme.headline6),
    subtitle1: AppTextStyle(textStyle: textTheme.subtitle1),
    subtitle2: AppTextStyle(textStyle: textTheme.subtitle2),
    bodyText1: AppTextStyle(textStyle: textTheme.bodyText1),
    bodyText2: AppTextStyle(textStyle: textTheme.bodyText2),
    caption: AppTextStyle(textStyle: textTheme.caption),
    button: AppTextStyle(textStyle: textTheme.button),
    overline: AppTextStyle(textStyle: textTheme.overline),
  );
}

class CustomTheme {
  static ThemeData create(ThemeColors colors, Brightness brightness) {
    var buttonStyle = AppTextStyle(
      color: colors.onPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    TextTheme appTextTheme = textTheme(
      brightness == Brightness.light
          ? ThemeData.light().textTheme.copyWith(button: buttonStyle)
          : ThemeData.dark().textTheme.copyWith(button: buttonStyle),
    );

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      scaffoldBackgroundColor: colors.surface,
      backgroundColor: colors.surface,
      canvasColor: colors.surface,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colors.secondary,
        selectionHandleColor: colors.secondary,
        cursorColor: colors.secondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        iconTheme: IconThemeData(color: colors.onPrimary),
      ),
      textTheme: appTextTheme,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: colors.primary,
          primary: colors.onPrimary,
          shape: const StadiumBorder(),
          minimumSize: const Size(200, 50),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: colors.primary,
          shape: const StadiumBorder(),
          side: BorderSide(color: colors.secondary, width: 1),
          minimumSize: const Size(200, 50),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.inverseSurface,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all<Color>(colors.secondary),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.tertiaryContainer,
        foregroundColor: colors.onTertiaryContainer,
        hoverElevation: 4.0,
        elevation: 1.0,
        highlightElevation: 4.0,
        splashColor: colors.tertiaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        // extendedtextStyle: Themes.AppTextStyleFamily.copyWith(),
      ),
      inputDecorationTheme: InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.onSurface,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.secondary,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.error,
            ),
          ),
          errorStyle: AppTextStyle(
            color: colors.error,
          )),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceVariant,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.elliptical(100, 10),
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        labelType: NavigationRailLabelType.all,
        backgroundColor: colors.surface2,
        selectedIconTheme: IconThemeData(
          color: colors.onSecondaryContainer,
        ),
        unselectedIconTheme: IconThemeData(
          color: colors.onSurface,
        ),
        selectedLabelTextStyle: AppTextStyle(
          color: colors.onSurface,
        ),
        unselectedLabelTextStyle: AppTextStyle(
          color: colors.onSurfaceVariant,
        ),
      ),
      dividerColor: colors.surfaceVariant,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryContainer,
        onPrimaryContainer: colors.onPrimaryContainer,
        surface: colors.surface,
        onSurface: colors.onSurface,
        onSurfaceVariant: colors.onSurfaceVariant,
        surfaceVariant: colors.surfaceVariant,
        inverseSurface: colors.inverseSurface,
        onInverseSurface: colors.inverseOnSurface,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        secondaryContainer: colors.secondaryContainer,
        onSecondaryContainer: colors.onSecondaryContainer,
        tertiary: colors.tertiary,
        tertiaryContainer: colors.tertiaryContainer,
        onTertiary: colors.onTertiary,
        onTertiaryContainer: colors.onTertiaryContainer,
        outline: colors.outline,
        background: colors.background,
        onBackground: colors.onBackground,
        error: colors.error,
        onError: colors.onError,
        errorContainer: colors.errorContainer,
        onErrorContainer: colors.onErrorContainer,
      ),
    );
  }
}
