import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:innerexec/presentation/widgets/custom_text_field.dart';
import 'package:innerexec/presentation/widgets/common/custom_button.dart';
import 'package:innerexec/core/utils/validators.dart';
import 'package:innerexec/auth/signup_screen.dart';
import 'package:innerexec/auth/forgot_password_screen.dart';
import 'package:innerexec/presentation/screens/main_screen.dart';
import 'package:innerexec/presentation/screens/profile_setup_screen.dart';

/// Pixel-perfect login screen based on design specifications
class LoginScreen extends StatefulWidget {
  /// Creates a new login screen
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles the login form submission
  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Sign in with email and password
        final UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        final User? user = cred.user;

        // Default: go to profile setup if user doc missing or flag not set
        bool goToHome = false;
        if (user != null) {
          try {
            final doc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
            if (doc.exists) {
              final data = doc.data();
              goToHome = (data?['isProfileSetup'] == true);
            }
          } catch (_) {
            goToHome = false;
          }
        }

        if (mounted) {
          Fluttertoast.showToast(
            msg: 'Login successful!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color(0xFF8A2BE2),
            textColor: Colors.white,
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => goToHome
                  ? const MainScreen()
                  : ProfileSetupScreen(fullName: user?.displayName ?? ''),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Login failed. Please try again.';

        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email address.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password. Please try again.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email address.';
            break;
          case 'user-disabled':
            errorMessage = 'This account has been disabled.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many failed attempts. Please try again later.';
            break;
        }

        if (mounted) {
          Fluttertoast.showToast(
            msg: errorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: 'An unexpected error occurred. Please try again.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  /// Navigates to the signup screen
  void _navigateToSignup() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  /// Navigates to the forgot password screen
  void _navigateToForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF8A2BE2), // Purple background
    resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),

                // Header Section
                const Center(
                  child: Column(
                    children: [
                      // Welcome Back text - Purple
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Color(0xFF8A2BE2), // Purple color
                        ),
                      ),
                      SizedBox(height: 8),
                      // Description text - Black
                      Text(
                        'Find jobs, connect with employers, and build your perfect CV.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF000000), // Black color
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120),

                // Email Field
                const Text(
                  'Email',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Enter your email here',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validateEmail,
                  width: double.infinity,
                  height: 54,
                  borderRadius: 8,
                  borderWidth: 1,
                  borderColor: const Color(0xFFE1E1E1),
                  fillColor: const Color(0xFFF5F5F5),
                ),

                const SizedBox(height: 20),

                // Password Field
                const Text(
                  'Password',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                CustomPasswordTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password here',
                  validator: Validators.validatePassword,
                  width: double.infinity,
                  height: 54,
                  borderRadius: 8,
                  borderWidth: 1,
                  borderColor: const Color(0xFFE1E1E1),
                  fillColor: const Color(0xFFF5F5F5),
                ),
                const SizedBox(height: 8),
                // Forgot Password button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToForgotPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        height: 1.0, // 100% line-height
                        letterSpacing: 0.0, // 0% letter-spacing
                        color: Color(0xFF000000), // Black color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Log In Button - Purple background
                CustomButton(
                  text: 'Log In',
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  height: 50,
                  backgroundColor: const Color(0xFF8A2BE2), // Purple color
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const Spacer(),

                // Footer - Sign Up text
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF000000), // Black color
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToSignup,
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF8A2BE2), // Purple color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
