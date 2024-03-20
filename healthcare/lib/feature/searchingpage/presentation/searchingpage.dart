// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeigh = MediaQuery.of(context).size.height;

    GoogleMapController? mapController;
    Set<Marker> markers = Set();

    const LatLng _center = LatLng(13.746597, 100.539360);

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

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: 300,
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true, // Shows the user's location on the map
              myLocationButtonEnabled: false,
              initialCameraPosition: const CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: {
                const Marker(
                  markerId: MarkerId('Sydney'),
                  position: _center,
                ),
              },
            ),
            Container(
              width: screenWidth,
              height: screenHeigh,
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
                top: 270,
              ),
              child: Column(
                children: [],
              ),
            )
          ],
        ),
      ),
    );
  }
}
