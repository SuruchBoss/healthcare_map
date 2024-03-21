import 'package:flutter/material.dart';
import 'package:healthcare/feature/dashboard/presentation/widget/clinic_history.dart';
import 'package:healthcare/feature/dashboard/presentation/widget/clinic_promotion.dart';
import 'package:healthcare/feature/dashboard/presentation/widget/upcomingevent.dart';
import 'package:healthcare/feature/landingpage/presentation/landingpage.dart';
import 'package:healthcare/feature/mybooking/presentation/mybookingpage.dart';
import 'package:healthcare/feature/searchingpage/presentation/searchingpage.dart';
import 'package:healthcare/model/customermodel.dart';

class DashBoard extends StatefulWidget {
  final CustomerModel customer;
  const DashBoard({
    super.key,
    required this.customer,
  });

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  void _logOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingPage(),
      ),
    );
  }

  void _goToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchingPage(),
      ),
    );
  }

  void _goToMyBookingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyBookingPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                  width: screenWidth,
                  padding: const EdgeInsets.only(
                    top: 70,
                    left: 15,
                    right: 10,
                    bottom: 20,
                  ),
                  color: Colors.green,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello, ${widget.customer.firstName} ${widget.customer.lastName}",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.grey[850],
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.star_border,
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                  Text(
                                    "Member lever:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 1),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        alignment: Alignment.centerLeft),
                                    onPressed: () => (),
                                    child: Text(
                                      "Silver",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () => _logOut(),
                            icon: Icon(
                              Icons.logout_outlined,
                              color: Colors.grey[900],
                              size: 30.0,
                            ),
                          ))
                    ],
                  )),
              const SizedBox(height: 40),
              TextButton(
                onPressed: _goToSearchPage,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 1),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft),
                child: Container(
                  width: screenWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      image: const AssetImage("assets/search_bg.png"),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    "Clinic Near You",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.teal[900],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _goToMyBookingPage,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 1),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft),
                child: Container(
                  width: screenWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      image: const AssetImage("assets/booking_bg.png"),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Text(
                    "My Booking",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.teal[900],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Upcoming appointment",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const UpcomingEventsWidget(),
              const SizedBox(height: 30),
              Text(
                "Previous clinic",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: screenWidth,
                height: 100,
                child: const ClinicHistory(),
              ),
              const SizedBox(height: 20),
              Divider(
                height: 30,
                thickness: 1,
                indent: 30,
                endIndent: 30,
                color: Colors.red[600],
              ),
              const SizedBox(height: 10),
              Text(
                "Promotion",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: screenWidth,
                height: 400,
                child: const ClinicPromotion(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
