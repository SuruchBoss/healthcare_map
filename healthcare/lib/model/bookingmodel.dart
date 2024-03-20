import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final DateTime dateTime;
  final String clinicName;

  const BookingModel({
    required this.dateTime,
    required this.clinicName,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    return BookingModel(
      dateTime: (doc['dateTime'] as Timestamp).toDate(),
      clinicName: doc['clinicName'],
    );
  }
}

Future<List<BookingModel>> getBookingsForSelectedDate(
    DateTime selectedDate) async {
  final startOfDay =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  final endOfDay =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

  final querySnapshot = await FirebaseFirestore.instance
      .collection('Bookings')
      .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
      .where('dateTime', isLessThan: Timestamp.fromDate(endOfDay))
      .get();

  return querySnapshot.docs
      .map((doc) => BookingModel.fromFirestore(doc))
      .toList();
}
