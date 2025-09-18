import 'package:flutter/material.dart';
import 'resume_auditor_screen.dart';
import '../../widgets/custom_text_field.dart';
import 'package:innerexec/presentation/screens/job_add/add_job_screen.dart';
import 'package:innerexec/presentation/screens/job/job_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Jobs screen with pixel-perfect design
class JobsScreen extends StatefulWidget {
  /// Creates a new jobs screen
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  bool _isJobsSelected = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    floatingActionButton: FloatingActionButton(
      backgroundColor: const Color(0xFF8A2BE2),
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const AddJobScreen()));
      },
      child: const Icon(Icons.add, color: Colors.white),
    ),
  );

  /// Builds the search bar
  Widget _buildSearchBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: CustomTextField(
      hintText: 'Search',
      controller: _searchController,
      width: double.infinity,
      height: 54,
      borderRadius: 8,
      borderWidth: 1,
      fillColor: Colors.grey[100],
      borderColor: Colors.grey[300]!,
      onChanged: (val) => setState(() => _searchQuery = val.trim()),
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

  /// Builds the job listings (from Firestore)
  Widget _buildJobListings() =>
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
              snapshot.data?.docs ?? [];
          // Client-side filter for search (title, company, tags, salary)
          if (_searchQuery.isNotEmpty) {
            final q = _searchQuery.toLowerCase();
            docs = docs.where((d) {
              final m = d.data();
              final title = (m['title'] ?? '').toString().toLowerCase();
              final company = (m['company'] ?? '').toString().toLowerCase();
              final jobType = (m['jobType'] ?? '').toString().toLowerCase();
              final placement = (m['placement'] ?? '').toString().toLowerCase();
              final experience = (m['experience'] ?? '')
                  .toString()
                  .toLowerCase();
              final salary = (m['salary'] ?? '').toString().toLowerCase();
              return title.contains(q) ||
                  company.contains(q) ||
                  jobType.contains(q) ||
                  placement.contains(q) ||
                  experience.contains(q) ||
                  salary.contains(q);
            }).toList();
          }
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'No jobs yet. Tap + to add one.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF777777),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: docs.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              if (i == docs.length) return const SizedBox(height: 100);
              final data = docs[i].data();
              final String title = (data['title'] ?? '').toString();
              final String company = (data['company'] ?? '').toString();
              final String salary = (data['salary'] ?? '').toString();
              final String imageUrl = (data['imageUrl'] ?? '').toString();
              final List<String> tags = [
                (data['jobType'] ?? '').toString(),
                (data['placement'] ?? '').toString(),
                (data['experience'] ?? '').toString(),
              ].where((e) => e.isNotEmpty).toList();
              return _buildJobCard(
                title,
                company,
                'Match with your needs',
                tags,
                salary,
                Icons.work_outline,
                imageUrl: imageUrl,
                jobId: docs[i].id,
              );
            },
          );
        },
      );

  /// Builds individual job card
  Widget _buildJobCard(
    String title,
    String company,
    String description,
    List<String> tags,
    String salary,
    IconData iconData, {
    String? imageUrl,
    String? jobId,
  }) => GestureDetector(
    onTap: () {
      // Build details from the same data we show in the card
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => JobDetailsScreen(
            jobId: jobId,
            company: company,
            title: title,
            tags: tags,
            salary: salary.isNotEmpty ? salary : '',
            placement: tags.length > 1 ? tags[1] : '',
            experience: tags.length > 2 ? tags[2] : '',
            applicants: 200,
            posterName: company,
            posterRole: 'Job Recruiter at ' + company,
            about: 'About the role at ' + company + ': ' + description,
            responsibilities: const [
              'Collaborate with cross-functional teams.',
              'Deliver high-quality work on time.',
              'Continuously improve processes and outcomes.',
            ],
            imageUrl: imageUrl ?? '',
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: Color(0xFF8A2BE2), width: 4),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Job Icon / Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF8A2BE2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  image: (imageUrl != null && imageUrl.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (imageUrl == null || imageUrl.isEmpty)
                    ? Icon(iconData, color: const Color(0xFF8A2BE2), size: 24)
                    : null,
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
                (() {
                  String t = salary.trim();
                  if (!t.startsWith('\$')) t = '\$' + t;
                  if (!t.toLowerCase().endsWith('/month')) t = '$t / month';
                  return t;
                })(),
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
