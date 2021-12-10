import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';

class PhoneInputPage extends GetView<PhoneInputController> {
  const PhoneInputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  const VerticalSpacer(space: 40),
                  const AppName(),
                  const AppTagLine(),
                  const VerticalSpacer(space: 30),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phone Number',
                          style: AppTextStyle(fontSize: 14),
                        ),
                        const VerticalSpacer(),
                        TextFormField(
                          focusNode: controller.phoneFocusNode,
                          controller: controller.phoneController,
                          decoration: const InputDecoration(hintText: '03XXXXXXXXX'),
                          validator: controller.validatePhoneNumber,
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
                                  onPressed: controller.verifyPhoneNumber,
                                  state: controller.buttonState.value,
                                  progressIndicator: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation(context.theme.colorScheme.primary),
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
