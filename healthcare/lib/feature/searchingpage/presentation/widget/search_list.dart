import 'dart:math';

import 'package:flutter/material.dart';
import 'package:healthcare/feature/clinicdetail/presentation/clinic_detail_page.dart';
import 'package:healthcare/model/clinicmodel.dart';

class SearchList extends StatefulWidget {
  const SearchList({super.key});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  String selectTime = '';

  void _goToClinicDetailPage(BuildContext context, ClinicModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClinicDetailPage(
          model: model,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> generateTimeSlots() {
    final random = Random();
    return List.generate(14, (index) {
      final hour = 7 + index;
      return {
        'time':
            '${hour.toString().padLeft(2, '0')}.00 - ${(hour + 1).toString().padLeft(2, '0')}.00',
        'available':
            random.nextBool(), // Randomly mark some slots as unavailable
      };
    });
  }

  void showTimeSlotDialog(BuildContext context, ClinicModel model) {
    final timeSlots = generateTimeSlots();
    Map<String, dynamic>? selectedSlot =
        timeSlots.firstWhere((slot) => slot['available']);

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
                      _showDoneBooking(context, model);
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

  Future<void> _showDoneBooking(BuildContext context, ClinicModel model) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thank you !'),
          content:
              Text('You have done booking clinic ${model.name} at $selectTime'),
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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred!'));
        } else {
          final clinics = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemCount: clinics.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final model = clinics[index];

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
