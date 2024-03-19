import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
              color: Colors.blue,
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
              onPressed: () {
                _handleRegistration();
                Navigator.of(context).pop();
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
              color: Colors.blue,
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

  void _handleRegistration() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> data = {
      "name": nameController.text,
      "lastName": lastNameController.text,
      "age": selectedAge!,
      "username": userNameController.text,
      "password": passwordController.text,
    };

    await firestore.collection("Customers").add(data);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.white,
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
                top: 20,
                left: 10,
                right: 10,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent, width: 3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: userNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                        hintText: 'User Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                        hintText: 'First Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                        hintText: 'Last Name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Age: ",
                        style: TextStyle(
                          fontSize: 18,
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
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 90),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
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
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft),
                        child: const Text(
                          "Register",
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
                            nameController.text = '';
                            lastNameController.text = '';
                            selectedAge = null;
                            userNameController.text = '';
                            passwordController.text = '';
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
                color: Colors.black,
                size: 30.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
