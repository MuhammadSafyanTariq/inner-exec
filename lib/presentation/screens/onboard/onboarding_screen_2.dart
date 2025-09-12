import 'package:flutter/material.dart';
import 'package:innerexec/presentation/widgets/custom_text.dart';

/// Second onboarding screen for job search introduction
class OnboardingScreen2 extends StatelessWidget {
  /// Creates a new second onboarding screen
  const OnboardingScreen2({super.key});

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
              'Find Your\nPerfect Job',
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
                        'assets/images/Blob 12.png',
                        width: 189,
                        height: 280,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Briefcase and magnifying glass illustration
                    Positioned(
                      child: Image.asset(
                        'assets/images/board_2.png',
                        width: 145.83,
                        height: 145.83,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Description Text
            const CustomSecondaryText(
              'Discover thousands of opportunities that match your skills and goals.',
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    ),
  );
}
