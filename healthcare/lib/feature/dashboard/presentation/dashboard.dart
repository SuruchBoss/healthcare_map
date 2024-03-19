import 'package:flutter/material.dart';
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
                  left: 20,
                  right: 20,
                  bottom: 70,
                ),
                color: Colors.green,
                child: Text(
                  "Hello, ${widget.customer.firstName} ${widget.customer.lastName}",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey[850],
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
