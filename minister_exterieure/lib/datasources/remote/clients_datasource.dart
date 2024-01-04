import 'package:cloud_firestore/cloud_firestore.dart';

class ClientsDataSource {
  final CollectionReference _clientCollectionRef =
      FirebaseFirestore.instance.collection('clients');
  final firestore = FirebaseFirestore.instance;

  Future addClient({required Map<String, dynamic> formData}) async {
    await _clientCollectionRef.add({
      'passport_image_url': formData['passport_image_url'],
      'passport_number': formData['passport_number'],
      'passport_date_emission': formData['passport_date_emission'],
      'passport_date_expiration': formData['passport_date_expiration'],
      'national_id': formData['national_id'],
      'full_name': formData['full_name'],
      'birth_date': formData['birth_date'],
      'phone_number': formData['phone_number'],
      'email': formData['email'],
      'city': formData['city'],
      'neighborhood': formData['neighborhood'],
      'address_mauritanie': formData['address'],
      'Permi_de_sejour': formData['Permi_de_sejour'],
      "objectif_de_sejour": formData['objectif_de_sejour'],
      "Permi_de_sejour_debut": formData['Permi_de_sejour_debut'],
      "Permi_de_sejour_expiration": formData['Permi_de_sejour_expiration'],
    });
  }

  Future setClient(
      {required Map<String, dynamic> formData,
      required String documentId}) async {
    await _clientCollectionRef.doc(documentId).set({
      'passport_image_url': formData['passport_image_url'],
      'passport_number': formData['passport_number'],
      'passport_date_emission': formData['passport_date_emission'],
      'passport_date_expiration': formData['passport_date_expiration'],
      'national_id': formData['national_id'],
      'full_name': formData['full_name'],
      'birth_date': formData['birth_date'],
      'phone_number': formData['phone_number'],
      'email': formData['email'],
      'city': formData['city'],
      'neighborhood': formData['neighborhood'],
      'address_mauritanie': formData['address'],
      'Permi_de_sejour': formData['Permi_de_sejour'],
      "objectif_de_sejour": formData['objectif_de_sejour'],
      "Permi_de_sejour_debut": formData['Permi_de_sejour_debut'],
      "Permi_de_sejour_expiration": formData['Permi_de_sejour_expiration'],
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getClientByPassportNumber(
      {required String passportNumber}) async {
    // final firestore = FirebaseFirestore.instance;
    // DocumentSnapshot<Map<String, dynamic>> clientInfo =
    //     await _clientCollectionRef.doc(passportNumber).get();

    DocumentSnapshot<Map<String, dynamic>> clientInfo =
        await firestore.collection('clients').doc(passportNumber).get();
    return clientInfo;
  }
}
