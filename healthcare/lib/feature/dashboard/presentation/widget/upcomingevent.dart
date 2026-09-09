import 'package:flutter/material.dart';
import 'package:healthcare/model/bookingmodel.dart';
import 'package:healthcare/util/datetime.dart';
import 'package:healthcare/util/findevent.dart';
import 'package:healthcare/widget/skeleton_loader.dart';

class UpcomingEventsWidget extends StatelessWidget {
  final int customerId;

  const UpcomingEventsWidget({super.key, required this.customerId});

  Future<List<BookingModel>> _fetchBookings() async {
    DateTime? nearestEventDate =
        await findDateOfNearestUpcomingEvent(customerId);
    if (nearestEventDate != null) {
      return getBookingsForSelectedDate(nearestEventDate, customerId);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookingModel>>(
      future: _fetchBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SkeletonRow(count: 2, itemWidth: 300);
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
                  child: SizedBox(
                    width: 300,
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
