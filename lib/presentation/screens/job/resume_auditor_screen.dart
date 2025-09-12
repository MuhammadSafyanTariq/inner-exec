import 'package:flutter/material.dart';

/// Resume Auditor screen with pixel-perfect design
class ResumeAuditorScreen extends StatefulWidget {
  /// Creates a new resume auditor screen
  const ResumeAuditorScreen({super.key});

  @override
  State<ResumeAuditorScreen> createState() => _ResumeAuditorScreenState();
}

class _ResumeAuditorScreenState extends State<ResumeAuditorScreen> {
  bool _isBasicSelected = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 20),
            // Hero Image
            _buildHeroImage(),
            const SizedBox(height: 24),
            // Service Description
            _buildServiceDescription(),
            const SizedBox(height: 32),
            // What's Included Section
            _buildWhatsIncludedSection(),
            const SizedBox(height: 32),
            // Choose your Plan Section
            _buildChoosePlanSection(),
            const SizedBox(height: 24),
            // Hire Button
            _buildHireButton(),
            const SizedBox(height: 32),
            // Reviews Section
            _buildReviewsSection(),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    ),
  );

  /// Builds the header with back button and title
  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF8A2BE2),
              size: 20,
            ),
          ),
        ),
        const Spacer(),
        const Text(
          'Resume Auditor',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const Spacer(),
        const SizedBox(width: 40), // Balance the back button
      ],
    ),
  );

  /// Builds the hero image
  Widget _buildHeroImage() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: const DecorationImage(
        image: AssetImage('assets/images/resume_hero.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.1),
      ),
      child: const Center(
        child: Icon(Icons.description, size: 80, color: Color(0xFF8A2BE2)),
      ),
    ),
  );

  /// Builds the service description
  Widget _buildServiceDescription() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      'Get a professional review of your resume to ensure it highlights your strengths and aligns with industry standards.',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.grey[700],
        height: 1.5,
      ),
    ),
  );

  /// Builds the What's Included section
  Widget _buildWhatsIncludedSection() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What's Included",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 16),
        _buildIncludedItem('Detailed feedback on structure and content'),
        const SizedBox(height: 12),
        _buildIncludedItem('Suggestions for improvement and optimization'),
        const SizedBox(height: 12),
        _buildIncludedItem(
          'Guidance on tailoring your resume for specific roles',
        ),
        const SizedBox(height: 12),
        _buildIncludedItem('Actionable feedback for improvement'),
        const SizedBox(height: 12),
        _buildIncludedItem('Updated, ATS-friendly formatting suggestions'),
      ],
    ),
  );

  /// Builds individual included item
  Widget _buildIncludedItem(String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(top: 6),
        decoration: const BoxDecoration(
          color: Color(0xFF8A2BE2),
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ),
    ],
  );

  /// Builds the Choose your Plan section
  Widget _buildChoosePlanSection() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose your Plan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildPlanCard(
                'Basic Audit',
                ['2-3 key improvement', '1 Suggestion', '2 Changes'],
                '10\$',
                true,
                () => setState(() => _isBasicSelected = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPlanCard(
                'Standard Audit',
                ['5-7 actionable improvement', '3 Suggestions', '5 Changes'],
                '20\$',
                false,
                () => setState(() => _isBasicSelected = false),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  /// Builds individual plan card
  Widget _buildPlanCard(
    String title,
    List<String> features,
    String price,
    bool isSelected,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF8A2BE2).withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF8A2BE2) : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 12),
          ...features
              .map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF000000),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 12),
          Text(
            'Price: $price',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    ),
  );

  /// Builds the hire button
  Widget _buildHireButton() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    width: double.infinity,
    height: 50,
    decoration: BoxDecoration(
      color: const Color(0xFF8A2BE2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Handle hire action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hired - ${_isBasicSelected ? '\$10' : '\$20'}'),
              backgroundColor: const Color(0xFF8A2BE2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: const Center(
          child: Text(
            'Hire - \$10',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );

  /// Builds the reviews section
  Widget _buildReviewsSection() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
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
            const Icon(Icons.star, color: Color(0xFF8A2BE2), size: 20),
            const SizedBox(width: 4),
            const Text(
              '(4.8 / 5)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000),
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
    ),
  );

  /// Builds individual review item
  Widget _buildReviewItem(String name, String review) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF8A2BE2).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
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
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
