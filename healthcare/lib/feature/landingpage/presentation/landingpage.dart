// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/feature/dashboard/presentation/dashboard.dart';
import 'package:healthcare/feature/register/presentation/registerpage.dart';
import 'package:healthcare/model/customermodel.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  String error = '';
  String documentId = '';

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  Future<DocumentSnapshot?> findUserByUsername() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Customers")
        .where("username", isEqualTo: userNameController.text)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      documentId = userDoc.id;
      return querySnapshot.docs.first;
    }

    return null;
  }

  void _handleLogin() async {
    final userDoc = await findUserByUsername();

    if (userDoc != null) {
      final userData = userDoc.data() as Map<String, dynamic>;
      final storedPassword = userData['password'] as String;
      final name = userData['name'] as String;
      final lastName = userData['lastName'] as String;

      CustomerModel model = CustomerModel(
        id: documentId,
        firstName: name,
        lastName: lastName,
      );

      if (storedPassword == passwordController.text) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoard(
              customer: model,
            ),
          ),
        );
        error = '';
      }
    }

    error = 'Username of Password is incorrect.';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget _logo() {
      return Image.asset(
        "assets/logo.png",
        fit: BoxFit.cover,
        width: 300,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: screenWidth,
        color: Colors.white,
        padding: const EdgeInsets.only(
          top: 50,
          left: 40,
          right: 40,
          bottom: 30,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _logo(),
              const SizedBox(height: 20),
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: screenWidth,
                child: TextField(
                  controller: userNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'user name',
                    hintText: 'admin',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: screenWidth,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'password',
                    hintText: 'admin',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => _handleLogin(),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        userNameController.text = '';
                        passwordController.text = '';
                        error = '';
                      });
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: const Text(
                      "Clear",
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 60,
                thickness: 1,
                color: Colors.blue[600],
              ),
              Row(
                children: [
                  const Text("Does not have account? "),
                  TextButton(
                    onPressed: () => _goToRegister(),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: const Text(
                      "Register ",
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const Text("Here")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
