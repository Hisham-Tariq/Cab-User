import 'package:driving_app_its/app/ui/global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Text(
          "Contact Us",
        ),
      ),
    );
  }
}
