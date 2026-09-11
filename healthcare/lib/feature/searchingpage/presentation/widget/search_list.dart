import 'package:flutter/material.dart';
import 'package:healthcare/feature/clinicdetail/presentation/clinic_detail_page.dart';
import 'package:healthcare/model/bookingmodel.dart';
import 'package:healthcare/model/clinicmodel.dart';
import 'package:healthcare/theme/app_theme.dart';
import 'package:healthcare/util/datetime.dart';
import 'package:healthcare/util/distance.dart';
import 'package:healthcare/widget/skeleton_loader.dart';

class SearchList extends StatefulWidget {
  final int customerId;
  final double? userLat;
  final double? userLon;

  const SearchList(
      {super.key, required this.customerId, this.userLat, this.userLon});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  String selectTime = '';
  DateTime selectedDate = DateTime.now();

  void _goToClinicDetailPage(BuildContext context, ClinicModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClinicDetailPage(
          model: model,
          customerId: widget.customerId,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> generateTimeSlots(Set<int> bookedHours) {
    return List.generate(14, (index) {
      final hour = 7 + index;
      return {
        'time':
            '${hour.toString().padLeft(2, '0')}.00 - ${(hour + 1).toString().padLeft(2, '0')}.00',
        'hour': hour,
        'available': !bookedHours.contains(hour),
      };
    });
  }

  Future<void> showTimeSlotDialog(
      BuildContext context, ClinicModel model) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );
    if (pickedDate == null || !context.mounted) return;

    final bookedTimes = await getBookedTimesForClinic(model.name, pickedDate);
    final bookedHours = bookedTimes.map((dt) => dt.hour).toSet();
    final timeSlots = generateTimeSlots(bookedHours);

    if (!timeSlots.any((slot) => slot['available'] as bool)) {
      if (context.mounted) _showFullyBookedDialog(context);
      return;
    }

    selectedDate = pickedDate;
    Map<String, dynamic>? selectedSlot =
        timeSlots.firstWhere((slot) => slot['available'] as bool);

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select a Time Slot"),
              content: DropdownButton<Map<String, dynamic>>(
                value: selectedSlot,
                isExpanded: true,
                onChanged: (newValue) {
                  if (newValue!['available']) {
                    setState(() => selectedSlot = newValue);
                  } else {
                    // Optionally, show a message that this slot is not available
                  }
                },
                items: timeSlots.map((slot) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: slot,
                    child: Text(
                      slot['time'],
                      style: TextStyle(
                          color:
                              slot['available'] ? Colors.black : Colors.grey),
                    ),
                  );
                }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    if (selectedSlot != null && selectedSlot!['available']) {
                      selectTime = selectedSlot!['time'];

                      Navigator.of(context).pop(true);
                      _bookSlot(context, model);
                    } else {}
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFullyBookedDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fully booked'),
          content: const Text(
              'All time slots for this date are already booked. Please choose another date.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _bookSlot(BuildContext context, ClinicModel model) async {
    final startHour = int.parse(selectTime.split('.').first);
    final bookingDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startHour,
    );
    await addBooking(model.name, bookingDateTime, widget.customerId);
    if (context.mounted) {
      _showDoneBooking(context, model, bookingDateTime);
    }
  }

  Future<void> _showDoneBooking(
      BuildContext context, ClinicModel model, DateTime bookingDateTime) {
    final formattedDateTime =
        formatDateTime(bookingDateTime.toLocal().toString());
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank you !'),
          content: Text(
              'You have booked clinic ${model.name} on $formattedDateTime'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClinicModel>>(
      future: getClinics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SkeletonColumn(count: 3, itemHeight: 150);
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred!'));
        } else {
          final clinics = List<ClinicModel>.from(snapshot.data!);

          if (clinics.isEmpty) {
            return const Center(
              child: Text(
                'No clinics found',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final userLat = widget.userLat;
          final userLon = widget.userLon;

          if (userLat != null && userLon != null) {
            clinics.sort((a, b) {
              final distanceA = calculateDistanceKm(
                  userLat, userLon, double.parse(a.lat), double.parse(a.lon));
              final distanceB = calculateDistanceKm(
                  userLat, userLon, double.parse(b.lat), double.parse(b.lon));
              return distanceA.compareTo(distanceB);
            });
          }

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: clinics.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final model = clinics[index];
              final distanceText = (userLat != null && userLon != null)
                  ? '${calculateDistanceKm(userLat, userLon, double.parse(model.lat), double.parse(model.lon)).toStringAsFixed(1)} km away'
                  : null;

              return Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _goToClinicDetailPage(context, model),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 84,
                            height: 84,
                            color: AppColors.background,
                            child: Image.asset(
                              model.imageUrl!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                model.detail,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (distanceText != null) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      size: 14,
                                      color: AppColors.secondary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      distanceText,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColors.primarySoft,
                                    foregroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () => showTimeSlotDialog(
                                    context,
                                    model,
                                  ),
                                  child: const Text(
                                    "Check Booking",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
