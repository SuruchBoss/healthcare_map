// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthcare/feature/searchingpage/presentation/widget/search_list.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  bool isShow = false;

  GoogleMapController? mapController;
  Set<Marker> markers = Set();

  final LatLng _center = const LatLng(13.746597, 100.539360);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(_center.toString()),
          position: _center,
          infoWindow: const InfoWindow(
            title: 'My Location',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  List<String> generateTimeSlots() {
    List<String> slots = [];
    for (int hour = 7; hour <= 20; hour++) {
      final String timeSlot =
          '${hour.toString().padLeft(2, '0')}.00 - ${(hour + 1).toString().padLeft(2, '0')}.00';
      slots.add(timeSlot);
    }
    return slots;
  }

  void showTimeSlotDialog(BuildContext context) {
    List<String> timeSlots = generateTimeSlots();
    String? selectedSlot = timeSlots.first;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select a Time Slot"),
          content: DropdownButton<String>(
            value: selectedSlot,
            isExpanded: true,
            onChanged: (String? newValue) {
              selectedSlot = newValue!;
              // Update the UI or perform actions based on the selected time slot
              Navigator.of(context).pop(); // Close the dialog after selection
            },
            items: timeSlots.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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

    // Future<void> findRestaurantsNearby() async {
    //   final String url =
    //       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_center.latitude},${_center.longitude}&radius=6000&type=clinic&key=AIzaSyCeFj39JniJzn8VkiJgLSva0JDSpwtrcX4';

    //   final response = await http.get(Uri.parse(url));

    //   if (response.statusCode == 200) {
    //     final data = json.decode(response.body);

    //     printLongString(data.toString());
    //     print(data);
    //   } else {
    //     print('Failed to load restaurants');
    //   }
    // }

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        child: Stack(
          children: [
            SizedBox(
              width: screenWidth,
              height: 300,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true, // Shows the user's location on the map
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('Thailand'),
                    position: _center,
                  ),
                },
              ),
            ),
            Container(
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 40,
                left: 20,
                right: 20,
                bottom: 40,
              ),
              margin: const EdgeInsets.only(
                top: 190,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isShow = !isShow;
                          print(isShow);
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.teal,
                        size: isShow ? 30 : 80.0,
                      ),
                    ),
                    Text(
                      "Searh Nearby Clinic",
                      style: TextStyle(
                        fontSize: isShow ? 13 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 1),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft),
                        onPressed: () {
                          setState(() {
                            isShow = false;
                          });
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    isShow
                        ? SizedBox(
                            width: screenWidth,
                            height: 500,
                            child: const SearchList(),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
