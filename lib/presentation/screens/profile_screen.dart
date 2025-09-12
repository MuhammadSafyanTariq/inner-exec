import 'package:flutter/material.dart';

/// Profile screen
class ProfileScreen extends StatelessWidget {
  /// Creates a new profile screen
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: const Text(
        'Profile',
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
        'Profile Content',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          color: Color(0xFF333333),
        ),
      ),
    ),
  );
}
