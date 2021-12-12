import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/help_us_controller.dart';

class HelpUsPage extends GetView<HelpUsController> {
  const HelpUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Text("Help Us"),
      ),
    );
  }
}
