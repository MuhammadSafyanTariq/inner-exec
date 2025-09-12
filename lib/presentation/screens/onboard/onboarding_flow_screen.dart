import 'package:flutter/material.dart';
import 'package:innerexec/presentation/screens/onboard/onboarding_screen.dart';
import 'package:innerexec/presentation/screens/onboard/onboarding_screen_2.dart';
import 'package:innerexec/presentation/screens/onboard/onboarding_screen_3.dart';
import 'package:innerexec/presentation/screens/onboard/onboarding_screen_4.dart';
import 'package:innerexec/presentation/widgets/page_indicator.dart';
import 'package:innerexec/auth/login_screen.dart';

/// Onboarding flow screen that manages navigation between all onboarding screens
class OnboardingFlowScreen extends StatefulWidget {
  /// Creates a new onboarding flow screen
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 4;

  /// List of all onboarding screens
  final List<Widget> _onboardingScreens = [
    const OnboardingScreen(),
    const OnboardingScreen2(),
    const OnboardingScreen3(),
    const OnboardingScreen4(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Handles page changes when user swipes or taps dots
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // Navigate to login screen after the last page
    if (page == _totalPages - 1) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      });
    }
  }

  /// Navigates to a specific page when user taps on a dot
  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          // Page view with onboarding screens
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                return _onboardingScreens[index];
              },
            ),
          ),
          // Page indicator dots at the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: PageIndicator(
              currentPage: _currentPage,
              totalPages: _totalPages,
              onPageTap: _goToPage,
              activeColor: const Color(0xFF8B51FE),
              inactiveColor: const Color(0xFF8B51FE).withOpacity(0.3),
              dotSize: 8,
              spacing: 8,
            ),
          ),
        ],
      ),
    ),
  );
}
