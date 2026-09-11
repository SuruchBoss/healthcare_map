import 'package:flutter/material.dart';
import 'package:healthcare/model/bookingmodel.dart';
import 'package:healthcare/model/clinicmodel.dart';
import 'package:healthcare/theme/app_theme.dart';
import 'package:healthcare/util/datetime.dart';

class ClinicDetailPage extends StatefulWidget {
  final ClinicModel model;
  final int customerId;
  const ClinicDetailPage(
      {super.key, required this.model, required this.customerId});

  @override
  State<ClinicDetailPage> createState() => _ClinicDetailPageState();
}

class _ClinicDetailPageState extends State<ClinicDetailPage> {
  String selectTime = '';
  DateTime selectedDate = DateTime.now();

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth,
                height: 260,
                color: AppColors.background,
                child: Image.asset(
                  widget.model.imageUrl!,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 20,
                  right: 20,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.model.detail,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondarySoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.phone_rounded,
                            color: AppColors.secondary,
                            size: 18.0,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.model.phone,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => showTimeSlotDialog(
                          context,
                          widget.model,
                        ),
                        icon: const Icon(Icons.calendar_month_rounded,
                            size: 20),
                        label: const Text("Check Booking"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 56,
          left: 20,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 2,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
                size: 18.0,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
