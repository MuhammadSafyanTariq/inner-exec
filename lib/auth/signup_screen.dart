import 'package:flutter/material.dart';
import 'package:innerexec/presentation/widgets/custom_text_field.dart';
import 'package:innerexec/presentation/widgets/common/custom_button.dart';
import 'package:innerexec/auth/login_screen.dart';
import 'package:innerexec/core/utils/validators.dart';

/// Sign-up screen with pixel-perfect design matching the provided screenshot
class SignupScreen extends StatefulWidget {
  /// Creates a new sign-up screen
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles the sign-up form submission
  Future<void> _handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navigate to home or next screen
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Color(0xFF8A2BE2),
          ),
        );
      }
    }
  }

  /// Navigates to the login screen
  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF8A2BE2), // Purple background
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // Header section
              _buildHeader(),
              const SizedBox(height: 120),
              // Form section
              _buildForm(),
              const SizedBox(height: 30),
              // Sign up button
              _buildSignUpButton(),
              const SizedBox(height: 120),
              // Login link
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    ),
  );

  /// Builds the header section with title and subtitle
  Widget _buildHeader() => Column(
    children: [
      // Title
      const Text(
        'Create your account',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8A2BE2),
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12),
      // Subtitle
      const Text(
        'Create your account and take the first\nstep toward your dream career.',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: Color(0xFF000000),
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );

  /// Builds the form with input fields
  Widget _buildForm() => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name field
        _buildFieldLabel('Full Name'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _fullNameController,
          hintText: 'Enter your name here',
          validator: (value) => Validators.validateRequired(value, 'Full Name'),
          width: double.infinity,
          height: 54,
          borderRadius: 8,
          borderWidth: 1,
          fillColor: const Color(0xFFF5F5F5),
          borderColor: const Color(0xFFE1E1E1),
        ),
        const SizedBox(height: 20),
        // Email field
        _buildFieldLabel('Email'),
        const SizedBox(height: 8),
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
        const SizedBox(height: 20),
        // Password field
        _buildFieldLabel('Password'),
        const SizedBox(height: 8),
        CustomPasswordTextField(
          controller: _passwordController,
          hintText: 'Enter your password here',
          validator: Validators.validatePassword,
          width: double.infinity,
          height: 54,
          borderRadius: 8,
          borderWidth: 1,
          fillColor: const Color(0xFFF5F5F5),
          borderColor: const Color(0xFFE1E1E1),
        ),
      ],
    ),
  );

  /// Builds a field label
  Widget _buildFieldLabel(String label) => Text(
    label,
    style: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF000000),
    ),
  );

  /// Builds the sign-up button
  Widget _buildSignUpButton() => CustomButton(
    text: 'Sign Up',
    onPressed: _isLoading ? null : _handleSignUp,
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

  /// Builds the login link under the signup button
  Widget _buildLoginLink() => Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already a member? ',
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
