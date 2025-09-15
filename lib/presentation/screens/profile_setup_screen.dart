import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:innerexec/presentation/widgets/custom_text_field.dart';
import 'package:innerexec/presentation/widgets/common/custom_button.dart';
import 'package:innerexec/core/utils/validators.dart';
import 'package:innerexec/core/services/cloudinary_service.dart';
import 'package:innerexec/presentation/screens/main_screen.dart';
import 'package:innerexec/auth/signup_screen.dart';

/// Profile setup screen with pixel-perfect design matching the provided screenshot
class ProfileSetupScreen extends StatefulWidget {
  /// Creates a new profile setup screen
  const ProfileSetupScreen({super.key, this.fullName});

  /// Full name passed from signup screen
  final String? fullName;

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _skillController = TextEditingController();
  final _expertiseController = TextEditingController();
  final _jobTypeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  File? _selectedImage;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill full name from signup screen
    if (widget.fullName != null) {
      _fullNameController.text = widget.fullName!;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _userNameController.dispose();
    _skillController.dispose();
    _expertiseController.dispose();
    _jobTypeController.dispose();
    super.dispose();
  }

  /// Handles the profile setup form submission
  Future<void> _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = _auth.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        String? uploadedImageUrl = _imageUrl;

        // Upload image if selected
        if (_selectedImage != null) {
          uploadedImageUrl = await _cloudinaryService.uploadProfileImage(
            imagePath: _selectedImage!.path,
            userId: user.uid,
          );
        }

        // Ensure username uniqueness using a mapping doc: usernames/{usernameLower}
        final String desiredUsername = _userNameController.text.trim();
        final String usernameKey = desiredUsername.toLowerCase();

        final DocumentReference<Map<String, dynamic>> usernameRef = _firestore
            .collection('usernames')
            .doc(usernameKey);
        final DocumentReference<Map<String, dynamic>> userRef = _firestore
            .collection('users')
            .doc(user.uid);

        // Read current username doc
        final usernameDoc = await usernameRef.get();
        if (usernameDoc.exists && usernameDoc.data()?['uid'] != user.uid) {
          throw Exception(
            'Username already exists. Please choose a different username.',
          );
        }

        // Write both the user profile and the username mapping atomically
        final WriteBatch batch = _firestore.batch();

        batch.set(userRef, {
          'fullName': _fullNameController.text.trim(),
          'email': user.email ?? '',
          'username': desiredUsername,
          'usernameLower': usernameKey,
          'skill': _skillController.text.trim(),
          'expertise': _expertiseController.text.trim(),
          'jobType': _jobTypeController.text.trim(),
          'imageUrl': uploadedImageUrl ?? '',
          'uid': user.uid,
          'isProfileSetup': true,
          'createdAt': FieldValue.serverTimestamp(),
        });

        batch.set(usernameRef, {
          'uid': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        await batch.commit();

        if (mounted) {
          Fluttertoast.showToast(
            msg: 'Profile setup completed successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color(0xFF8A2BE2),
            textColor: Colors.white,
          );

          // Navigate to main screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: e.toString().replaceFirst('Exception: ', ''),
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

  /// Handles avatar edit action
  void _handleAvatarEdit() {
    // Show bottom sheet or dialog for avatar selection
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Change Profile Picture',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption(
                  Icons.camera_alt,
                  'Camera',
                  () => _pickImage(ImageSource.camera),
                ),
                _buildAvatarOption(
                  Icons.photo_library,
                  'Gallery',
                  () => _pickImage(ImageSource.gallery),
                ),
                _buildAvatarOption(
                  Icons.person,
                  'Default',
                  () => _removeImage(),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Picks image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        Navigator.of(context).pop(); // Close bottom sheet
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to pick image: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  /// Removes selected image
  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageUrl = null;
    });
    Navigator.of(context).pop(); // Close bottom sheet
  }

  /// Navigates back to signup screen for editing
  void _navigateToSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  /// Builds an avatar option button
  Widget _buildAvatarOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF8A2BE2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: const Color(0xFF8A2BE2), size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Image.asset('assets/images/back_icon.png', width: 24, height: 24),
        onPressed: () => _navigateToSignup(),
      ),
      title: const Text(
        'Profile Setup',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8A2BE2),
        ),
      ),
      centerTitle: true,
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Description text
            const Text(
              'Complete your profile to unlock job opportunities and continue.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Avatar section
            _buildAvatarSection(),
            const SizedBox(height: 40),
            // Form section
            _buildForm(),
            const SizedBox(height: 40),
            // Save button
            _buildSaveButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
  );

  /// Builds the avatar section with profile picture and edit button
  Widget _buildAvatarSection() => Stack(
    children: [
      // Avatar container
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF8A2BE2).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            // Background pattern with hearts
            Positioned.fill(child: CustomPaint(painter: HeartPatternPainter())),
            // Avatar image placeholder or selected image
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF8A2BE2).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 40,
                        color: Color(0xFF8A2BE2),
                      ),
              ),
            ),
          ],
        ),
      ),
      // Edit button
      Positioned(
        top: 0,
        right: 0,
        child: GestureDetector(
          onTap: _handleAvatarEdit,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF8A2BE2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.edit, size: 16, color: Colors.white),
          ),
        ),
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
        // User Name field
        _buildFieldLabel('User Name'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _userNameController,
          hintText: 'Enter your username here',
          validator: (value) => Validators.validateRequired(value, 'User Name'),
          width: double.infinity,
          height: 54,
          borderRadius: 8,
          borderWidth: 1,
          fillColor: const Color(0xFFF5F5F5),
          borderColor: const Color(0xFFE1E1E1),
        ),
        const SizedBox(height: 20),
        // Skill field
        _buildFieldLabel('Skill'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _skillController,
          hintText: 'Enter your skill here',
          validator: (value) => Validators.validateRequired(value, 'Skill'),
          width: double.infinity,
          height: 54,
          borderRadius: 8,
          borderWidth: 1,
          fillColor: const Color(0xFFF5F5F5),
          borderColor: const Color(0xFFE1E1E1),
        ),
        const SizedBox(height: 20),
        // Expertise field
        _buildFieldLabel('Expertise'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _expertiseController,
          hintText: 'Enter your expertise here',
          validator: (value) => Validators.validateRequired(value, 'Expertise'),
          width: double.infinity,
          height: 54,
          borderRadius: 8,
          borderWidth: 1,
          fillColor: const Color(0xFFF5F5F5),
          borderColor: const Color(0xFFE1E1E1),
        ),
        const SizedBox(height: 20),
        // Job Type field
        _buildFieldLabel('Job Type'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _jobTypeController,
          hintText: 'Enter your job type here',
          validator: (value) => Validators.validateRequired(value, 'Job Type'),
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

  /// Builds the save button
  Widget _buildSaveButton() => CustomButton(
    text: 'Save',
    onPressed: _isLoading ? null : _handleSave,
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
}

/// Custom painter for heart pattern background
class HeartPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw small hearts scattered around
    final heartSize = 8.0;
    final positions = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.3, size.height * 0.7),
      Offset(size.width * 0.7, size.height * 0.8),
      Offset(size.width * 0.1, size.height * 0.6),
      Offset(size.width * 0.9, size.height * 0.4),
    ];

    for (final position in positions) {
      _drawHeart(canvas, position, heartSize, paint);
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final width = size;
    final height = size * 0.9;

    path.moveTo(center.dx, center.dy + height * 0.3);
    path.cubicTo(
      center.dx - width * 0.5,
      center.dy - height * 0.3,
      center.dx - width * 0.5,
      center.dy + height * 0.1,
      center.dx,
      center.dy + height * 0.1,
    );
    path.cubicTo(
      center.dx + width * 0.5,
      center.dy + height * 0.1,
      center.dx + width * 0.5,
      center.dy - height * 0.3,
      center.dx,
      center.dy + height * 0.3,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
