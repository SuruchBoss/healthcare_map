import 'package:flutter/material.dart';
import 'package:healthcare/feature/landingpage/presentation/landingpage.dart';
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
          child: Column(
            children: [
              Container(
                  width: screenWidth,
                  padding: const EdgeInsets.only(
                    top: 90,
                    left: 10,
                    right: 10,
                    bottom: 70,
                  ),
                  color: Colors.green,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                          "Hello, ${widget.customer.firstName} ${widget.customer.lastName}",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.grey[850],
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
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
                onPressed: null,
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
            ],
          ),
        ),
      ),
    );
  }
}
