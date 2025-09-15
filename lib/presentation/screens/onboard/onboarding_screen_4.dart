import 'package:flutter/material.dart';
import 'package:innerexec/presentation/widgets/custom_text.dart';

/// Fourth onboarding screen for career growth introduction
class OnboardingScreen4 extends StatelessWidget {
  /// Creates a new fourth onboarding screen
  const OnboardingScreen4({super.key});

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
              'Grow Your\nCareer',
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
                        'assets/images/Blob 14.png',
                        width: 240.8,
                        height: 197.26,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Career growth chart illustration
                    Positioned(
                      child: Image.asset(
                        'assets/images/board_4.png',
                        width: 133,
                        height: 129,
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
              'Take control of your future with tools designed for your success.',
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    ),
  );
}
