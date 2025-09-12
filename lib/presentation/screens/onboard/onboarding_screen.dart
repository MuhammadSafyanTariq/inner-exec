import 'package:flutter/material.dart';
import 'package:innerexec/presentation/widgets/custom_text.dart';

/// Onboarding screen for the first introduction
class OnboardingScreen extends StatelessWidget {
  /// Creates a new onboarding screen
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFFFFFF), // White background
    body: Stack(
      children: [
        // Main Title with absolute positioning
        Positioned(
          top: 70,
          left: 47,
          width: 300,
          height: 108,
          child: const CustomPrimaryText(
            'Create a\nWinning CV',
            textAlign: TextAlign.start,
          ),
        ),

        // Rest of the content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 150), // Space for the positioned title
                // Illustration Section
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background blob
                        Positioned(
                          child: Image.asset(
                            'assets/images/Blob 11.png',
                            width: 248,
                            height: 270,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Document illustration
                        Positioned(
                          child: Image.asset(
                            'assets/images/board_1.png',
                            width: 170,
                            height: 170,
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
                  'Build a professional CV that stands out and wins interviews.',
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
