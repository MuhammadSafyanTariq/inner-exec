import 'package:flutter/material.dart';
import 'resume_auditor_screen.dart';
import '../../widgets/custom_text_field.dart';

/// Jobs screen with pixel-perfect design
class JobsScreen extends StatefulWidget {
  /// Creates a new jobs screen
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  bool _isJobsSelected = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Search Bar
          _buildSearchBar(),
          const SizedBox(height: 24),
          // Jobs/Services Tabs
          _buildTabs(),
          const SizedBox(height: 20),
          // Job Listings
          Expanded(
            child: _isJobsSelected
                ? _buildJobListings()
                : _buildServicesPlaceholder(),
          ),
        ],
      ),
    ),
  );

  /// Builds the search bar
  Widget _buildSearchBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: CustomTextField(
      hintText: 'Search',
      width: double.infinity,
      height: 54,
      borderRadius: 8,
      borderWidth: 1,
      fillColor: Colors.grey[100],
      borderColor: Colors.grey[300]!,
      suffixIcon: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFF8A2BE2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.search, color: Colors.white, size: 16),
      ),
    ),
  );

  /// Builds the Jobs/Services tabs
  Widget _buildTabs() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Stack(
      children: [
        // Animated line under active tab
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: _isJobsSelected
              ? 0
              : MediaQuery.of(context).size.width * 0.5 -
                    20, // Right side for Services
          top:
              32, // Position under the text with spacing (8px padding + 16px text + 8px spacing)
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.5 -
                40, // Half screen width minus padding
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF8A2BE2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Tab buttons
        Row(
          children: [
            _buildTab('Jobs', _isJobsSelected, () {
              setState(() {
                _isJobsSelected = true;
              });
            }),
            const Spacer(),
            _buildTab('Services', !_isJobsSelected, () {
              setState(() {
                _isJobsSelected = false;
              });
            }),
          ],
        ),
      ],
    ),
  );

  /// Builds individual tab
  Widget _buildTab(String title, bool isSelected, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width:
              MediaQuery.of(context).size.width * 0.5 -
              40, // Half screen width minus padding
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 8), // Spacing between text and line
            ],
          ),
        ),
      );

  /// Builds the job listings
  Widget _buildJobListings() => ListView(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    children: [
      _buildJobCard(
        'UI/UX DESIGNER',
        'NovaTech Solutions',
        'Match with your needs',
        ['Full Time', 'Hybrid', '1-2 Year'],
        '\$800/month',
        Icons.design_services,
      ),
      const SizedBox(height: 16),
      _buildJobCard(
        'UI/UX DESIGNER',
        'NovaTech Solutions',
        'Match with your needs',
        ['Full Time', 'Hybrid', '1-2 Year'],
        '\$800/month',
        Icons.design_services,
      ),
      const SizedBox(height: 16),
      _buildJobCard(
        'UI/UX DESIGNER',
        'NovaTech Solutions',
        'Match with your needs',
        ['Full Time', 'Hybrid', '1-2 Year'],
        '\$800/month',
        Icons.design_services,
      ),
      const SizedBox(height: 16),
      _buildJobCard(
        'UI/UX DESIGNER',
        'NovaTech Solutions',
        'Match with your needs',
        ['Full Time', 'Hybrid', '1-2 Year'],
        '\$800/month',
        Icons.design_services,
      ),
      const SizedBox(height: 100), // Space for bottom nav
    ],
  );

  /// Builds individual job card
  Widget _buildJobCard(
    String title,
    String company,
    String description,
    List<String> tags,
    String salary,
    IconData iconData,
  ) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border(
        left: BorderSide(color: const Color(0xFF8A2BE2), width: 4),
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            // Job Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF8A2BE2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(iconData, color: const Color(0xFF8A2BE2), size: 24),
            ),
            const SizedBox(width: 16),
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
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Tags and Salary row
        Row(
          children: [
            // Tags - positioned horizontally
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: tags.map((tag) => _buildTag(tag)).toList(),
              ),
            ),
            // Salary - positioned at the right
            Text(
              salary,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  /// Builds individual tag
  Widget _buildTag(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: Color(0xFF000000),
      ),
    ),
  );

  /// Builds services content
  Widget _buildServicesPlaceholder() => ListView(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    children: [
      _buildServiceCard(
        'RESUME AUDIT',
        'GET A DETAILED REVIEW OF YOUR RESUME WITH ACTIONABLE TIPS FROM CAREER EXPERTS.',
        '★ 4.8 (120 REVIEWS)',
        '\$800',
        Icons.description,
      ),
      const SizedBox(height: 16),
      _buildServiceCard(
        'RESUME AUDIT',
        'GET A DETAILED REVIEW OF YOUR RESUME WITH ACTIONABLE TIPS FROM CAREER EXPERTS.',
        '★ 4.8 (120 REVIEWS)',
        '\$800',
        Icons.description,
      ),
      const SizedBox(height: 16),
      _buildServiceCard(
        'RESUME AUDIT',
        'GET A DETAILED REVIEW OF YOUR RESUME WITH ACTIONABLE TIPS FROM CAREER EXPERTS.',
        '★ 4.8 (120 REVIEWS)',
        '\$800',
        Icons.description,
      ),
      const SizedBox(height: 100), // Space for bottom nav
    ],
  );

  /// Builds individual service card
  Widget _buildServiceCard(
    String title,
    String description,
    String rating,
    String price,
    IconData iconData,
  ) {
    return GestureDetector(
      onTap: () {
        print('Service card tapped!'); // Debug print
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ResumeAuditorScreen()),
        );
      },
      behavior: HitTestBehavior.opaque, // Ensure tap detection works
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            print('InkWell tapped!'); // Debug print
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ResumeAuditorScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
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
                // Purple left border
                Container(
                  width: 4,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A2BE2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                // Service icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A2BE2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    iconData,
                    color: const Color(0xFF8A2BE2),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Service details
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
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
