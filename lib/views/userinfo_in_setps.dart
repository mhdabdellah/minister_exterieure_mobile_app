import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minister_exterieure_mobile_app/constant.dart';
import 'package:minister_exterieure_mobile_app/controllers/registerController.dart';
import 'package:minister_exterieure_mobile_app/views/customWidgets/dialog/errorSnackBar.dart';
import 'package:minister_exterieure_mobile_app/views/customWidgets/dialog/loading.dart';

class UserInfoSteper extends StatefulWidget {
  const UserInfoSteper({super.key});

  @override
  _UserInfoSteperState createState() => _UserInfoSteperState();
}

class _UserInfoSteperState extends State<UserInfoSteper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('تسهيل'),
            Image.asset('assets/logo.png', height: 40),
          ],
        ),
      ),
      body: GetBuilder<RegisterFormController>(
          init: RegisterFormController(),
          builder: (registerFormController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // To make the title stretch across the screen
              children: [
                const Padding(
                  // Title before the form
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'القنصلية العامة لموريتانيا بالدار البيضاء',
                    style: TextStyle(
                        fontSize: 15.0, // Choose the size that fits your needs
                        fontWeight: FontWeight.bold), // Styling the text
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  // Title before the form
                  padding:
                      EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
                  child: Text(
                    'البيانات الشخصية',
                    style: TextStyle(
                        fontSize: 30.0, // Choose the size that fits your needs
                        fontWeight: FontWeight.bold), // Styling the text
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(
                      canvasColor: Colors.yellow,
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: Colors.green,
                            background: Colors.red,
                            secondary: Colors.green,
                          ),
                    ),
                    child: Stepper(
                      steps: registerFormController.getSteps(),
                      // currentStep: currentStep,
                      currentStep: registerFormController.currentStep,
                      onStepContinue: () async {
                        // Check if the current step's form is valid
                        bool isFormValid = false;

                        switch (registerFormController.currentStep) {
                          case 0:
                            isFormValid = registerFormController
                                    .formKey.currentState
                                    ?.validate() ??
                                false;
                            break;
                          case 1:
                            isFormValid = registerFormController
                                    .userInfoFormKey.currentState
                                    ?.validate() ??
                                false;
                            break;
                          case 2:
                            isFormValid = registerFormController
                                    .contactInfoFormKey.currentState
                                    ?.validate() ??
                                false;
                            break;
                          case 3:
                            isFormValid = registerFormController
                                    .otherInfoFormKey.currentState
                                    ?.validate() ??
                                false;
                            break;
                          case 4:
                            isFormValid = registerFormController
                                    .otherInfoFormKey.currentState
                                    ?.validate() ??
                                false;
                            break;
                          // Add more cases as needed for additional steps
                        }

                        if (isFormValid) {
                          final isLastStep =
                              registerFormController.currentStep ==
                                  registerFormController.getSteps().length - 1;
                          if (isLastStep) {
                            // Last step
                            // Here you can handle form submission for all steps
                            print(
                                "All steps completed, sending data to server");

                            // You can now collect all the data from the form fields
                            final userInfo = registerFormController
                                .userInfoFormKey.currentState?.value;
                            final contactInfo = registerFormController
                                .contactInfoFormKey.currentState?.value;
                            final otherInfo = registerFormController
                                .otherInfoFormKey.currentState?.value;

                            // Now you can send this data to Firestore or perform other actions
                            // Make sure to handle the upload of the image before sending all data
                            showLoadingIndicator();
                            String passportImagePublicUrl =
                                await registerFormController.uploadFile(
                                    fileName:
                                        "${registerFormController.passportNumberController.text}_${registerFormController.fullNameController.text}");
                            dismissLoadingIndicator();

                            if (passportImagePublicUrl.isNotEmpty) {
                              // Combine all form data with the image URL

                              var formData = {
                                'passport_image_url': passportImagePublicUrl,
                                'passport_number': registerFormController
                                    .passportNumberController.text,
                                'passport_date_emission': registerFormController
                                    .emission_dateController.text,
                                'passport_date_expiration':
                                    registerFormController
                                        .expiration_dateController.text,
                                'national_id': registerFormController
                                    .nationalIdController.text,
                                'full_name': registerFormController
                                    .fullNameController.text,
                                'birth_date': registerFormController
                                    .birthDateController.text,
                                'phone_number': registerFormController
                                    .phoneNumberController.text,
                                'email':
                                    registerFormController.emailController.text,
                                'city':
                                    registerFormController.cityController.text,
                                'neighborhood': registerFormController
                                    .neighborhoodController.text,
                                'address': registerFormController
                                    .addressController.text,
                                'Permi_de_sejour': registerFormController
                                    .permi_sejourController.text,
                                "objectif_de_sejour":
                                    registerFormController.selectedObject,
                                "Permi_de_sejour_debut": registerFormController
                                    .from_dateController.text,
                                "Permi_de_sejour_expiration":
                                    registerFormController
                                        .to_dateController.text,
                              };
                              // print('formData_1 : $formData');

                              if (await checkConnectivity()) {
                                registerFormController.sendInfo(formData);
                              } else {
                                dismissLoadingIndicator();
                                errorSnackBar(
                                    message:
                                        'لا يوجد اتصال ببيانات الهاتف المحمول أو شبكة الواي فاي.');
                              }
                              // Send combined data to server or Firestore
                              registerFormController.sendInfo(formData);
                            } else {
                              // Handle the case where the image was not uploaded
                              registerFormController
                                  .showPassportImageRequestDialog(context);
                            }
                          } else {
                            // Valid form for the current step, go to the next step
                            setState(
                                () => registerFormController.currentStep += 1);
                          }
                        } else {
                          // Current step's form is invalid
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('الرجاء تصحيح الأخطاء في النموذج'),
                            ),
                          );
                        }
                      },
                      onStepCancel: () => registerFormController.currentStep ==
                              0
                          ? null
                          : setState(
                              () => registerFormController.currentStep -= 1),
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: details.onStepContinue,
                              child:
                                const Text('التالي'), // "Continue" in Arabic
                            ),
                            ElevatedButton(
                              onPressed: details.onStepCancel,
                              child: const Text('إلغاء'), // "Cancel" in Arabic
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                // Container with full width
                // Padding(
                //   padding: const EdgeInsets.only(bottom: -8.0),
                //   child: Container(
                //     width: double
                //         .infinity, // This makes the Container fill all the horizontal space
                //     color: const Color.fromARGB(255, 234, 191, 51),
                //     padding: const EdgeInsets.all(10),
                //     child: Column(
                //       // Changed to Row for proper alignment of children
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset(
                //           'assets/rim_drp.jpg', // Replace with your asset image
                //           width: 24, // Set your preferred width
                //           height: 24, // Set your preferred height
                //         ),
                //         const SizedBox(width: 8), // Spacing between icon and text
                //         const Text(
                //           'يمكنك طلب الملفات بمجرد تفعيل الحساب',
                //           style: TextStyle(
                //             color: Color(0xFF00A95C), // Use your preferred text color
                //             fontSize: 14, // Set your preferred text size
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Your bottom container
                Container(
                  width: double
                      .infinity, // This makes the Container fill all the horizontal space
                  color: const Color.fromARGB(255, 234, 191, 51),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    // Use Row for horizontal layout
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/rim_drp.jpg', // Replace with your asset image
                        width: 24, // Set your preferred width
                        height: 24, // Set your preferred height
                      ),
                      const SizedBox(width: 8), // Spacing between icon and text
                      const Text(
                        'يمكنك طلب الملفات بمجرد تفعيل الحساب',
                        style: TextStyle(
                          color: Color(
                              0xFF00A95C), // Use your preferred text color
                          fontSize: 14, // Set your preferred text size
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
