import 'package:driving_app_its/app/ui/global_widgets/spacers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';
import '../../utils/utils.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Material(
        child: GetBuilder<ContactController>(
          builder: (_) {
            return Form(
              key: controller.formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    const VerticalSpacer(space: 12),
                    Text('Name', style: AppTextStyle(fontSize: 14)),
                    const VerticalSpacer(space: 2),
                    TextFormField(
                      controller: controller.nameController,
                      enabled: false,
                      // validator: (value) => value!.isEmpty ? "Provide your name" : null,
                    ),
                    const VerticalSpacer(space: 8),
                    Text('Phone Number', style: AppTextStyle(fontSize: 14)),
                    const VerticalSpacer(space: 2),
                    TextFormField(
                      controller: controller.phoneController,
                      // validator: controller.validatePhoneNumber,
                      enabled: false,
                    ),
                    const VerticalSpacer(space: 8),
                    Text('Description', style: AppTextStyle(fontSize: 14)),
                    const VerticalSpacer(space: 2),
                    TextFormField(
                      controller: controller.descriptionController,
                      minLines: 8,
                      maxLines: 8,
                      validator: (value) => value!.isEmpty ? "Provide your reason" : null,
                    ),
                    const VerticalSpacer(space: 8),
                    TextButton(
                      onPressed: controller.onContactUs,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.mail),
                          HorizontalSpacer(space: 3),
                          Text("Contact Us"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
