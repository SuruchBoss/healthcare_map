// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:healthcare/feature/register/presentation/registerpage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
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
                  keyboardType: TextInputType.emailAddress,
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
              const Text(
                '',
                style: TextStyle(color: Colors.red),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => null,
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
                    onPressed: () => null,
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
