import 'package:flutter/cupertino.dart';
import '../../controllers/controllers.dart';
import 'package:get/get.dart';

class AppDependencies implements Bindings {
  final BuildContext context;
  AppDependencies(this.context);
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController(context));
  }
}
