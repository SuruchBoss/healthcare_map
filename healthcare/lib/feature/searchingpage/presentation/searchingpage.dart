// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthcare/feature/searchingpage/presentation/widget/search_list.dart';
import 'package:location/location.dart';

class SearchingPage extends StatefulWidget {
  final int customerId;

  const SearchingPage({super.key, required this.customerId});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  bool isShow = false;

  GoogleMapController? mapController;
  Set<Marker> markers = {};

  static const LatLng _defaultCenter = LatLng(13.746597, 100.539360);
  LatLng _center = _defaultCenter;
  LatLng? userLocation;
  String? locationError;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    final location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() => locationError =
              'Location service is off. Showing default area.');
        }
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        if (mounted) {
          setState(() => locationError =
              'Location permission denied. Showing default area.');
        }
        return;
      }
    }

    final locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }

    final newCenter = LatLng(locationData.latitude!, locationData.longitude!);
    if (!mounted) return;

    setState(() {
      _center = newCenter;
      userLocation = newCenter;
      locationError = null;
      markers = {
        Marker(
          markerId: const MarkerId('my-location'),
          position: newCenter,
          infoWindow: const InfoWindow(title: 'My Location'),
        ),
      };
    });

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(newCenter, 13.0));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (userLocation != null) {
      mapController!
          .animateCamera(CameraUpdate.newLatLngZoom(userLocation!, 13.0));
    }
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
              height: 400,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true, // Shows the user's location on the map
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
                markers: markers,
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
                top: 250,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isShow = !isShow;
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
                    if (locationError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          locationError!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[800],
                          ),
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
                            child: SearchList(
                              customerId: widget.customerId,
                              userLat: userLocation?.latitude,
                              userLon: userLocation?.longitude,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
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
            )
          ],
        ),
      ),
    );
  }
}
