import 'package:flutter/material.dart';
import 'package:p21_api_app/random_contact_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue.shade900),
      title: 'API APP',
      home: RandomContactPage(),
    );
  }
}
