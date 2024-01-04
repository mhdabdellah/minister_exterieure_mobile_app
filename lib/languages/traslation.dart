import 'package:get/get.dart';
import 'package:minister_exterieure_mobile_app/languages/%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9.dart';
import 'package:minister_exterieure_mobile_app/languages/english.dart';
import 'package:minister_exterieure_mobile_app/languages/francais.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': arabic,
        'fr': francais,
        'en': english,
      };
}
