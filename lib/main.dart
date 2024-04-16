import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minister_exterieure_mobile_app/constant.dart';
import 'package:minister_exterieure_mobile_app/languages/traslation.dart';
import 'package:minister_exterieure_mobile_app/views/splashScreen/splashScreen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        // useInheritedMediaQuery: true, // Set to true
        // initialBinding: Binding(),
        debugShowCheckedModeBanner: false,
        // ----------lang
        translations: Translation(),
        // locale: Get.deviceLocale,
        locale: const Locale('ar'),
        fallbackLocale: const Locale('ar'),
        defaultTransition: Transition.cupertino,
        theme: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
            ),
            appBarTheme: AppBarTheme(
              color:primaryColor ,
            ),
        ),
        home: const SplashScreen(),
      );
    });
  }
}
