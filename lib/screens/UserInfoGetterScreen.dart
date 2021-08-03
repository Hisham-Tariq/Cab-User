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
  late UserController _userController;
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final firstNameNode = FocusNode();

  final lastNameController = TextEditingController();
  final lastNameNode = FocusNode();

  final emailController = TextEditingController();
  final emailNode = FocusNode();

  ButtonState buttonState = ButtonState.idle();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!Get.isRegistered<UserController>())
      this._userController = Get.put(UserController());
    else
      this._userController = Get.find<UserController>();
  }

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
                        focusNode: firstNameNode,
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid Value' : null;
                        },
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
                        focusNode: lastNameNode,
                        validator: (value) {
                          return value!.isEmpty ? 'Invalid Value' : null;
                        },
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Email (Optional)',
                        style: GoogleFonts.catamaran(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        focusNode: emailNode,
                        controller: emailController,
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
                            AsyncButtonState.success: Icons.check_circle_outline_rounded,
                            AsyncButtonState.fail: Icons.cancel_outlined,
                          },
                          buttonState: buttonState,
                          onPressed: handleAddUserData,
                        ),
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

  changeButtonStateToError() {
    this.setState(() {
      buttonState = ButtonState.error();
      Future.delayed(Duration(seconds: 1)).then((value) {
        this.setState(() {
          buttonState = ButtonState.idle();
        });
      });
    });
  }

  unFocusFields() {
    firstNameNode.unfocus();
    lastNameNode.unfocus();
    emailNode.unfocus();
  }

  Future<void> handleAddUserData() async {
    // Remove Focus From Fields on Tap
    this.unFocusFields();
    // Validate The Form
    if (!_formKey.currentState!.validate()) return;
    // Set Button State = Loading
    this.setState(() {
      buttonState = ButtonState.loading();
    });
    // Add Users Data to User's DataModel
    final _user = UserModel(
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phoneNumber: this._userController.currentUserPhoneNumber,
    );
    this._userController.setUser(_user);
    // Add the User Personal Info in the Firestore
    if (await this._userController.createUser()) {
      // After Successfully Added the User's Data
      this.setState(() {
        buttonState = ButtonState.success();
        Future.delayed(Duration(seconds: 1)).then((value) {
          //  Navigate to Home Screen
          Get.off(() => HomeScreen());
        });
      });
    } else {
      // Error While adding the User's Data
      changeButtonStateToError();
    }
  }
}

//                      TODO:  Current Page Tasks      ✘  or ✔
//
// TODO:        Task Name                                              Status
// TODO:        Add Focus Nodes to TextFormFields                         ✔
