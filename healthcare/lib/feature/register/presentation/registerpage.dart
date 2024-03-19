import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        child: const SingleChildScrollView(
          child: Column(),
        ),
      ),
    );
  }
}
