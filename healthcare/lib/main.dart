import 'package:flutter/material.dart';
import 'package:healthcare/feature/landingpage/presentation/landingpage.dart';
import 'package:healthcare/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme,
      home: const LandingPage(),
    );
  }
}
