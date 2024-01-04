import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:minister_exterieure/constant.dart';
import 'package:minister_exterieure/datasources/remote/clients_datasource.dart';
import 'package:minister_exterieure/views/customWidgets/dialog/errorSnackBar.dart';
import 'package:minister_exterieure/views/customWidgets/dialog/loading.dart';
import 'package:minister_exterieure/views/customWidgets/dialog/successSnackBar.dart';
import 'package:minister_exterieure/views/filesPage.dart';

import 'package:path/path.dart' as Path;

class RegisterFormController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  // Define a global key for each step of the form
  final GlobalKey<FormBuilderState> userInfoFormKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> contactInfoFormKey =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> otherInfoFormKey =
      GlobalKey<FormBuilderState>();

  final GlobalKey<FormBuilderState> statusInfoFormKey =
      GlobalKey<FormBuilderState>();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController passportNumberController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController phoneNumberMauritanieController =
      TextEditingController();
  String initialCountry = 'MR'; // 'MR' is the ISO code for Mauritania
  PhoneNumber number = PhoneNumber(isoCode: 'MR');
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController to_dateController = TextEditingController();
  final TextEditingController from_dateController = TextEditingController();
  final TextEditingController permi_sejourController = TextEditingController();
  final TextEditingController emission_dateController = TextEditingController();
  final TextEditingController expiration_dateController =
      TextEditingController();

  late int years;
  bool isEmissionDateBeforeExpirationDate = false;
  String selectedCity = 'Other'; // Default value if needed
  String selectedObject = "تجارة";
  File? selectedImage;
  UploadTask? task; // Firebase storage upload task
  late int currentStep = 0;

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      // setState(() {
      selectedImage = File(pickedImage.path);
      // });
    }
    update();
  }

  Future<String> uploadFile({required String fileName}) async {
    if (selectedImage == null) return "";

    final fileName = Path.basename(selectedImage!.path);
    // final destination = 'passport_images/$fileName.png';
    final destination = 'passport_images/$fileName';

    task = FirebaseStorage.instance.ref(destination).putFile(selectedImage!);

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
    // const allowedCities = {'Nouakchott', 'Nema', 'Aioune', 'Tidjekja'};

    // Check if the selected city is in the allowed list
    // if (allowedCities.contains(formData['city'])) {
    //
    // } else {
    //   // City not allowed, print the message
    //   print("You are not able");
    //   showNotAllowedCityDialog(context);
    //   // You can also inform the user with a dialog or a snackbar
    // }

    String documentId = formData['passport_number'].toString();
    // print("documentId : $documentId");

    try {
      if (await checkConnectivity()) {
        await ClientsDataSource().setClient(
          formData: formData,
          documentId: documentId,
        );
        // print("formData : $formData");

        // Data sent successfully
        successSnackBar(message: "تم استلام معلوماتكم الشخصية وتسجيلها بنجاح.");
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

  List<Step> getSteps() => [
        Step(
            title: const Text("جواز السفر"),
            content: Container(
                child: FormBuilder(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: <Widget>[
                          // Place the Passport Capture Image here
                          GestureDetector(
                            onTap:
                                pickImageFromCamera, // Open the image picker when tapped
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10.0),
                              child: selectedImage == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 100,
                                      color: Color(0xFF00A95C),
                                    )
                                  : Image.file(
                                      selectedImage!,
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit
                                          .cover, // You can adjust the fit as needed
                                    ),
                            ),
                          ),
                          //... (all other form fields here)

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
                                return 'يجب أن يتبع رقم الجواز النمط الصحيح (مثال: B12345678)';
                              }
                              return null; // Validation passed
                            },
                          ),
                          FormBuilderDateTimePicker(
                            name: 'emission_date',
                            inputType: InputType.date,
                            format: DateFormat("yyyy-MM-dd"),
                            decoration: const InputDecoration(
                              labelText: 'تاريخ الإصدار',
                            ),
                            controller: emission_dateController,
                          ),
                          FormBuilderDateTimePicker(
                              name: 'valable_to_date',
                              inputType: InputType.date,
                              format: DateFormat("yyyy-MM-dd"),
                              decoration: const InputDecoration(
                                labelText: 'تاريخ الإنتهاء',
                              ),
                              controller: expiration_dateController,
                              validator: (value) {
                                // setState(() {
                                // Assuming the date format is 'yyyy-MM-dd'
                                DateTime expirationDate = DateTime.parse(
                                    expiration_dateController.text);
                                DateTime emissionDate = DateTime.parse(
                                    emission_dateController.text);

                                // Calculate the difference in days
                                Duration diff =
                                    expirationDate.difference(emissionDate);

                                // Convert the difference to years
                                years = (diff.inDays / 365)
                                    .floor(); // This is a simple approximation
                                // });
                                update();

                                // Check if the difference is 5 years
                                if (years < 5) {
                                  // Your logic for when the difference is exactly 5 years
                                  return 'التاريخ غير صحيح';
                                }
                                return null;
                              }),
                        ]))))),
        Step(
            title: const Text(" المستخدم"),
            content: Container(
              child: FormBuilder(
                  key: userInfoFormKey,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
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
                      ]))),
            )),
        Step(
            title: const Text("الاتصال"),
            content: Container(
              child: FormBuilder(
                  key: contactInfoFormKey,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        FormBuilderTextField(
                          name: 'phone_number',
                          decoration: const InputDecoration(
                            labelText: 'رقم الهاتف بالمغرب ',
                          ),
                          controller: phoneNumberController,
                          validator: (value) {
                            final phoneNumber = phoneNumberController.text;
                            if (phoneNumber.isEmpty) {
                              return 'يرجى إدخال رقم الهاتف';
                            }

                            // Define a regular expression pattern for phone number validation (8 or more digits)
                            final RegExp pattern = RegExp(r'^\d{6,}$');

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
                          name: 'phone_number_en_mauritanie',
                          decoration: const InputDecoration(
                            labelText: 'رقم الهاتف بموريتانيا',
                          ),
                          controller: phoneNumberMauritanieController,
                          validator: (value) {
                            final phoneNumber =
                                phoneNumberMauritanieController.text;
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
                      ]))),
            )),
        Step(
            title: const Text("العنوان"),
            content: Container(
              child: FormBuilder(
                  key: otherInfoFormKey,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        FormBuilderTextField(
                            name: 'city',
                            decoration: const InputDecoration(
                              labelText: 'المدينة',
                            ),
                            controller: cityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال المدينة';
                              }
                              return null;
                            }),
                        FormBuilderTextField(
                            name: 'neighborhood',
                            decoration: const InputDecoration(
                              labelText: 'الحي ,المقاطعة أو الإقليم ',
                            ),
                            controller: neighborhoodController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال الحي ,المقاطعة أو الإقليم ';
                              }
                              return null;
                            }),
                        FormBuilderTextField(
                            name: 'address',
                            decoration: const InputDecoration(
                              labelText: 'العنوان بموريتانيا',
                            ),
                            controller: addressController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال العنوان بموريتانيا ';
                              }
                              return null;
                            }),
                      ]))),
            )),
        Step(
            title: const Text("الوضعية بالمملكة المغربية"),
            content: Container(
              child: FormBuilder(
                  key: statusInfoFormKey,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        FormBuilderTextField(
                          name: 'permi_sejour',
                          decoration: const InputDecoration(
                            labelText: 'رقم رخصة الدخول',
                          ),
                          controller: permi_sejourController,
                        ),
                        FormBuilderDateTimePicker(
                          name: 'from_date',
                          inputType: InputType.date,
                          format: DateFormat("yyyy-MM-dd"),
                          decoration: const InputDecoration(
                            labelText: 'صالحة من ',
                          ),
                          controller: from_dateController,
                        ),
                        FormBuilderDateTimePicker(
                            name: 'to_date',
                            inputType: InputType.date,
                            format: DateFormat("yyyy-MM-dd"),
                            decoration: const InputDecoration(
                              labelText: 'الى',
                            ),
                            controller: to_dateController,
                            validator: (value) {
                              // setState(() {
                              // Assuming the date format in the controllers is 'yyyy-MM-dd'
                              DateTime fromDate =
                                  DateTime.parse(from_dateController.text);
                              DateTime toDate =
                                  DateTime.parse(to_dateController.text);

                              // Check if emissionDate is before expirationDate
                              isEmissionDateBeforeExpirationDate =
                                  fromDate.isBefore(toDate);
                              // });
                              update();

                              // Now you can use this boolean value for your logic
                              if (isEmissionDateBeforeExpirationDate) {
                                // Logic for when emissionDate is before expirationDate
                                return 'التاريخ غير صحيح';
                              }
                              return null;
                            }),
                        FormBuilderDropdown(
                          name:
                              'forObject', // Keep the name for validation and form data retrieval
                          decoration: const InputDecoration(
                            labelText: 'لغرض',
                          ),
                          initialValue: selectedObject,
                          items: const [
                            DropdownMenuItem(
                              value: 'تجارة',
                              child: Text('تجارة'),
                            ),
                            DropdownMenuItem(
                              value: 'سياحة',
                              child: Text('سياحة'),
                            ),
                            DropdownMenuItem(
                              value: 'عمل',
                              child: Text('عمل'),
                            ),
                            DropdownMenuItem(
                              value: 'دراسة',
                              child: Text('دراسة'),
                            ),
                            DropdownMenuItem(
                              value: 'لقاء عائلي',
                              child: Text('لقاء عائلي'),
                            ),
                            DropdownMenuItem(
                              value: 'علاج',
                              child: Text('علاج'),
                            ),
                            // DropdownMenuItem(
                            //   value: 'أخرى',
                            //   child: Text('أخرى'),
                            // ),
                          ],
                          onChanged: (value) {
                            // setState(() {
                            selectedObject = value
                                .toString(); // Update the selectedCity variable
                            // });
                            update();
                          },
                        ),
                      ]))),
            )),
      ];
}
