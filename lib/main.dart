import 'package:flutter/material.dart';
import 'core/app_config/app_config.dart';
import 'features/registration_screen/view/registration_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurify Task',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      themeMode: ThemeMode.light,
      home: RegistrationScreen(),
    );
  }
}
