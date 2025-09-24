import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:innerexec/firebase_options.dart';
import 'package:innerexec/core/constants/app_constants.dart';
import 'package:innerexec/core/theme/app_theme.dart';
import 'package:innerexec/presentation/screens/onboard/onboarding_flow_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innerexec/presentation/screens/main_screen.dart';
import 'package:innerexec/presentation/screens/profile_setup_screen.dart';
import 'package:innerexec/core/services/openai_service.dart';

/// Main entry point of the InnerExec application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize OpenAI service
  OpenAiService.init();
  
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
    home: const _AuthGate(),
  );
}

/// Decides initial screen based on Firebase Auth state and profile setup
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          // Not logged in → show onboarding/login
          return const OnboardingFlowScreen();
        }

        // Logged in → check if profile is set up
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final data = userSnap.data?.data();
            final bool isProfileSetup = (data?['isProfileSetup'] == true);
            return isProfileSetup
                ? const MainScreen()
                : ProfileSetupScreen(fullName: user.displayName ?? '');
          },
        );
      },
    );
  }
}
