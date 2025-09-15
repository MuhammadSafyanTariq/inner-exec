import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'dart:io';
import 'package:innerexec/core/services/cloudinary_service.dart';

/// Pixel-perfect Apply Job screen
class ApplyJobScreen extends StatefulWidget {
  const ApplyJobScreen({super.key, required this.company, this.jobId});

  final String company;
  final String? jobId;

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _profileName = '';
  String _profileLocation = '';
  String _profilePhotoUrl = '';
  String _profileSkill = '';

  String? _resumeFileName;
  String? _resumeUrl;
  bool _isUploadingResume = false;
  bool _isSubmitting = false;

  String _jobTitle = '';
  String _jobImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadJobInfo();
  }

  Future<void> _loadUserProfile() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Prefill from auth where available
      _emailController.text = user.email ?? '';

      // Try Firestore user document
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data() ?? {};

      setState(() {
        _profileName = (data['fullName'] ?? user.displayName ?? '').toString();
        _profileLocation = (data['location'] ?? '').toString();
        _profilePhotoUrl = (data['imageUrl'] ?? user.photoURL ?? '').toString();
        _profileSkill = (data['skill'] ?? '').toString();

        // Phone/email overrides from profile if present
        final String email = (data['email'] ?? _emailController.text)
            .toString();
        _emailController.text = email;
        final String phone = (data['phone'] ?? '').toString();
        if (phone.isNotEmpty) {
          _phoneController.text = phone;
        }
      });
    } catch (_) {
      // Silent failure; keep fields as-is
    }
  }

  Future<void> _loadJobInfo() async {
    try {
      if (widget.jobId == null) return;
      final doc = await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobId)
          .get();
      final data = doc.data();
      if (data == null) return;
      setState(() {
        _jobTitle = (data['title'] ?? '').toString();
        _jobImageUrl = (data['imageUrl'] ?? '').toString();
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
            const SizedBox(height: 16),
            _ProfileCard(
              name: _profileName.isNotEmpty ? _profileName : 'Your Profile',
              location: _profileLocation.isNotEmpty ? _profileLocation : '—',
              photoUrl: _profilePhotoUrl,
              skill: _profileSkill,
            ),
            const SizedBox(height: 20),
            _label('Email'),
            const SizedBox(height: 8),
            _input(
              _emailController,
              hint: 'Enter your email here',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _label('Phone Number'),
            const SizedBox(height: 8),
            _input(
              _phoneController,
              hint: 'Enter your number here',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _UploadCard(
              onTap: _pickAndUploadResume,
              isUploading: _isUploadingResume,
              fileName: _resumeFileName,
            ),
            const SizedBox(height: 10),
            Center(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF777777),
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(text: "Don't have a CV? "),
                    TextSpan(
                      text: 'Create using AI',
                      style: TextStyle(
                        color: Color(0xFF8A2BE2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2BE2),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(_isSubmitting ? 'Submitting...' : 'Apply'),
              ),
            ),
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
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          'Apply to ${widget.company}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF000000),
          ),
        ),
      ),
      const SizedBox(width: 24),
    ],
  );

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF333333),
    ),
  );

  Widget _input(
    TextEditingController controller, {
    required String hint,
    TextInputType? keyboardType,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF8A2BE2)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
    style: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      color: Color(0xFF333333),
    ),
  );

  Future<void> _pickAndUploadResume() async {
    try {
      final result = await fp.FilePicker.platform.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: false,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.size > 5 * 1024 * 1024) {
        // 5MB limit
        return;
      }
      final path = file.path;
      if (path == null) return;

      setState(() {
        _isUploadingResume = true;
        _resumeFileName = file.name;
      });

      final User? user = FirebaseAuth.instance.currentUser;
      final String uid = user?.uid ?? 'anonymous';
      final String jobId = widget.jobId ?? 'general';

      // Upload to Cloudinary (resumes folder)
      final cloud = CloudinaryService();
      final String fileName =
          '${uid}_${jobId}_${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final String url = await cloud.uploadCustomImage(
        imagePath: path,
        folder: 'resumes',
        fileName: fileName,
      );

      setState(() {
        _resumeUrl = url;
        _isUploadingResume = false;
      });
    } catch (_) {
      setState(() {
        _isUploadingResume = false;
      });
    }
  }

  Future<void> _handleApply() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _isSubmitting = false);
        return;
      }

      final String uid = user.uid;
      final String company = widget.company;
      final String title = _jobTitle.isNotEmpty ? _jobTitle : '—';
      final String appliedAtDisplay = _formatDate(DateTime.now());

      String ownerUid = '';
      if (widget.jobId != null && widget.jobId!.isNotEmpty) {
        try {
          final jobDoc = await FirebaseFirestore.instance
              .collection('jobs')
              .doc(widget.jobId)
              .get();
          ownerUid = (jobDoc.data()?['ownerUid'] ?? '').toString();
        } catch (_) {}
      }

      await FirebaseFirestore.instance.collection('applications').add({
        'uid': uid,
        'jobId': widget.jobId ?? '',
        'ownerUid': ownerUid,
        'company': company,
        'title': title,
        'imageUrl': _jobImageUrl,
        'status': 'Applied',
        'resumeUrl': _resumeUrl ?? '',
        'appliedAtDisplay': appliedAtDisplay,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.location,
    required this.photoUrl,
    required this.skill,
  });
  final String name;
  final String location;
  final String photoUrl;
  final String skill;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE1E1E1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFEDE7F6),
              backgroundImage: photoUrl.isNotEmpty
                  ? NetworkImage(photoUrl)
                  : null,
              child: photoUrl.isEmpty
                  ? const Icon(Icons.person, color: Color(0xFF8A2BE2))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isNotEmpty ? name : 'Your Profile',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  if (skill.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      skill,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({this.onTap, this.isUploading = false, this.fileName});
  final VoidCallback? onTap;
  final bool isUploading;
  final String? fileName;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E1E1)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUploading)
              const SizedBox(
                height: 48,
                width: 48,
                child: CircularProgressIndicator(
                  color: Color(0xFF8A2BE2),
                  strokeWidth: 3,
                ),
              )
            else
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFF1E8FF),
                child: Icon(Icons.upload_file, color: Color(0xFF8A2BE2)),
              ),
            const SizedBox(height: 12),
            Text(
              fileName == null ? 'Upload Resume' : fileName!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Microsoft Word or PDF only (5MB)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
