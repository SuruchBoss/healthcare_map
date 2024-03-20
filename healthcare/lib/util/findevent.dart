import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/model/bookingmodel.dart';

Future<DateTime?> findDateOfNearestUpcomingEvent() async {
  final now = DateTime.now();
  final querySnapshot = await FirebaseFirestore.instance
      .collection('Bookings')
      .where('dateTime', isGreaterThan: Timestamp.fromDate(now))
      .orderBy('dateTime')
      .limit(1)
      .get();

  if (querySnapshot.docs.isEmpty) {
    return null; // No upcoming events
  }

  final nearestBooking = BookingModel.fromFirestore(querySnapshot.docs.first);
  return nearestBooking.dateTime;
}
