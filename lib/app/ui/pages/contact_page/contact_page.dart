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
