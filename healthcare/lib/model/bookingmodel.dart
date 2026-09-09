import 'package:healthcare/db/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class BookingModel {
  final int id;
  final DateTime dateTime;
  final String clinicName;

  const BookingModel({
    required this.id,
    required this.dateTime,
    required this.clinicName,
  });

  factory BookingModel.fromMap(Map<String, Object?> map) {
    return BookingModel(
      id: map['id'] as int,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      clinicName: map['clinicName'] as String,
    );
  }
}

Future<int> getBookingCount(int customerId) async {
  final db = await DatabaseHelper.instance.database;
  final result = await db.rawQuery(
    'SELECT COUNT(*) as count FROM Bookings WHERE customerId = ?',
    [customerId],
  );
  return Sqflite.firstIntValue(result) ?? 0;
}

Future<void> addBooking(
    String clinicName, DateTime dateTime, int customerId) async {
  final db = await DatabaseHelper.instance.database;
  await db.insert('Bookings', {
    'customerId': customerId,
    'clinicName': clinicName,
    'dateTime': dateTime.millisecondsSinceEpoch,
  });
}

Future<void> deleteBooking(int id) async {
  final db = await DatabaseHelper.instance.database;
  await db.delete('Bookings', where: 'id = ?', whereArgs: [id]);
}

Future<List<BookingModel>> getBookingsForSelectedDate(
    DateTime selectedDate, int customerId) async {
  final startOfDay =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  final endOfDay =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

  final db = await DatabaseHelper.instance.database;
  final rows = await db.query(
    'Bookings',
    where: 'customerId = ? AND dateTime >= ? AND dateTime < ?',
    whereArgs: [
      customerId,
      startOfDay.millisecondsSinceEpoch,
      endOfDay.millisecondsSinceEpoch,
    ],
  );

  return rows.map((row) => BookingModel.fromMap(row)).toList();
}

/// Booked hours for a clinic on a date, across every customer — a slot a
/// different customer already took should still show as unavailable.
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
