import 'package:driving_app_its/app/ui/customization/customization.dart';

import '../../../routes/app_routes.dart';

import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';

class IntroductionPage extends GetView<IntroductionController> {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 120),
                const AppName(),
                const AppTagLine(),
                const SizedBox(height: 100),
                // SignIn Button
                FullTextButton(
                  onPressed: () => Get.toNamed(AppRoutes.LOGIN),
                  text: 'Login',
                ),
                // SignUp Button
                const SizedBox(
                  height: 4,
                ),
                FullOutlinedTextButton(
                  onPressed: () => Get.toNamed(AppRoutes.SIGNUP),
                  text: 'Register',
                ),
                const SizedBox(height: 8),
                Text(
                  'By choosing one or the other, you are agreeing to the',
                  style: AppTextStyle.description,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                      },
                      child: Text(
                        'Terms of services',
                        style: AppTextStyle.emphasisDescription,
                      ),
                    ),
                    Text(
                      ' & ',
                      style: AppTextStyle.description,
                    ),
                    GestureDetector(
                      onTap: () {
                      },
                      child: Text(
                        'Privacy policy',
                        style: AppTextStyle.emphasisDescription,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
