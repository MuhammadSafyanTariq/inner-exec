import 'package:flutter/material.dart';

/// Dashboard screen with pixel-perfect design
class DashboardScreen extends StatelessWidget {
  /// Creates a new dashboard screen
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header Section
                  _buildHeader(),
                  const SizedBox(height: 24),
                  // Ask AI Card
                  _buildAskAICard(),
                  const SizedBox(height: 20),
                  // Job Application Dashboard Card
                  _buildJobApplicationCard(),
                  const SizedBox(height: 24),
                  // Affirmation & Tips Section
                  _buildAffirmationTipsSection(),
                  const SizedBox(height: 24),
                  // Recent Jobs Section
                  _buildRecentJobsSection(),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          );
        },
      ),
    ),
  );

  /// Builds the header with logo, greeting, and profile picture
  Widget _buildHeader() => Row(
    children: [
      // Logo
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'INNER',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                Container(
                  height: 20,
                  width: 1,
                  color: const Color(0xFF000000),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                const Text(
                  'EXEC',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A2BE2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.wb_sunny, size: 16, color: Color(0xFF8A2BE2)),
                const SizedBox(width: 4),
                const Flexible(
                  child: Text(
                    'Good Morning, Mark',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('😊', style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'I found best jobs curated for you!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      const SizedBox(width: 12),
      // Profile Picture
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF8A2BE2).withOpacity(0.1),
          border: Border.all(color: const Color(0xFF8A2BE2), width: 2),
        ),
        child: const Icon(Icons.person, color: Color(0xFF8A2BE2), size: 24),
      ),
    ],
  );

  /// Builds the Ask AI card
  Widget _buildAskAICard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        // AI Icon
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B9D), Color(0xFF4ECDC4), Color(0xFF8A2BE2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.psychology, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        // Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ask AI',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ready to help you jobs with one tap',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
        // Arrow Button
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFF8A2BE2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
        ),
      ],
    ),
  );

  /// Builds the Job Application Dashboard card
  Widget _buildJobApplicationCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Expanded(
              child: Text(
                'Job Application Dashboard',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF8A2BE2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Upgrade Now',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Limited Edition',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 20),
        // Statistics
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('12', 'Applications Sent'),
            _buildStatItem('3', 'Interviews'),
            _buildStatItem('8', 'Pending'),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Upgrade to Premium for real-time tracking, advanced analytics, and unlimited applications.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF666666),
          ),
        ),
      ],
    ),
  );

  /// Builds individual stat item
  Widget _buildStatItem(String number, String label) => Column(
    children: [
      Text(
        number,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8A2BE2),
        ),
      ),
      const SizedBox(height: 4),
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
  );

  /// Builds the Affirmation & Tips section
  Widget _buildAffirmationTipsSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Affirmation & Tips',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 180, // Increased height for larger cards
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                height: 180,
                width: 204, // Increased width for affirmation card
                child: _buildAffirmationCard(),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 200, // Increased width for career tip card
                child: _buildCareerTipCard(),
              ),
              const SizedBox(width: 12),
              // Additional cards for better scrolling experience
              SizedBox(width: 200, child: _buildAffirmationCard()),
              const SizedBox(width: 12),
              SizedBox(width: 200, child: _buildCareerTipCard()),
            ],
          ),
        ),
      ),
    ],
  );

  /// Builds the Daily Affirmation card
  Widget _buildAffirmationCard() => Container(
    padding: const EdgeInsets.all(20), // Increased padding
    decoration: BoxDecoration(
      color: const Color(0xFFE4E4E4), // Grey background
      borderRadius: BorderRadius.circular(16), // Increased border radius
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
      children: [
        Row(
          children: [
            const Icon(
              Icons.auto_awesome,
              color: Color(0xFF8A2BE2),
              size: 24,
            ), // Increased icon size
            const SizedBox(width: 12), // Increased spacing
            const Expanded(
              child: Text(
                'Daily Affirmation',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Increased spacing
        const Text(
          'I achieve extraordinary success through consistency and determination.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12, // Increased font size
            fontWeight: FontWeight.w400,
            color: Color(0xFF000000),
            height: 1.4,
          ),
        ),
      ],
    ),
  );

  /// Builds the Career Tip card
  Widget _buildCareerTipCard() => Container(
    padding: const EdgeInsets.all(20), // Increased padding
    decoration: BoxDecoration(
      color: const Color(0xFFE4E4E4), // Grey background
      borderRadius: BorderRadius.circular(16), // Increased border radius
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
      children: [
        Row(
          children: [
            Container(
              width: 24, // Increased size
              height: 24, // Increased size
              decoration: const BoxDecoration(
                color: Color(0xFF8A2BE2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 14,
              ), // Increased icon size
            ),
            const SizedBox(width: 12), // Increased spacing
            const Expanded(
              child: Text(
                'Career Tip',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Increased spacing
        const Text(
          'Build meaningful connections to unlock opportunities and growth.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14, // Increased font size
            fontWeight: FontWeight.w400,
            color: Color(0xFF000000),
            height: 1.4,
          ),
        ),
      ],
    ),
  );

  /// Builds the Recent Jobs section
  Widget _buildRecentJobsSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Recent Jobs',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000000),
        ),
      ),
      const SizedBox(height: 16),
      _buildJobCard(
        'Senior Project Manager',
        'Tokopedia - Jakarta, ID',
        '\$50 - \$75 / Mo',
        Icons.shopping_bag,
      ),
      const SizedBox(height: 12),
      _buildJobCard(
        'Product Designer',
        'Gojek - Jakarta, ID',
        '\$40 - \$60 / Mo',
        Icons.design_services,
      ),
    ],
  );

  /// Builds individual job card
  Widget _buildJobCard(
    String title,
    String company,
    String salary,
    IconData icon,
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        // Company Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF8A2BE2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF8A2BE2), size: 20),
        ),
        const SizedBox(width: 12),
        // Job Details
        Expanded(
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
              const SizedBox(height: 4),
              Text(
                company,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                salary,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
        // Arrow Button
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF8A2BE2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 14,
          ),
        ),
      ],
    ),
  );
}
