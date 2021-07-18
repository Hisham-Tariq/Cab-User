import 'package:driving_app_its/screens/PhoneInputScreen.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../customization/customization.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 120),
                AppName(),
                AppTagLine(),
                SizedBox(height: 100),
                // SignIn Button
                FullTextButton(
                  onPressed: () =>
                      Get.to(() => PhoneInputScreen(isNewUser: false)),
                  text: 'Login',
                ),
                // SignUp Button
                SizedBox(
                  height: 4,
                ),
                FullOutlinedTextButton(
                  onPressed: () => Get.to(() => PhoneInputScreen()),
                  text: 'Register',
                ),
                SizedBox(height: 8),
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

//                      TODO:  Current Page Tasks      ✘  or ✔
//
// TODO:        Task Name                                              Status
// TODO:        Add Terms & Services                                     ✘
// TODO:        Add Privacy Policy                                       ✘
