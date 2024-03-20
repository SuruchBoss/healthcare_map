// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:healthcare/model/bookingmodel.dart';
import 'package:healthcare/util/datetime.dart';
import 'package:healthcare/util/findevent.dart';

class UpcomingEventsWidget extends StatefulWidget {
  const UpcomingEventsWidget({super.key});

  @override
  _UpcomingEventsWidgetState createState() => _UpcomingEventsWidgetState();
}

class _UpcomingEventsWidgetState extends State<UpcomingEventsWidget> {
  late Future<List<BookingModel>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = _fetchBookings();
  }

  Future<List<BookingModel>> _fetchBookings() async {
    DateTime? nearestEventDate = await findDateOfNearestUpcomingEvent();
    if (nearestEventDate != null) {
      return getBookingsForSelectedDate(nearestEventDate);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookingModel>>(
      future: _futureBookings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.data!.isEmpty) {
          return const Text("No upcoming events found");
        } else {
          List<BookingModel> bookings = snapshot.data!;
          return Container(
            height: 100,
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                String dateTime =
                    formatDateTime(booking.dateTime.toLocal().toString());
                return Card(
                  child: Container(
                    width: 300, // Adjust the width as needed
                    child: ListTile(
                      title: Text(booking.clinicName),
                      subtitle: Text(dateTime),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
