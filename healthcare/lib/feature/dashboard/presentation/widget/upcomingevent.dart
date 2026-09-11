import 'package:flutter/material.dart';
import 'package:healthcare/model/bookingmodel.dart';
import 'package:healthcare/theme/app_theme.dart';
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "No upcoming events found",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        } else {
          List<BookingModel> bookings = snapshot.data!;
          return SizedBox(
            height: 88,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                String dateTime =
                    formatDateTime(booking.dateTime.toLocal().toString());
                return Container(
                  width: 260,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_available_rounded,
                          color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.clinicName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dateTime,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
