import 'package:flutter/material.dart';
import 'package:healthcare/db/database_helper.dart';
import 'package:healthcare/theme/app_theme.dart';
import 'package:sqflite/sqflite.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  int? selectedAge;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  List<DropdownMenuItem<int>> ageItems = List.generate(91, (int index) {
    return DropdownMenuItem(
      value: index,
      child: Text('$index'),
    );
  });

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Register Confirmation',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
              'Dear, Mr./Miss/Mrs. ${nameController.text} ${lastNameController.text}, Do you want to register as a new user?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                final success = await _handleRegistration();
                if (!context.mounted) return;
                Navigator.of(context).pop();
                if (success) {
                  Navigator.of(context).pop();
                } else {
                  _showUsernameTakenDialog(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showUsernameTakenDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Username already taken',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
              'This username is already registered. Please choose another one.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Incomplete registration',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text('Please fill out the blank data'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _handleRegistration() async {
    final db = await DatabaseHelper.instance.database;

    Map<String, dynamic> data = {
      "name": nameController.text,
      "lastName": lastNameController.text,
      "age": selectedAge!,
      "username": userNameController.text,
      "password": passwordController.text,
    };

    try {
      await db.insert('Customers', data);
      return true;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        return false;
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            color: AppColors.background,
            padding: const EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            width: screenWidth,
            child: Container(
              width: 400,
              height: 600,
              padding: const EdgeInsets.only(
                top: 24,
                left: 16,
                right: 16,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: userNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                        hintText: 'User Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        hintText: 'First Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        hintText: 'Last Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Age: ",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: selectedAge,
                          onChanged: (newValue) {
                            setState(() {
                              selectedAge = newValue;
                            });
                          },
                          items: ageItems,
                          underline: Container(
                            height: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty &&
                            lastNameController.text.isNotEmpty &&
                            selectedAge != null &&
                            userNameController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          _showRegisterDialog(context);
                        } else {
                          _showErrorDialog(context);
                        }
                      },
                      child: const Text("Register"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        nameController.text = '';
                        lastNameController.text = '';
                        selectedAge = null;
                        userNameController.text = '';
                        passwordController.text = '';
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
                color: AppColors.textPrimary,
                size: 24.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
