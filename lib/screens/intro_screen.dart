import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../customization/customization.dart';
import '../routes/paths.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

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
                  onPressed: () => Get.toNamed(AppPaths.login),
                  text: 'Login',
                ),
                // SignUp Button
                const SizedBox(
                  height: 4,
                ),
                FullOutlinedTextButton(
                  onPressed: () => Get.toNamed(AppPaths.signup),
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
                        print('Show Terms of services');
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
                        print('Show Privacy policy');
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
