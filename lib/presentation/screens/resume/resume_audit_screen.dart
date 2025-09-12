import 'package:flutter/material.dart';
import 'package:innerexec/presentation/widgets/common/custom_button.dart';
import 'package:innerexec/presentation/screens/resume/ai_resume_screen.dart';

/// Resume Audit screen with pixel-perfect design matching the provided image
class ResumeAuditScreen extends StatefulWidget {
  /// Creates a new resume audit screen
  const ResumeAuditScreen({super.key});

  @override
  State<ResumeAuditScreen> createState() => _ResumeAuditScreenState();
}

class _ResumeAuditScreenState extends State<ResumeAuditScreen> {
  /// Navigates back to the previous screen
  void _navigateBack() {
    Navigator.of(context).pop();
  }

  /// Handles the book now button press
  void _handleBookNow() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AiResumeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    print('ResumeAuditScreen build called'); // Debug print
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header with back button and title
              _buildHeader(),
              const SizedBox(height: 20),
              // Hero image
              _buildHeroImage(),
              const SizedBox(height: 20),
              // Service description
              _buildServiceDescription(),
              const SizedBox(height: 24),
              // What's included section
              _buildWhatsIncluded(),
              const SizedBox(height: 24),
              // Book now button
              _buildBookNowButton(),
              const SizedBox(height: 24),
              // Reviews section
              _buildReviewsSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

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
        'Resume Audit',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
      ),
    ],
  );

  /// Builds the hero image
  Widget _buildHeroImage() => Container(
    width: double.infinity,
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: const Color(0xFFF5F5F5),
      border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
    ),
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 64, color: Color(0xFF8A2BE2)),
          SizedBox(height: 8),
          Text(
            'Resume Preview',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8A2BE2),
            ),
          ),
        ],
      ),
    ),
  );

  /// Builds the service description
  Widget _buildServiceDescription() => const Text(
    'Get a professional review of your resume to ensure it highlights your strengths and aligns with industry standards.',
    style: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(0xFF000000),
      height: 1.4,
    ),
  );

  /// Builds the What's Included section
  Widget _buildWhatsIncluded() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'What\'s Included',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
      ),
      const SizedBox(height: 12),
      _buildBulletPoint('Detailed feedback on structure and content'),
      _buildBulletPoint('Suggestions for improvement and optimization'),
      _buildBulletPoint('Guidance on tailoring your resume for specific roles'),
      _buildBulletPoint('Actionable feedback for improvement'),
      _buildBulletPoint('Updated, ATS-friendly formatting suggestions'),
    ],
  );

  /// Builds a bullet point item
  Widget _buildBulletPoint(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 8, right: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF8A2BE2),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF000000),
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );

  /// Builds the book now button
  Widget _buildBookNowButton() => CustomButton(
    text: 'Book Now - \$99',
    onPressed: _handleBookNow,
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

  /// Builds the reviews section
  Widget _buildReviewsSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF8A2BE2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 16, color: Color(0xFF8A2BE2)),
                SizedBox(width: 4),
                Text(
                  '4.8 / 5',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A2BE2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      _buildReviewItem(
        'Jeanette Gottlieb',
        'The feedback was so detailed! My resume looks cleaner and I landed 3 interviews in a week.',
      ),
      const SizedBox(height: 12),
      _buildReviewItem(
        'Jeanette Gottlieb',
        'The feedback was so detailed! My resume looks cleaner and I landed 3 interviews in a week.',
      ),
    ],
  );

  /// Builds a review item
  Widget _buildReviewItem(String name, String review) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FA),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile picture placeholder
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF8A2BE2).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: Color(0xFF8A2BE2), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                review,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF000000),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
