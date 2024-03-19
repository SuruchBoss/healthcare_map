import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          top: 50,
          left: 40,
          right: 40,
          bottom: 30,
        ),
        width: screenWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                onPressed: () async {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                  Map<String, dynamic> data = {
                    "name": "Suruch",
                    "age": 20,
                    "subject": "Math",
                  };

                  await firestore.collection("Students").add(data);
                },
                child: Text("Click"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
