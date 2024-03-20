import 'package:flutter/material.dart';
import 'package:healthcare/model/bookingmodel.dart';
import 'package:healthcare/util/datetime.dart';

import 'package:table_calendar/table_calendar.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<BookingModel> _selectedDayBookings = [];

  _fetchBookingsForDay(DateTime day) async {
    final bookings = await getBookingsForSelectedDate(day);
    setState(() {
      _selectedDayBookings = bookings;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Screen'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              await _fetchBookingsForDay(selectedDay);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedDayBookings.length,
              itemBuilder: (context, index) {
                final booking = _selectedDayBookings[index];
                String dateTime =
                    formatDateTime(booking.dateTime.toLocal().toString());

                print(booking.dateTime.toLocal());
                return ListTile(
                  title: Text(booking.clinicName),
                  subtitle: Text(
                    'Date: $dateTime',
                    style: const TextStyle(fontSize: 12.0),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
