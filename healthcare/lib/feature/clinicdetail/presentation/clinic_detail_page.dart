import 'dart:math';

import 'package:flutter/material.dart';
import 'package:healthcare/model/clinicmodel.dart';

class ClinicDetailPage extends StatefulWidget {
  final ClinicModel model;
  const ClinicDetailPage({super.key, required this.model});

  @override
  State<ClinicDetailPage> createState() => _ClinicDetailPageState();
}

class _ClinicDetailPageState extends State<ClinicDetailPage> {
  String selectTime = '';

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.model.imageUrl!,
              width: screenWidth,
              height: 400,
              fit: BoxFit.cover,
            ),
            Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.name,
                      style: const TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.model.detail,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_android,
                          color: Colors.green,
                          size: 33.0,
                        ),
                        Text(
                          widget.model.phone,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 70),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 1),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft),
                        onPressed: () => showTimeSlotDialog(
                          context,
                          widget.model,
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
                    )
                  ],
                )),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(
            top: 60,
            left: 20,
            right: 20,
            bottom: 30,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 30.0,
            ),
          ),
        ),
      ]),
    );
  }
}
