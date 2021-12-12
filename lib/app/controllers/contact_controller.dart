import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_app_its/app/controllers/user_controller.dart';
import 'package:driving_app_its/app/data/models/contact_us_model/contact_us_model.dart';
import 'package:driving_app_its/app/ui/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  final _contactRef = FirebaseFirestore.instance.collection("ContactUs");

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  onInit() {
    super.onInit();
    nameController.text = Get.find<UserController>().user.fullName;
    phoneController.text = Get.find<UserController>().user.phoneNumber!;
  }

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Must provide the phone number';
    } else if (value.length != 11) {
      return 'Invalid Phone Number';
    }
    return null;
  }

  onContactUs() async {
    if (!formKey.currentState!.validate()) return;
    var contactDetail = ContactUsModel(
      phoneNumber: Get.find<UserController>().user.phoneNumber!,
      name: Get.find<UserController>().user.fullName,
      userId: Get.find<UserController>().user.id!,
    );
    await _contactRef.doc().set(contactDetail.toDocument());
    showAppSnackBar(
      "Contact Us",
      "Your detail has been submitted the support team will soon contact you",
    );
    descriptionController.clear();
  }
}
