import 'package:flutter/cupertino.dart';
import 'theme_controller.dart';
import 'package:get/get.dart';

class ThemeBinding implements Bindings {
  final BuildContext context;
  ThemeBinding(this.context);
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController(context));
    
  }
}
