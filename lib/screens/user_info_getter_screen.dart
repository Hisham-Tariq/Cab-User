import '../controller/controller.dart';
import '../customization/customization.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import '../routes/paths.dart';

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

  ButtonState buttonState = ButtonState.idle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userController = Get.find<UserController>();
  }

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
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: firstNameController,
                        focusNode: firstNameNode,
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
                        controller: lastNameController,
                        focusNode: lastNameNode,
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
                        focusNode: emailNode,
                        controller: emailController,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ProgressButton.icon(
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
                                  icon: Icon(Icons.cancel, color: Colors.white),
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
                              onPressed: handleAddUserData,
                              state: buttonState,
                              progressIndicator:
                                  const CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.green),
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

  changeButtonStateToError() {
    setState(() {
      buttonState = ButtonState.fail;
      Future.delayed(const Duration(seconds: 1)).then((value) {
        setState(() {
          buttonState = ButtonState.idle;
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
    unFocusFields();
    // Validate The Form
    if (!_formKey.currentState!.validate()) return;
    // Set Button State = Loading
    setState(() {
      buttonState = ButtonState.loading;
    });
    // Add Users Data to User's DataModel
    final _user = UserModel(
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phoneNumber: _userController.currentUserPhoneNumber,
    );
    _userController.user = _user;
    // Add the User Personal Info in the Firestore
    if (await _userController.createUser()) {
      // After Successfully Added the User's Data
      setState(() {
        buttonState = ButtonState.success;
        Future.delayed(const Duration(seconds: 1)).then((value) {
          //  Navigate to Home Screen
          Get.offAllNamed(AppPaths.tripBooking);
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
