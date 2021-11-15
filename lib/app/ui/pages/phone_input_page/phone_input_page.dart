import 'package:driving_app_its/app/ui/customization/customization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';

class PhoneInputPage extends GetView<PhoneInputController> {
  const PhoneInputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 120),
                  const AppName(),
                  const AppTagLine(),
                  const SizedBox(height: 100),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Number',
                          style: GoogleFonts.catamaran(
                            color: Colors.black45,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          focusNode: controller.phoneFocusNode,
                          controller: controller.phoneController,
                          decoration:
                              const InputDecoration(hintText: '03XXXXXXXXX'),
                          validator: controller.validatePhoneNumber,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Obx(
                                () => ProgressButton.icon(
                                  iconedButtons: const {
                                    ButtonState.idle: IconedButton(
                                      text: "Continue",
                                      icon: Icon(Icons.arrow_forward,
                                          color: Colors.white),
                                      color: AppColors.primary,
                                    ),
                                    ButtonState.loading: IconedButton(
                                      text: "Loading",
                                      color: AppColors.primary,
                                    ),
                                    ButtonState.fail: IconedButton(
                                      text: "Failed",
                                      icon: Icon(Icons.cancel,
                                          color: Colors.white),
                                      color: AppColors.error,
                                    ),
                                    ButtonState.success: IconedButton(
                                      text: "Success",
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      color: AppColors.primary,
                                    )
                                  },
                                  onPressed: controller.verifyPhoneNumber,
                                  state: controller.buttonState.value,
                                  progressIndicator:
                                      const CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.green),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
