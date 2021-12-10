import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';

class UserInfoPage extends GetView<UserInfoController> {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  const VerticalSpacer(space: 20),
                  const AppName(),
                  const AppTagLine(),
                  const VerticalSpacer(space: 15),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('First Name', style: AppTextStyle(fontSize: 14)),
                        const VerticalSpacer(space: 2),
                        TextFormField(
                          controller: controller.firstNameController,
                          focusNode: controller.firstNameNode,
                          validator: (value) {
                            return value!.isEmpty ? 'First Name Required' : null;
                          },
                        ),
                        const VerticalSpacer(),
                        // Password
                        Text(
                          'Last Name',
                          style: AppTextStyle(fontSize: 14),
                        ),
                        const VerticalSpacer(space: 2),
                        TextFormField(
                          controller: controller.lastNameController,
                          focusNode: controller.lastNameNode,
                          validator: (value) {
                            return value!.isEmpty ? 'Last Name Required' : null;
                          },
                        ),
                        const VerticalSpacer(),
                        Text(
                          'Email (Optional)',
                          style: AppTextStyle(fontSize: 14),
                        ),
                        const VerticalSpacer(space: 2),
                        TextFormField(
                          focusNode: controller.emailNode,
                          controller: controller.emailController,
                        ),
                        const VerticalSpacer(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Obx(
                                () => ProgressButton.icon(
                                  textStyle: AppTextStyle(
                                    color: context.theme.colorScheme.onPrimary,
                                  ),
                                  iconedButtons: {
                                    ButtonState.idle: IconedButton(
                                      text: "Continue",
                                      icon: Icon(
                                        Icons.arrow_forward,
                                        color: context.theme.colorScheme.onPrimary,
                                      ),
                                      color: context.theme.colorScheme.primary,
                                    ),
                                    ButtonState.loading: IconedButton(
                                      text: "Loading",
                                      color: context.theme.colorScheme.primary,
                                    ),
                                    ButtonState.fail: IconedButton(
                                      text: "Failed",
                                      icon: Icon(
                                        Icons.cancel,
                                        color: context.theme.colorScheme.onError,
                                      ),
                                      color: context.theme.colorScheme.error,
                                    ),
                                    ButtonState.success: IconedButton(
                                      text: "Success",
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: context.theme.colorScheme.onPrimary,
                                      ),
                                      color: context.theme.colorScheme.primary,
                                    )
                                  },
                                  onPressed: controller.handleAddUserData,
                                  state: controller.buttonState.value,
                                  progressIndicator: const CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation(Colors.green),
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
