import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innerexec/auth/login_screen.dart';
import 'package:innerexec/presentation/screens/job/applications_screen.dart';
import 'package:innerexec/presentation/screens/job/recruiter_applications_screen.dart';

/// Profile screen
class ProfileScreen extends StatelessWidget {
  /// Creates a new profile screen
  const ProfileScreen({super.key});

  static const Color _textPrimary = Color(0xFF333333);
  static const Color _cardFill = Color(0xFFF5F0FF);
  static const Color _tileFill = Color(0xFFEDE7FF);
  static const double _contentPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: user == null
            ? const _CenteredInfo(text: 'Please log in to view your profile.')
            : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const _CenteredInfo(text: 'No profile data found.');
                  }

                  final data = snapshot.data!.data() ?? {};

                  final String fullName = (data['fullName'] ?? '').toString();
                  final String role = (data['expertise'] ?? '').toString();
                  final String imageUrl = (data['imageUrl'] ?? '').toString();
                  final bool openToWork = (data['openToWork'] == true);

                  final int totalFields = 6;
                  int filled = 0;
                  for (final value in [
                    data['fullName'],
                    data['username'],
                    data['skill'],
                    data['expertise'],
                    data['jobType'],
                    data['imageUrl'],
                  ]) {
                    if (value != null && value.toString().trim().isNotEmpty) {
                      filled += 1;
                    }
                  }
                  final int completion = ((filled / totalFields) * 100)
                      .clamp(0, 100)
                      .toInt();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _contentPadding,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _Header(
                          name: fullName.isNotEmpty
                              ? fullName
                              : (user.displayName ?? 'User'),
                          role: role.isNotEmpty ? role : '—',
                          imageUrl: imageUrl,
                          openToWork: openToWork,
                        ),
                        const SizedBox(height: 16),
                        _ProfileCompletionCard(percent: completion),
                        const SizedBox(height: 16),
                        _SectionCard(
                          children: const [
                            _NavTile(
                              icon: Icons.description_outlined,
                              title: 'AI CV',
                            ),
                            _Divider(),
                            _NavTile(
                              icon: Icons.work_outline,
                              title: 'Work Experience',
                            ),
                            _Divider(),
                            _NavTile(
                              icon: Icons.sticky_note_2_outlined,
                              title: 'Proposal',
                            ),
                            _Divider(),
                            _NavTile(
                              icon: Icons.school_outlined,
                              title: 'Education',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _SectionCard(
                          children: const [
                            _NavTile(
                              icon: Icons.star_border_rounded,
                              title: 'Skills',
                            ),
                            _Divider(),
                            _NavTile(
                              icon: Icons.store_mall_directory_outlined,
                              title: 'Freelance service listings',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _SectionCard(
                          children: [
                            _NavTile(
                              icon: Icons.history,
                              title: 'My Applications',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ApplicationsScreen(),
                                  ),
                                );
                              },
                            ),
                            const _Divider(),
                            _NavTile(
                              icon: Icons.manage_accounts_outlined,
                              title: 'Recruiter: Applicants',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RecruiterApplicationsScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _SectionCard(
                          children: const [
                            _NavTile(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy & Policy',
                            ),
                            _Divider(),
                            _NavTile(
                              icon: Icons.description_outlined,
                              title: 'Term of Service',
                            ),
                            _Divider(),
                            _NavTile(
                              icon: Icons.subscriptions_outlined,
                              title: 'Subscription',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _ActionTile(
                          icon: Icons.delete_outline,
                          title: 'Delete Account',
                          color: _textPrimary,
                        ),
                        const SizedBox(height: 16),
                        _ActionTile(
                          icon: Icons.logout,
                          title: 'Log Out',
                          color: _textPrimary,
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.openToWork,
  });

  final String name;
  final String role;
  final String imageUrl;
  final bool openToWork;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE7FF),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.white,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? const Icon(Icons.person, size: 48, color: Color(0xFF8A2BE2))
                  : null,
            ),
          ),
          if (openToWork)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF8A2BE2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'OpenToWork',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.edit, size: 16, color: Color(0xFF8A2BE2)),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        role,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color(0xFF777777),
        ),
      ),
    ],
  );
}

class _ProfileCompletionCard extends StatelessWidget {
  const _ProfileCompletionCard({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ProfileScreen._tileFill,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 42,
          height: 42,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(
                  value: percent / 100,
                  strokeWidth: 4,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF8A2BE2)),
                  backgroundColor: Colors.white,
                ),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Update your Profile Now!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Complete your profile to make finding a job easier',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Color(0xFF333333)),
      ],
    ),
  );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
    decoration: BoxDecoration(
      color: ProfileScreen._cardFill,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: children),
  );
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.icon, required this.title, this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    leading: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: ProfileScreen._textPrimary),
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: ProfileScreen._textPrimary,
      ),
    ),
    trailing: const Icon(
      Icons.chevron_right,
      color: ProfileScreen._textPrimary,
    ),
    onTap: onTap,
  );
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Divider(height: 1, color: Color(0xFFE1E1E1)),
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: ProfileScreen._textPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}

class _CenteredInfo extends StatelessWidget {
  const _CenteredInfo({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        color: Color(0xFF333333),
      ),
    ),
  );
}
