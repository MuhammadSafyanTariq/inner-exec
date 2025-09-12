import 'package:flutter/material.dart';
import 'package:innerexec/presentation/widgets/custom_text_field.dart';
import 'package:innerexec/presentation/widgets/common/custom_button.dart';
import 'package:innerexec/core/utils/validators.dart';
import 'package:innerexec/auth/login_screen.dart';

/// Forgot password screen with pixel-perfect design matching the provided screenshot
class ForgotPasswordScreen extends StatefulWidget {
  /// Creates a new forgot password screen
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Handles the reset password form submission
  Future<void> _handleResetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset link sent to your email!'),
            backgroundColor: Color(0xFF8A2BE2),
          ),
        );

        // Navigate back to login screen
        Navigator.of(context).pop();
      }
    }
  }

  /// Navigates back to the login screen
  void _navigateBack() {
    Navigator.of(context).pop();
  }

  /// Navigates to the login screen
  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header with back button and title
              _buildHeader(),
              const SizedBox(height: 40),
              // Instructions text
              _buildInstructions(),
              const SizedBox(height: 30),
              // Email field
              _buildEmailField(),
              const SizedBox(height: 30),
              // Reset password button
              _buildResetButton(),
              const Spacer(),
              // Footer with login link
              _buildFooter(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
  );

  /// Builds the header with back button and title
  Widget _buildHeader() => Row(
    children: [
      // Back button
      GestureDetector(
        onTap: _navigateBack,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF8A2BE2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.keyboard_double_arrow_left,
            color: Color(0xFF8A2BE2),
            size: 24,
          ),
        ),
      ),
      const SizedBox(width: 16),
      // Title
      const Text(
        'Forgot Password',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8A2BE2),
        ),
      ),
    ],
  );

  /// Builds the instructions text
  Widget _buildInstructions() => const Center(
    child: Text(
      'Enter the email address associated with \nyour account, and we\'ll send you a link to \nreset your password.',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 1.5, // 100% line-height
        letterSpacing: 0.0, // 0% letter-spacing
        color: Color(0xFF000000),
      ),
      textAlign: TextAlign.center,
    ),
  );

  /// Builds the email input field
  Widget _buildEmailField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Email label
      const Text(
        'Email',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF000000),
        ),
      ),
      const SizedBox(height: 8),
      // Email input field
      CustomTextField(
        controller: _emailController,
        hintText: 'Enter your email here',
        keyboardType: TextInputType.emailAddress,
        validator: Validators.validateEmail,
        width: double.infinity,
        height: 54,
        borderRadius: 8,
        borderWidth: 1,
        fillColor: const Color(0xFFF5F5F5),
        borderColor: const Color(0xFFE1E1E1),
      ),
    ],
  );

  /// Builds the reset password button
  Widget _buildResetButton() => CustomButton(
    text: 'Reset Password',
    onPressed: _isLoading ? null : _handleResetPassword,
    isLoading: _isLoading,
    backgroundColor: const Color(0xFF8A2BE2),
    foregroundColor: Colors.white,
    height: 56,
    textStyle: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  /// Builds the footer with login link
  Widget _buildFooter() => Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Remember Password? ',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF000000),
          ),
        ),
        GestureDetector(
          onTap: _navigateToLogin,
          child: const Text(
            'Log In',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8A2BE2),
            ),
          ),
        ),
      ],
    ),
  );
}
