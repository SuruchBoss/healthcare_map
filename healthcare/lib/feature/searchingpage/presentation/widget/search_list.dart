import 'package:flutter/material.dart';
import 'package:healthcare/feature/clinicdetail/presentation/clinic_detail_page.dart';
import 'package:healthcare/model/bookingmodel.dart';
import 'package:healthcare/model/clinicmodel.dart';
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
            return Center(
              child: Text(
                'No clinics found',
                style: TextStyle(color: Colors.grey[600]),
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
            padding: const EdgeInsets.all(0),
            itemCount: clinics.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final model = clinics[index];
              final distanceText = (userLat != null && userLon != null)
                  ? '${calculateDistanceKm(userLat, userLon, double.parse(model.lat), double.parse(model.lon)).toStringAsFixed(1)} km away'
                  : null;

              return Center(
                child: TextButton(
                  onPressed: () => _goToClinicDetailPage(
                    context,
                    model,
                  ),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 1),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Image.asset(
                            model.imageUrl!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.name,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.blue[900]),
                              ),
                              Text(model.detail),
                              if (distanceText != null)
                                Text(
                                  distanceText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              const SizedBox(height: 15),
                              TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 1),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.centerLeft),
                                onPressed: () => showTimeSlotDialog(
                                  context,
                                  model,
                                ),
                                child: Text(
                                  "Check Booking",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.orange[700],
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
