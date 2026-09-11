// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:healthcare/db/database_helper.dart';
import 'package:healthcare/feature/dashboard/presentation/dashboard.dart';
import 'package:healthcare/feature/register/presentation/registerpage.dart';
import 'package:healthcare/model/customermodel.dart';
import 'package:healthcare/theme/app_theme.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  String error = '';

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  Future<Map<String, Object?>?> findUserByUsername() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'Customers',
      where: 'username = ?',
      whereArgs: [userNameController.text],
      limit: 1,
    );

    if (rows.isNotEmpty) {
      return rows.first;
    }

    return null;
  }

  void _handleLogin() async {
    final userRow = await findUserByUsername();

    if (userRow != null) {
      final storedPassword = userRow['password'] as String;

      if (storedPassword == passwordController.text) {
        CustomerModel model = CustomerModel(
          id: userRow['id'].toString(),
          firstName: userRow['name'] as String,
          lastName: userRow['lastName'] as String,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoard(
              customer: model,
            ),
          ),
        );
        return;
      }
    }

    setState(() {
      error = 'Username or password is incorrect.';
    });
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
        color: AppColors.background,
        padding: const EdgeInsets.only(
          top: 56,
          left: 24,
          right: 24,
          bottom: 32,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _logo(),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: screenWidth,
                child: TextField(
                  controller: userNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'user name',
                    hintText: 'admin',
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: screenWidth,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'password',
                    hintText: 'admin',
                  ),
                ),
              ),
              if (error.isNotEmpty) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    error,
                    style: const TextStyle(color: AppColors.error, fontSize: 13),
                  ),
                ),
              ],
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: () => _handleLogin(),
                  child: const Text("Login"),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    userNameController.text = '';
                    passwordController.text = '';
                    error = '';
                  });
                },
                child: const Text(
                  "Clear",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Does not have account? ",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => _goToRegister(),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Text(
                    " Here",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
