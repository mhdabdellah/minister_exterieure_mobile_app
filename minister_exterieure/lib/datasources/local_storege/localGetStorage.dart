import 'package:get_storage/get_storage.dart';

class LocalGetStorage {
  GetStorage localstorage = GetStorage();

  // --------------------------- client ---------------------------
  Future<dynamic> getUser() async {
    return await GetStorage().read('client');
  }

  Future setUser(String client) async {
    await GetStorage().write('client', client);
  }

  Future removeUser() async {
    await GetStorage().remove('client');
  }

  // --------------------------- downloadHistorique ---------------------------
  Future<dynamic> getDownloadHistorique() async {
    return await GetStorage().read('downloadHistorique');
  }

  Future setDownloadHistorique(String downloadHistorique) async {
    await GetStorage().write('downloadHistorique', downloadHistorique);
  }

  Future removeDownloadHistorique() async {
    await GetStorage().remove('downloadHistorique');
  }

  // ----------------------lang--------------------------------
  void writeLanguage(String lang) async {
    await GetStorage().write('lang', lang);
  }

  String? get getLanguage {
    String? lang = GetStorage().read('lang');

    return lang;
  }
}
