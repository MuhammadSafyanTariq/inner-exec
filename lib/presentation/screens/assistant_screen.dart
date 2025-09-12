import 'package:flutter/material.dart';

/// Assistant screen
class AssistantScreen extends StatelessWidget {
  /// Creates a new assistant screen
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: const Text(
        'Assistant',
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
        'Assistant Content',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          color: Color(0xFF333333),
        ),
      ),
    ),
  );
}
