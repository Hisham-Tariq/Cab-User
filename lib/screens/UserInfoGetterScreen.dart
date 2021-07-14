import 'package:async_button_builder/async_button_builder.dart';
import 'package:driving_app_its/controller/controller.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:driving_app_its/models/models.dart';
import 'package:driving_app_its/screens/screens.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoGetterScreen extends StatefulWidget {
  @override
  _UserInfoGetterScreenState createState() => _UserInfoGetterScreenState();
}

class _UserInfoGetterScreenState extends State<UserInfoGetterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  ButtonState buttonState = ButtonState.idle();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Easy',
                      style: GoogleFonts.catamaran(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Drive',
                      style: GoogleFonts.catamaran(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Designed for living in a better world.',
                  style: GoogleFonts.catamaran(
                    color: Colors.black45,
                    fontSize: 11,
                  ),
                ),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
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
                      SizedBox(height: 4),
                      TextFormField(
                        controller: firstNameController,
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid Value' : null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 4),
                      // Password
                      Text(
                        'Last Name',
                        style: GoogleFonts.catamaran(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: lastNameController,
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid Value' : null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Email',
                        style: GoogleFonts.catamaran(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid Value' : null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: AsyncAnimatedButton(
                          stateColors: {
                            AsyncButtonState.orElse: AppColors.primary,
                            AsyncButtonState.fail: Colors.red,
                          },
                          stateTexts: {
                            AsyncButtonState.idle: 'Continue',
                            AsyncButtonState.success: 'Success',
                            AsyncButtonState.fail: 'Fail',
                          },
                          stateIcons: {
                            AsyncButtonState.idle: Icons.arrow_right_alt,
                            AsyncButtonState.success:
                                Icons.check_circle_outline_rounded,
                            AsyncButtonState.fail: Icons.cancel_outlined,
                          },
                          buttonState: buttonState,
                          onPressed: handleAddUserData,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Continue',
                                style: GoogleFonts.catamaran(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: Size(100, 45),
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

  Future<void> handleAddUserData() async {
    if (!_formKey.currentState!.validate()) return;
    this.setState(() {
      buttonState = ButtonState.loading();
    });
    UserController userController = Get.put(UserController());
    final _user = UserModel(
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
    );
    userController.setUser(_user);
    if (await userController.createUser()) {
      this.setState(() {
        buttonState = ButtonState.success();
        Future.delayed(Duration(seconds: 1)).then((value) {
          //  Navigate to Home Screen
          Get.off(() => HomeScreen());
        });
      });
    } else {
      this.setState(() {
        buttonState = ButtonState.error();
        Future.delayed(Duration(seconds: 1)).then((value) {
          this.setState(() {
            buttonState = ButtonState.idle();
          });
        });
      });
    }
  }
}
