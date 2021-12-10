import '../../../routes/app_routes.dart';

import '../../global_widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/controllers.dart';
import '../../theme/text_theme.dart';
import '../../utils/utils.dart';

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
                const VerticalSpacer(space: 40),
                const AppName(),
                const AppTagLine(),
                const VerticalSpacer(space: 30),
                // SignIn Button
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.LOGIN),
                  child: const Text('Login'),
                  style: TextButton.styleFrom(
                    minimumSize: Size(Get.width, 50),
                  ),
                ),
                // SignUp Button
                const VerticalSpacer(),
                OutlinedButton(
                  onPressed: () => Get.toNamed(AppRoutes.SIGNUP),
                  child: const Text('Register'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(Get.width, 50),
                    primary: ThemeController.CurrentTheme(context).primary,
                  ),
                ),
                const VerticalSpacer(),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: context.textTheme.bodyText1!.copyWith(
                        fontSize: ResponsiveSize.height(5.5),
                      ),
                      children: [
                        const TextSpan(text: 'By choosing one or the other, you are agreeing to the'),
                        TextSpan(
                          text: ' Terms of services',
                          style: AppTextStyle(
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                        const TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy policy',
                          style: AppTextStyle(
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
