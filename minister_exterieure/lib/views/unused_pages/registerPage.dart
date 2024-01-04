import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:minister_exterieure/constant.dart';
import 'package:minister_exterieure/views/customWidgets/dialog/errorSnackBar.dart';
import 'package:minister_exterieure/views/customWidgets/dialog/loading.dart';
import 'package:minister_exterieure/views/customWidgets/dialog/successSnackBar.dart';
import 'package:minister_exterieure/views/filesPage.dart';
import 'package:path/path.dart' as Path;

class RegisterClientForm extends StatefulWidget {
  const RegisterClientForm({super.key});

  @override
  _RegisterClientFormState createState() => _RegisterClientFormState();
}

class _RegisterClientFormState extends State<RegisterClientForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController passportNumberController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String initialCountry = 'MR'; // 'MR' is the ISO code for Mauritania
  PhoneNumber number = PhoneNumber(isoCode: 'MR');
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String selectedCity = 'Other'; // Default value if needed
  File? _selectedImage;
  UploadTask? task; // Firebase storage upload task

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String> uploadFile() async {
    if (_selectedImage == null) return "";

    final fileName = Path.basename(_selectedImage!.path);
    final destination = 'passport_images/$fileName';

    task = FirebaseStorage.instance.ref(destination).putFile(_selectedImage!);

    // Show progress indicator

    try {
      // Wait for the upload to complete
      final snapshot = await task!.whenComplete(() {});
      // Get the download URL
      final urlDownload = await snapshot.ref.getDownloadURL();

      return urlDownload;

      // Save the download URL to Firestore
      // await saveImageUrlToFirestore(urlDownload);
    } catch (e) {
      // Handle errors
      print(e);
      return ""; // You might want to use something like Flutter's `SnackBar` to show the error to the user
    }
    // return null;
  }

  sendInfo(Map<String, dynamic> formData) async {
    // Define the list of allowed cities
    const allowedCities = {'Nouakchott', 'Nema', 'Aioune', 'Tidjekja'};

    // Check if the selected city is in the allowed list
    if (allowedCities.contains(formData['city'])) {
      final firestore = FirebaseFirestore.instance;

      try {
        if (await checkConnectivity()) {
          await firestore.collection('clients').add({
            'national_id': formData['national_id'],
            'passport_number': formData['passport_number'],
            'full_name': formData['full_name'],
            'birth_date': formData['birth_date'],
            'phone_number': formData['phone_number'],
            'email': formData['email'],
            'city': formData['city'],
            'neighborhood': formData['neighborhood'],
            'address': formData['address'],
            'passport_image_url': formData['passport_image_url']
          });

          // Data sent successfully
          successSnackBar(
              message: "تم استلام معلوماتكم الشخصية وتسجيلها بنجاح.");
          Get.off(() => const FilesPage());
        } else {
          dismissLoadingIndicator();
          errorSnackBar(
              message:
                  'لا يوجد اتصال ببيانات الهاتف المحمول/n أو شبكة الواي فاي.');
        }
      } catch (e) {
        print('Error sending data to Firestore: $e');
        // Handle the error and possibly inform the user
      }
    } else {
      // City not allowed, print the message
      print("You are not able");
      showNotAllowedCityDialog(context);
      // You can also inform the user with a dialog or a snackbar
    }
  }

  void showPassportImageRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'تحميل صورة جواز السفر',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'لإكمال عملية التسجيل، نحتاج إلى صورة جواز السفر الخاص بك.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'الرجاء التأكد من أن الصورة واضحة وأن جميع المعلومات مقروءة.',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('حمّل الآن'),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الرسالة التحذيرية
                // إضافة الوظائف هنا لفتح الكاميرا أو مستكشف الملفات لتحميل الصورة
              },
            ),
            TextButton(
              child: const Text('تخطّي'),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الرسالة التحذيرية
                // هنا يمكن التعامل مع الحالة التي يختار فيها المستخدم تخطي الخطوة
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 24.0,
          backgroundColor: Colors.white,
        );
      },
    );
  }

  void showNotAllowedCityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'المدينة غير مدعومة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'نعتذر عن هذا الإزعاج.',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'المدينة المختارة غير مدعومة في خدمتنا حالياً. الرجاء اختيار مدينة أخرى من القائمة.',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('اختر مجدداً'),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الرسالة التحذيرية
                // يمكن وضع إجراءات إضافية هنا للعودة إلى النموذج إذا لزم الأمر
              },
            ),
            TextButton(
              child: const Text('اتصل بالدعم'),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الرسالة التحذيرية
                // الانتقال إلى صفحة الدعم أو فتح تطبيق البريد الإلكتروني إلخ.
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 24.0,
          backgroundColor: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('قنصليتي'),
            Image.asset('assets/logo.png', height: 40),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment
            .stretch, // To make the title stretch across the screen
        children: [
          const Padding(
            // Title before the form
            padding: EdgeInsets.all(20.0),
            child: Text(
              'البيانات الشخصية',
              style: TextStyle(
                  fontSize: 30.0, // Choose the size that fits your needs
                  fontWeight: FontWeight.bold), // Styling the text
              textAlign: TextAlign.center,
            ),
          ),
          // Place the Passport Capture Image here
          GestureDetector(
            onTap: pickImageFromCamera, // Open the image picker when tapped
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10.0),
              child: _selectedImage == null
                  ? const Icon(
                      Icons.camera,
                      size: 100,
                    )
                  : Image.file(
                      _selectedImage!,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover, // You can adjust the fit as needed
                    ),
            ),
          ),
          Expanded(
            // Wrap the FormBuilder in an Expanded widget to take up remaining space
            child: SingleChildScrollView(
              // Allows the form to be scrollable
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      //... (all other form fields here)
                      FormBuilderTextField(
                        name: 'national_id',
                        decoration: const InputDecoration(
                          labelText: 'الرقم الوطني',
                        ),
                        controller: nationalIdController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الرقم الوطني';
                          }
                          // Check if the input is exactly 10 digits
                          if (value.length != 10 ||
                              int.tryParse(value) == null) {
                            return 'يجب أن يحتوي الرقم b على 10 أرقام فقط';
                          }
                          return null; // Validation passed
                        },
                      ),
                      FormBuilderTextField(
                        name: 'passport_number',
                        decoration: const InputDecoration(
                          labelText: 'رقم الجواز',
                        ),
                        controller: passportNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال رقم الجواز';
                          }

                          // Define a regular expression pattern for one alphabet character followed by 8 numbers
                          final RegExp pattern = RegExp(r'^[A-Z]\d{8}$');

                          if (!pattern.hasMatch(value)) {
                            return 'يجب أن يتبع رقم الجواز النمط الصحيح (مثال: A34567886)';
                          }
                          return null; // Validation passed
                        },
                      ),
                      FormBuilderTextField(
                        name: 'full_name',
                        decoration: const InputDecoration(
                          labelText: 'الاسم الكامل',
                        ),
                        controller: fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الاسم الكامل';
                          }

                          // Define a regular expression pattern for a name with at least 4 alphabetic characters
                          // which may include spaces and hyphens. There is no upper limit.
                          final RegExp pattern =
                              RegExp(r"^[A-Za-z\u0600-\u06FF \-']{4,}$");

                          if (!pattern.hasMatch(value)) {
                            return 'الرجاء إدخال اسم صحيح (يجب أن يكون الاسم مكون من 4 حروف أو أكثر)';
                          }
                          return null; // Validation passed
                        },
                      ),

                      FormBuilderDateTimePicker(
                        name: 'birth_date',
                        inputType: InputType.date,
                        format: DateFormat("yyyy-MM-dd"),
                        decoration: const InputDecoration(
                          labelText: 'تاريخ الميلاد',
                        ),
                        controller: birthDateController,
                      ),
                      // FormBuilderTextField(
                      //   name: 'phone_number',
                      //   decoration: const InputDecoration(
                      //     labelText: 'رقم الهاتف',
                      //   ),
                      //   controller: phoneNumberController,
                      // ),
                      // InternationalPhoneNumberInput(
                      //   name: 'phone_number',
                      //   onInputChanged: (PhoneNumber number) {
                      //     // You can access the selected phone number here
                      //     print('Country code: ${number.countryCode}');
                      //     print('Phone number: ${number.phoneNumber}');
                      //   },
                      //   inputDecoration: const InputDecoration(
                      //     labelText: 'رقم الهاتف',
                      //   ),
                      // ),

                      // InternationalPhoneNumberInput(
                      //   onInputChanged: (PhoneNumber number) {
                      //     print(number.phoneNumber);
                      //   },
                      //   onInputValidated: (bool value) {
                      //     if (value) {
                      //       // The phone number is considered valid.
                      //       // You can further validate it based on your requirements here.
                      //       // For example, you can check the length or format of the phone number.

                      //       final phoneNumber = phoneNumberController.text;

                      //       if (phoneNumber.length < 8) {
                      //         // The phone number is too short; it should contain at least 8 digits.
                      //         print('Invalid phone number: Too short');
                      //         // You can show an error message or handle it as needed.
                      //       } else {
                      //         // The phone number is valid; you can proceed with it.
                      //         print('Valid phone number');
                      //       }
                      //     } else {
                      //       // The phone number is not valid.
                      //       // You can handle it as needed.
                      //       print('Invalid phone number');
                      //     }
                      //   },
                      //   selectorConfig: const SelectorConfig(
                      //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      //   ),
                      //   ignoreBlank: false,
                      //   // autoValidateMode: AutovalidateMode.disabled,
                      //   selectorTextStyle: const TextStyle(color: Colors.black),
                      //   initialValue: number,
                      //   textFieldController: phoneNumberController,
                      //   formatInput: true,
                      //   keyboardType: const TextInputType.numberWithOptions(
                      //     signed: true,
                      //     decimal: true,
                      //   ),
                      //   inputDecoration: const InputDecoration(
                      //     labelText:
                      //         'رقم الهاتف', // Display 'Phone Number' in Arabic
                      //     contentPadding: EdgeInsets.symmetric(
                      //         vertical: 16.0), // Adjust height
                      //   ),
                      //   onSaved: (PhoneNumber number) {
                      //     print('On Saved: $number');
                      //   },
                      //   locale: 'ar', // Set locale to Arabic
                      // ),

                      FormBuilderTextField(
                        name: 'phone_number',
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                        ),
                        controller: phoneNumberController,
                        validator: (value) {
                          final phoneNumber = phoneNumberController.text;
                          if (phoneNumber.isEmpty) {
                            return 'يرجى إدخال رقم الهاتف';
                          }

                          // Define a regular expression pattern for phone number validation (8 or more digits)
                          final RegExp pattern = RegExp(r'^\d{8,}$');

                          if (!pattern.hasMatch(phoneNumber)) {
                            return 'الرقم غير صحيح. يجب أن يحتوي على 8 أرقام على الأقل.';
                          }
                          return null; // Validation passed
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(
                          labelText: 'البريد الإلكتروني',
                        ),
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني';
                          }

                          // Define a regular expression pattern for email validation
                          final RegExp emailRegExp = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

                          if (!emailRegExp.hasMatch(value)) {
                            return 'البريد الإلكتروني غير صحيح';
                          }

                          return null; // Validation passed
                        },
                      ),

                      // FormBuilderTextField(
                      //   name: 'city',
                      //   decoration: const InputDecoration(
                      //     labelText: 'المدينة',
                      //   ),
                      // ),

                      FormBuilderDropdown(
                        name:
                            'city', // Keep the name for validation and form data retrieval
                        decoration: const InputDecoration(
                          labelText: 'المدينة',
                        ),
                        initialValue: selectedCity,
                        items: const [
                          DropdownMenuItem(
                            value: 'Nouakchott',
                            child: Text('نواكشوط'),
                          ),
                          DropdownMenuItem(
                            value: 'Nema',
                            child: Text('نواذيبو'),
                          ),
                          DropdownMenuItem(
                            value: 'Aioune',
                            child: Text('عيون الملولة'),
                          ),
                          DropdownMenuItem(
                            value: 'Tidjekja',
                            child: Text('تجكجة'),
                          ),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('أخرى'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value
                                .toString(); // Update the selectedCity variable
                          });
                        },
                        // onChanged: (value) {
                        //   setState(() {
                        //     selectedCity = value
                        //         .toString(); // Update the selectedCity variable
                        //   });
                        // },
                        // value: selectedCity, // Set the selected value
                      ),

                      // FormBuilderDropdown(
                      //   name: 'city',
                      //   decoration: const InputDecoration(
                      //     labelText: 'المدينة',
                      //   ),
                      //   items: const [
                      //     DropdownMenuItem(
                      //       value: 'Nouakchott',
                      //       child: Text('نواكشوط'),
                      //     ),
                      //     DropdownMenuItem(
                      //       value: 'Nema',
                      //       child: Text('نواذيبو'),
                      //     ),
                      //     DropdownMenuItem(
                      //       value: 'Aioune',
                      //       child: Text('عيون الملولة'),
                      //     ),
                      //     DropdownMenuItem(
                      //       value: 'Tidjekja',
                      //       child: Text('تجكجة'),
                      //     ),
                      //   ],
                      // ),

                      FormBuilderTextField(
                        name: 'neighborhood',
                        decoration: const InputDecoration(
                          labelText: 'الحي',
                        ),
                        controller: neighborhoodController,
                      ),
                      FormBuilderTextField(
                        name: 'address',
                        decoration: const InputDecoration(
                          labelText: 'العنوان',
                        ),
                        controller: addressController,
                      ),
                      const SizedBox(height: 20),
                      // ElevatedButton(
                      //   child: const Text('إرسال'),
                      //   onPressed: () {
                      //     _formKey.currentState?.save();
                      //     if (_formKey.currentState?.validate() == true) {
                      //       // استخدم البيانات
                      //       var formData = _formKey.currentState?.value;
                      //       print(formData);
                      //       // يمكنك الآن إرسال البيانات إلى خدمة الخلفية إذا كنت تريد
                      //     }
                      //   },
                      // ),
                      // ElevatedButton with full width
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity,
                              36), // double.infinity is the key here
                        ),
                        child: const Text('إرسال'),
                        onPressed: () async {
                          // Use the data from controllers
                          // var formData = {
                          //   'national_id': nationalIdController.text,
                          //   'passport_number': passportNumberController.text,
                          //   'full_name': fullNameController.text,
                          //   'birth_date': birthDateController.text,
                          //   'phone_number': phoneNumberController.text,
                          //   'email': emailController.text,
                          //   'city': selectedCity,
                          //   'neighborhood': neighborhoodController.text,
                          //   'address': addressController.text,
                          // };
                          // sendInfo(formData);

                          // Validate the form
                          if (_formKey.currentState?.validate() == true) {
                            // Form is valid, proceed with sending data

                            showLoadingIndicator();
                            String passportImagePublicUrl = await uploadFile();
                            if (passportImagePublicUrl != "") {
                              var formData = {
                                'national_id': nationalIdController.text,
                                'passport_number':
                                    passportNumberController.text,
                                'full_name': fullNameController.text,
                                'birth_date': birthDateController.text,
                                'phone_number': phoneNumberController.text,
                                'email': emailController.text,
                                'city': selectedCity,
                                'neighborhood': neighborhoodController.text,
                                'address': addressController.text,
                                'passport_image_url': passportImagePublicUrl
                              };
                              if (await checkConnectivity()) {
                                sendInfo(formData);
                              } else {
                                dismissLoadingIndicator();
                                errorSnackBar(
                                    message:
                                        'لا يوجد اتصال ببيانات الهاتف المحمول أو شبكة الواي فاي.');
                              }
                            } else {
                              showPassportImageRequestDialog(context);
                            }
                          } else {
                            // Form is not valid, display validation errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('الرجاء تصحيح الأخطاء في النموذج'),
                              ),
                            );
                          }

                          // _formKey.currentState?.save();
                          // if (_formKey.currentState?.validate() == true) {
                          //   // Use the data
                          //   var formData = _formKey.currentState?.value;
                          //   print(formData);
                          //   // Get.to(() => const FilesPage());

                          //   // You can now send the data to a backend service if you want
                          // }
                        },
                      ),

                      // Container(
                      //   color: const Color.fromARGB(255, 234, 191,
                      //       51), // Use your preferred footer background color
                      //   padding: const EdgeInsets.all(10),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Image.asset(
                      //         'assets/rim_drp.jpg', // Replace with your asset image
                      //         width: 24, // Set your preferred width
                      //         height: 24, // Set your preferred height
                      //       ),
                      //       const SizedBox(
                      //           width: 8), // Spacing between icon and text
                      //       const Text(
                      //         'يمكنك طلب الملفات بمجرد تفعيل الحساب',
                      //         style: TextStyle(
                      //           color:
                      //               Colors.black, // Use your preferred text color
                      //           fontSize: 14, // Set your preferred text size
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                      // Container with full width
                      Container(
                        width: double
                            .infinity, // This makes the Container fill all the horizontal space
                        color: const Color.fromARGB(255, 234, 191, 51),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          // Changed to Row for proper alignment of children
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/rim_drp.jpg', // Replace with your asset image
                              width: 24, // Set your preferred width
                              height: 24, // Set your preferred height
                            ),
                            const SizedBox(
                                width: 8), // Spacing between icon and text
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
