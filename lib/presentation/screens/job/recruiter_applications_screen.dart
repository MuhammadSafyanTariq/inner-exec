import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class RecruiterApplicationsScreen extends StatelessWidget {
  const RecruiterApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF8A2BE2),
          size: 18,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text(
        'Applicants',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Color(0xFF000000),
        ),
      ),
    ),
    body: const _RecruiterApplicationsList(),
  );
}

class _RecruiterApplicationsList extends StatelessWidget {
  const _RecruiterApplicationsList();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text('Please log in as recruiter'));
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('ownerUid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'No applicants yet',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF777777)),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final data = docs[i].data();
            return _ApplicantTile(
              applicationId: docs[i].id,
              title: (data['title'] ?? '').toString(),
              company: (data['company'] ?? '').toString(),
              dateApplied: (data['appliedAtDisplay'] ?? '').toString(),
              status: (data['status'] ?? 'Pending').toString(),
              imageUrl: (data['imageUrl'] ?? '').toString(),
              uid: (data['uid'] ?? '').toString(),
              resumeUrl: (data['resumeUrl'] ?? '').toString(),
            );
          },
        );
      },
    );
  }
}

class _ApplicantTile extends StatelessWidget {
  const _ApplicantTile({
    required this.applicationId,
    required this.title,
    required this.company,
    required this.dateApplied,
    required this.status,
    required this.imageUrl,
    required this.uid,
    required this.resumeUrl,
  });

  final String applicationId;
  final String title;
  final String company;
  final String dateApplied;
  final String status;
  final String imageUrl;
  final String uid;
  final String resumeUrl;

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'accepted':
        return const Color(0xFF6C63FF);
      case 'rejected':
        return const Color(0xFFFF6B6B);
      default:
        return const Color(0xFF8A2BE2);
    }
  }

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ApplicantDetailScreen(
          applicationId: applicationId,
          title: title,
          company: company,
          dateApplied: dateApplied,
          status: status,
          imageUrl: imageUrl,
          uid: uid,
          resumeUrl: resumeUrl,
        ),
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E1E1)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D9FF),
              borderRadius: BorderRadius.circular(8),
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? const Icon(Icons.image, color: Color(0xFF8A2BE2))
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 2),
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .get(),
                  builder: (context, snapshot) {
                    final String fullName =
                        (snapshot.data?.data()?['fullName'] ?? 'Applicant')
                            .toString();
                    return Text(
                      fullName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xFF333333),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 2),
                Text(
                  company,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date Applied: $dateApplied',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status[0].toUpperCase() + status.substring(1),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: _statusColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ApplicantDetailScreen extends StatelessWidget {
  const _ApplicantDetailScreen({
    required this.applicationId,
    required this.title,
    required this.company,
    required this.dateApplied,
    required this.status,
    required this.imageUrl,
    required this.uid,
    required this.resumeUrl,
  });

  final String applicationId;
  final String title;
  final String company;
  final String dateApplied;
  final String status;
  final String imageUrl;
  final String uid;
  final String resumeUrl;

  @override
  Widget build(BuildContext context) {
    final String img = imageUrl;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF8A2BE2),
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Applicant Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D9FF),
                    borderRadius: BorderRadius.circular(8),
                    image: img.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(img),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: img.isEmpty
                      ? const Icon(Icons.person, color: Color(0xFF8A2BE2))
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        company,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Applied: $dateApplied',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                      ),
                      const SizedBox(height: 6),
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .get(),
                        builder: (context, snapshot) {
                          final String phone =
                              (snapshot.data?.data()?['phone'] ?? '—')
                                  .toString();
                          return Text(
                            'Phone: $phone',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color(0xFF777777),
                            ),
                          );
                        },
                      ),
                      if (resumeUrl.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: OutlinedButton(
                            onPressed: () async {
                              final String url = resumeUrl;
                              if (url.isEmpty) return;
                              try {
                                final Uri uri = Uri.parse(url);
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } catch (_) {}
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF8A2BE2)),
                              foregroundColor: const Color(0xFF8A2BE2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'View Resume',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateStatus(context, 'Accepted'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateStatus(context, 'Rejected'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(applicationId)
          .update({'status': newStatus});
      if (context.mounted) Navigator.of(context).pop();
    } catch (_) {}
  }
}
