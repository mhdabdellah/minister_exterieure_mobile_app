import 'package:cloud_firestore/cloud_firestore.dart';

class DownloadHistoriqueDataSource {
  final CollectionReference _telechargement_hystoriqueCollectionRef =
      FirebaseFirestore.instance.collection('historique_telechargements');

  Future addDownloadHystorique(
      {required String fileName, required String passportNumber}) async {
    await _telechargement_hystoriqueCollectionRef.add({
      'le_fichier_telechargee': fileName,
      'passport_number': passportNumber,
    });
  }
}
