import 'package:healthcare/db/database_helper.dart';
import 'package:healthcare/model/bookingmodel.dart';

Future<DateTime?> findDateOfNearestUpcomingEvent(int customerId) async {
  final now = DateTime.now();

  final db = await DatabaseHelper.instance.database;
  final rows = await db.query(
    'Bookings',
    where: 'customerId = ? AND dateTime > ?',
    whereArgs: [customerId, now.millisecondsSinceEpoch],
    orderBy: 'dateTime ASC',
    limit: 1,
  );

  if (rows.isEmpty) {
    return null; // No upcoming events
  }

  final nearestBooking = BookingModel.fromMap(rows.first);
  return nearestBooking.dateTime;
}
