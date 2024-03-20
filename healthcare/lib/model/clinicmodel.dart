import 'package:cloud_firestore/cloud_firestore.dart';

class ClinicModel {
  final String id;
  final String name;
  final String detail;
  final String phone;
  final String lat;
  final String lon;
  final String? imageUrl;

  const ClinicModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.phone,
    required this.lat,
    required this.lon,
    this.imageUrl,
  });

  factory ClinicModel.fromDocument(DocumentSnapshot doc) {
    return ClinicModel(
      id: doc.id,
      name: doc['name'],
      detail: doc['detail'],
      phone: doc['phone'],
      lat: doc['lat'],
      lon: doc['lon'],
      imageUrl: doc[
          'imageUrl'], // This might need a null check depending on your data
    );
  }
}

Future<List<ClinicModel>> getClinics() async {
  final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('Clinics').get();

  return snapshot.docs.map((doc) => ClinicModel.fromDocument(doc)).toList();
}
