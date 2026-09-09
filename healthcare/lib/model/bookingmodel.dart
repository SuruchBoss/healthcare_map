import 'package:healthcare/db/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class BookingModel {
  final DateTime dateTime;
  final String clinicName;

  const BookingModel({
    required this.dateTime,
    required this.clinicName,
  });

  factory BookingModel.fromMap(Map<String, Object?> map) {
    return BookingModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      clinicName: map['clinicName'] as String,
    );
  }
}

Future<int> getBookingCount() async {
  final db = await DatabaseHelper.instance.database;
  final result =
      await db.rawQuery('SELECT COUNT(*) as count FROM Bookings');
  return Sqflite.firstIntValue(result) ?? 0;
}

Future<void> addBooking(String clinicName, DateTime dateTime) async {
  final db = await DatabaseHelper.instance.database;
  await db.insert('Bookings', {
    'clinicName': clinicName,
    'dateTime': dateTime.millisecondsSinceEpoch,
  });
}

Future<List<BookingModel>> getBookingsForSelectedDate(
    DateTime selectedDate) async {
  final startOfDay =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  final endOfDay =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

  final db = await DatabaseHelper.instance.database;
  final rows = await db.query(
    'Bookings',
    where: 'dateTime >= ? AND dateTime < ?',
    whereArgs: [
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    ],
  );

  return rows.map((row) => BookingModel.fromMap(row)).toList();
}

Future<List<DateTime>> getBookedTimesForClinic(
    String clinicName, DateTime date) async {
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day + 1);

  final db = await DatabaseHelper.instance.database;
  final rows = await db.query(
    'Bookings',
    where: 'clinicName = ? AND dateTime >= ? AND dateTime < ?',
    whereArgs: [
      clinicName,
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    ],
  );

  return rows
      .map((row) => DateTime.fromMillisecondsSinceEpoch(row['dateTime'] as int))
      .toList();
}
