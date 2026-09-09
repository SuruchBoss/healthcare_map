import 'package:healthcare/db/database_helper.dart';

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

  factory ClinicModel.fromMap(Map<String, Object?> map) {
    return ClinicModel(
      id: map['id'].toString(),
      name: map['name'] as String,
      detail: map['detail'] as String,
      phone: map['phone'] as String,
      lat: map['lat'] as String,
      lon: map['lon'] as String,
      imageUrl: map['imageUrl'] as String?,
    );
  }
}

Future<List<ClinicModel>> getClinics() async {
  final db = await DatabaseHelper.instance.database;
  final rows = await db.query('Clinics');

  return rows.map((row) => ClinicModel.fromMap(row)).toList();
}

/// Clinics that already have a booking, most recently booked first.
Future<List<ClinicModel>> getRecentlyBookedClinics({int limit = 10}) async {
  final db = await DatabaseHelper.instance.database;
  final bookingRows = await db.rawQuery('''
    SELECT clinicName, MAX(dateTime) as latestBooking
    FROM Bookings
    GROUP BY clinicName
    ORDER BY latestBooking DESC
    LIMIT ?
  ''', [limit]);

  final clinics = <ClinicModel>[];
  for (final bookingRow in bookingRows) {
    final clinicRows = await db.query(
      'Clinics',
      where: 'name = ?',
      whereArgs: [bookingRow['clinicName']],
      limit: 1,
    );
    if (clinicRows.isNotEmpty) {
      clinics.add(ClinicModel.fromMap(clinicRows.first));
    }
  }
  return clinics;
}
