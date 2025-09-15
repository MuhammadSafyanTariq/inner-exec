import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

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
        'My Applications',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Color(0xFF000000),
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _searchBar(),
          const SizedBox(height: 12),
          Expanded(child: _ApplicationsList()),
        ],
      ),
    ),
  );

  Widget _searchBar() => Container(
    height: 54,
    decoration: BoxDecoration(
      color: const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE1E1E1)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Search',
      style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF777777)),
    ),
  );
}

class _ApplicationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text('Please log in to view applications'));
    }
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('uid', isEqualTo: uid)
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
              'No applications yet',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF777777)),
            ),
          );
        }
        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final data = docs[i].data();
            return _ApplicationTile(
              title: (data['title'] ?? '').toString(),
              company: (data['company'] ?? '').toString(),
              dateApplied: (data['appliedAtDisplay'] ?? '').toString(),
              status: (data['status'] ?? 'Applied').toString(),
              imageUrl: (data['imageUrl'] ?? '').toString(),
            );
          },
        );
      },
    );
  }
}

class _ApplicationTile extends StatelessWidget {
  const _ApplicationTile({
    required this.title,
    required this.company,
    required this.dateApplied,
    required this.status,
    required this.imageUrl,
  });

  final String title;
  final String company;
  final String dateApplied;
  final String status;
  final String imageUrl;

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
  Widget build(BuildContext context) => Container(
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
  );
}
