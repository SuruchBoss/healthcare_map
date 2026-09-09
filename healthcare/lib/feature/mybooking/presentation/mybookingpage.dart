import 'package:flutter/material.dart';
import 'package:healthcare/model/bookingmodel.dart';
import 'package:healthcare/util/datetime.dart';

import 'package:table_calendar/table_calendar.dart';

class MyBookingPage extends StatefulWidget {
  final int customerId;

  const MyBookingPage({super.key, required this.customerId});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<BookingModel> _selectedDayBookings = [];

  _fetchBookingsForDay(DateTime day) async {
    final bookings = await getBookingsForSelectedDate(day, widget.customerId);
    setState(() {
      _selectedDayBookings = bookings;
    });
  }

  Future<void> _confirmCancelBooking(
      BuildContext context, BookingModel booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel booking'),
          content: Text(
              'Cancel your booking at ${booking.clinicName}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Yes, cancel'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await deleteBooking(booking.id);
      await _fetchBookingsForDay(_selectedDay);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBookingsForDay(_selectedDay);
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
            child: _selectedDayBookings.isEmpty
                ? Center(
                    child: Text(
                      'No bookings on this day',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedDayBookings.length,
                    itemBuilder: (context, index) {
                      final booking = _selectedDayBookings[index];
                      String dateTime = formatDateTime(
                          booking.dateTime.toLocal().toString());

                      return ListTile(
                        title: Text(booking.clinicName),
                        subtitle: Text(
                          'Date: $dateTime',
                          style: const TextStyle(fontSize: 12.0),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel_outlined,
                              color: Colors.red),
                          tooltip: 'Cancel booking',
                          onPressed: () =>
                              _confirmCancelBooking(context, booking),
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
