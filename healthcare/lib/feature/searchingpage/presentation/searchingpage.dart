// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:healthcare/feature/searchingpage/presentation/widget/search_list.dart';
import 'package:healthcare/theme/app_theme.dart';
import 'package:location/location.dart';

class SearchingPage extends StatefulWidget {
  final int customerId;

  const SearchingPage({super.key, required this.customerId});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  bool isShow = true;

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
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              margin: const EdgeInsets.only(
                top: 250,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primarySoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Search Nearby Clinic",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isShow = !isShow;
                            });
                          },
                          icon: Icon(
                            isShow
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (locationError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          locationError!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
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
            )
          ],
        ),
      ),
    );
  }
}
