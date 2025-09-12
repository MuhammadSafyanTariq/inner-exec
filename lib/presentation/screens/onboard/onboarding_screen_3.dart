import 'package:flutter/material.dart';
import 'package:innerexec/presentation/widgets/custom_text.dart';

/// Third onboarding screen for employer connection introduction
class OnboardingScreen3 extends StatelessWidget {
  /// Creates a new third onboarding screen
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFFFFFF), // White background
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),

            // Main Title
            const CustomPrimaryText(
              'Connect with\nEmployers',
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 20),

            // Illustration Section
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background blob
                    Positioned(
                      child: Image.asset(
                        'assets/images/Blob 13.png',
                        width: 238.50,
                        height: 242.50,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Person with laptop illustration
                    Positioned(
                      child: Image.asset(
                        'assets/images/board_3.png',
                        width: 159,
                        height: 159,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Description Text
            const CustomSecondaryText(
              'Connect with the right employers and get noticed for your talent.',
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    ),
  );
}
