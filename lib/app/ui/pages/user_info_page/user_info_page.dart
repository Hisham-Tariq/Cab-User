import 'package:driving_app_its/app/ui/customization/customization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';

class UserInfoPage extends GetView<UserInfoController> {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const AppName(),
                const AppTagLine(),
                const SizedBox(height: 50),
                Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First Name',
                        style: GoogleFonts.catamaran(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: controller.firstNameController,
                        focusNode: controller.firstNameNode,
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid Value' : null;
                        },
                      ),
                      const SizedBox(height: 4),
                      // Password
                      Text(
                        'Last Name',
                        style: GoogleFonts.catamaran(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: controller.lastNameController,
                        focusNode: controller.lastNameNode,
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid Value' : null;
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Email (Optional)',
                        style: GoogleFonts.catamaran(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        focusNode: controller.emailNode,
                        controller: controller.emailController,
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
                                    icon:
                                        Icon(Icons.cancel, color: Colors.white),
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
                                onPressed: controller.handleAddUserData,
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
    );
  }
}
