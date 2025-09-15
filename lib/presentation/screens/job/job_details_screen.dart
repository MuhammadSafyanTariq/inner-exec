import 'package:flutter/material.dart';
import 'package:innerexec/presentation/screens/job/apply_job_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Pixel-perfect Job Details screen
class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({
    super.key,
    this.jobId,
    required this.company,
    required this.title,
    required this.tags,
    required this.salary,
    required this.placement,
    required this.experience,
    required this.applicants,
    required this.posterName,
    required this.posterRole,
    required this.about,
    required this.responsibilities,
    this.imageUrl = '',
  });

  final String? jobId;
  final String company;
  final String title;
  final List<String> tags;
  final String salary;
  final String placement;
  final String experience;
  final int applicants;
  final String posterName;
  final String posterRole;
  final String about;
  final List<String> responsibilities;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // If jobId is provided, stream actual Firestore data; otherwise use passed props
    if (jobId != null && jobId!.isNotEmpty) {
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .doc(jobId)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final data = snap.data?.data() ?? {};
          final String c = (data['company'] ?? company).toString();
          final String t = (data['title'] ?? title).toString();
          final String s = (data['salary'] ?? salary).toString();
          final String plc = (data['placement'] ?? placement).toString();
          final String exp = (data['experience'] ?? experience).toString();
          final List<String> tg = [
            (data['jobType'] ?? (tags.isNotEmpty ? tags[0] : '')).toString(),
            plc,
            exp,
          ].where((e) => e.isNotEmpty).toList();
          final String img = (data['imageUrl'] ?? imageUrl).toString();
          final String aboutText = (data['about'] ?? about).toString();
          final List<String> respList = (data['responsibilities'] is List)
              ? List<String>.from(data['responsibilities'])
              : (data['responsibilities'] ?? '')
                    .toString()
                    .split('\n')
                    .where((e) => e.trim().isNotEmpty)
                    .toList();

          return _ScaffoldDetails(
            company: c,
            title: t,
            tags: tg,
            salary: s,
            placement: plc,
            experience: exp,
            applicants: applicants,
            posterName: posterName,
            posterRole: posterRole,
            about: aboutText,
            responsibilities: respList.isNotEmpty ? respList : responsibilities,
            imageUrl: img,
            jobId: jobId,
          );
        },
      );
    }

    return _ScaffoldDetails(
      company: company,
      title: title,
      tags: tags,
      salary: salary,
      placement: placement,
      experience: experience,
      applicants: applicants,
      posterName: posterName,
      posterRole: posterRole,
      about: about,
      responsibilities: responsibilities,
      imageUrl: imageUrl,
      jobId: jobId,
    );
  }
}

class _ScaffoldDetails extends StatelessWidget {
  const _ScaffoldDetails({
    required this.company,
    required this.title,
    required this.tags,
    required this.salary,
    required this.placement,
    required this.experience,
    required this.applicants,
    required this.posterName,
    required this.posterRole,
    required this.about,
    required this.responsibilities,
    required this.imageUrl,
    this.jobId,
  });

  final String company;
  final String title;
  final List<String> tags;
  final String salary;
  final String placement;
  final String experience;
  final int applicants;
  final String posterName;
  final String posterRole;
  final String about;
  final List<String> responsibilities;
  final String imageUrl;
  final String? jobId;

  static const TextStyle _h6 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Color(0xFF333333),
  );

  Widget _bullet(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(
            Icons.fiber_manual_record,
            size: 6,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _HeroCard(
              company: company,
              title: title,
              tags: tags,
              salary: salary,
              imageUrl: imageUrl,
              jobId: jobId,
            ),
            const SizedBox(height: 65),
            _TwoCol(
              label1: 'Job Type',
              value1: tags.isNotEmpty ? tags[0] : '',
              label2: 'Placement',
              value2: placement,
            ),
            const SizedBox(height: 14),
            _TwoCol(
              label1: 'Experience',
              value1: experience,
              label2: 'Month Salary',
              value2: salary,
            ),
            const SizedBox(height: 14),
            _OneCol(label: 'Applicants', value: applicants.toString()),
            const SizedBox(height: 16),
            _PostedBy(name: posterName, role: posterRole),
            const SizedBox(height: 20),
            const Text('About the Job', style: _h6),
            const SizedBox(height: 8),
            Text(
              about,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Responsibilities', style: _h6),
            const SizedBox(height: 8),
            ...responsibilities.map((r) => _bullet(r)).toList(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ApplyJobScreen(jobId: jobId, company: company),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2BE2),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );

  Widget _buildHeader(BuildContext context) => Row(
    children: [
      GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Image.asset(
            'assets/images/back_icon.png',
            width: 24,
            height: 24,
          ),
        ),
      ),
      const Expanded(
        child: Center(
          child: Text(
            'Details',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000000),
            ),
          ),
        ),
      ),
      const SizedBox(width: 24),
    ],
  );
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.company,
    required this.title,
    required this.tags,
    required this.salary,
    this.imageUrl = '',
    this.jobId,
  });
  final String company;
  final String title;
  final List<String> tags;
  final String salary;
  final String imageUrl;
  final String? jobId;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFE8D9FF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: (imageUrl.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.music_note, color: Color(0xFF8A2BE2))
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tags
                  .map(
                    (t) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        t,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 46),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -60,
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF8A2BE2),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    salary,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ApplyJobScreen(jobId: jobId, company: company),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF8A2BE2),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// _SalaryApplyRow removed; salary bar lives inside _HeroCard

class _TwoCol extends StatelessWidget {
  const _TwoCol({
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
  });
  final String label1;
  final String value1;
  final String label2;
  final String value2;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _Info(label: label1, value: value1),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _Info(label: label2, value: value2),
      ),
    ],
  );
}

class _OneCol extends StatelessWidget {
  const _OneCol({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => _Info(label: label, value: value);
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: Color(0xFF777777),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
    ],
  );
}

class _PostedBy extends StatelessWidget {
  const _PostedBy({required this.name, required this.role});
  final String name;
  final String role;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE1E1E1)),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFEDE7F6),
          child: Icon(Icons.person, color: Color(0xFF8A2BE2)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              role,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
