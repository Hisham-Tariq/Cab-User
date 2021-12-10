import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class ResponsiveSize {
  static double height(double num) {
    // "Phsycial Height: ".printInfo();
    // Get.window.physicalSize.height.printInfo();
    // "Simple Height: ".printInfo();
    // Get.height.printInfo();

    // "Phsycial Widht: ".printInfo();
    // Get.window.physicalSize.width.printInfo();
    // "Simple width: ".printInfo();
    // Get.width.printInfo();
    return (Get.window.physicalSize.height / 812) * num;
  }

  static double width(double num) {
    return (Get.window.physicalSize.width / 375) * num;
  }
}

showAppSnackBar(String title, String message,
    [BuildContext? context, IconData? icon]) {
  context ??= Get.context!;
  Get.snackbar(
    title,
    message,
    backgroundColor: context.theme.colorScheme.inverseSurface,
    colorText: context.theme.colorScheme.onInverseSurface,
    margin: const EdgeInsets.only(top: 20, left: 12, right: 12),
    instantInit: true,
    duration: const Duration(seconds: 2),
    mainButton: TextButton(
      onPressed: () {
        Get.isSnackbarOpen ? Get.back() : null;
      },
      child: const Icon(Icons.close, size: 16),
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 0),
        backgroundColor: context.theme.colorScheme.errorContainer,
        primary: context.theme.colorScheme.onErrorContainer,
      ),
    ),
    icon: icon != null
        ? Icon(icon, color: context.theme.colorScheme.tertiaryContainer)
        : null,
  );
}
