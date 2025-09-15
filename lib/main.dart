import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:innerexec/firebase_options.dart';
import 'package:innerexec/core/constants/app_constants.dart';
import 'package:innerexec/core/theme/app_theme.dart';
import 'package:innerexec/presentation/screens/onboard/onboarding_flow_screen.dart';

/// Main entry point of the InnerExec application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const InnerExecApp());
}

/// Root application widget
class InnerExecApp extends StatelessWidget {
  /// Creates a new InnerExecApp instance
  const InnerExecApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: AppConstants.appName,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: ThemeMode.system,
    home: const OnboardingFlowScreen(),
  );
}
