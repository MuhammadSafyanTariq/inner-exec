import 'package:flutter/material.dart';

/// Add-ons screen
class AddOnsScreen extends StatelessWidget {
  /// Creates a new add-ons screen
  const AddOnsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: const Text(
        'Add-Ons',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Color(0xFF8A2BE2),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    body: const Center(
      child: Text(
        'Add-Ons Content',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          color: Color(0xFF333333),
        ),
      ),
    ),
  );
}
