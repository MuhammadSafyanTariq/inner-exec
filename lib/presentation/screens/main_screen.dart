import 'package:flutter/material.dart';
import 'package:innerexec/presentation/widgets/common/custom_bottom_nav_bar.dart';
import 'package:innerexec/presentation/screens/dashboard_screen.dart';
import 'package:innerexec/presentation/screens/job/jobs_screen.dart';
import 'package:innerexec/presentation/screens/resume/resume_audit_screen.dart';
import 'package:innerexec/presentation/screens/add_ons_screen.dart';
import 'package:innerexec/presentation/screens/profile_screen.dart';

/// Main screen with custom bottom navigation
class MainScreen extends StatefulWidget {
  /// Creates a new main screen
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  /// List of screens for each tab
  final List<Widget> _screens = [
    const DashboardScreen(),
    const JobsScreen(),
    const ResumeAuditScreen(),
    const AddOnsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _currentIndex, children: _screens),
    bottomNavigationBar: CustomBottomNavBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    ),
  );
}
