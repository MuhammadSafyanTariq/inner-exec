import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innerexec/core/services/cloudinary_service.dart';
import 'package:innerexec/presentation/widgets/common/custom_button.dart';
import 'package:innerexec/presentation/widgets/custom_text_field.dart';

/// Pixel-perfect Add Job screen
class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobTypeController = TextEditingController();
  final TextEditingController _placementController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _respController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  bool _isSaving = false;

  @override
  void dispose() {
    _companyController.dispose();
    _jobTitleController.dispose();
    _jobTypeController.dispose();
    _placementController.dispose();
    _experienceController.dispose();
    _salaryController.dispose();
    _aboutController.dispose();
    _respController.dispose();
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
            const SizedBox(height: 12),
            const Text(
              'Add your recent role, responsibilities, and\n'
              'achievements to keep your profile up to\n'
              'date.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF333333),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            _buildImagePicker(),
            const SizedBox(height: 20),
            _label('Company Name'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _companyController,
              hintText: 'Enter your company name here',
              width: double.infinity,
              height: 54,
              borderRadius: 8,
              borderWidth: 1,
              borderColor: const Color(0xFFE1E1E1),
              fillColor: const Color(0xFFF5F5F5),
            ),
            const SizedBox(height: 16),
            _label('Job Title'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _jobTitleController,
              hintText: 'Enter your job title here',
              width: double.infinity,
              height: 54,
              borderRadius: 8,
              borderWidth: 1,
              borderColor: const Color(0xFFE1E1E1),
              fillColor: const Color(0xFFF5F5F5),
            ),
            const SizedBox(height: 16),
            _label('Job Type'),
            const SizedBox(height: 8),
            _dropdownField(
              controller: _jobTypeController,
              hint: 'Select your job type here',
              options: const [
                'Full Time',
                'Part Time',
                'Contract',
                'Internship',
                'Freelance',
              ],
            ),
            const SizedBox(height: 16),
            _label('Placement'),
            const SizedBox(height: 8),
            _dropdownField(
              controller: _placementController,
              hint: 'Select your placement here',
              options: const ['On-site', 'Remote', 'Hybrid'],
            ),
            const SizedBox(height: 16),
            _label('Experience'),
            const SizedBox(height: 8),
            _dropdownField(
              controller: _experienceController,
              hint: 'Select your experience here',
              options: const ['Fresher', '1-2 Years', '3-5 Years', '5+ Years'],
            ),
            const SizedBox(height: 16),
            _label('Monthly Salary'),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _salaryController,
              hintText: 'Enter your monthly salary here',
              width: double.infinity,
              height: 54,
              borderRadius: 8,
              borderWidth: 1,
              borderColor: const Color(0xFFE1E1E1),
              fillColor: const Color(0xFFF5F5F5),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _label('About this Job'),
            const SizedBox(height: 8),
            _multilineField(
              controller: _aboutController,
              hint: 'Enter about job here',
              minLines: 5,
            ),
            const SizedBox(height: 16),
            _label('Responsibilities'),
            const SizedBox(height: 8),
            _multilineField(
              controller: _respController,
              hint: 'Enter job responsibilities here',
              minLines: 5,
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Save Job',
                  height: 50,
                  backgroundColor: const Color(0xFF8A2BE2),
                  foregroundColor: Colors.white,
                  isLoading: _isSaving,
                  onPressed: _isSaving ? null : _saveJob,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );

  Widget _buildHeader(BuildContext context) => Row(
    children: [
      GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
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
            'Add Job',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8A2BE2),
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 24,
      ), // balance the back icon space for perfect centering
    ],
  );

  Widget _buildImagePicker() => Align(
    alignment: Alignment.center,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E1E1)),
              image: DecorationImage(
                image: _imagePath != null
                    ? FileImage(File(_imagePath!)) as ImageProvider
                    : const AssetImage('assets/images/board_1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          right: -6,
          bottom: -6,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.edit, size: 18, color: Color(0xFF8A2BE2)),
            ),
          ),
        ),
      ],
    ),
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

  Widget _dropdownField({
    required TextEditingController controller,
    required String hint,
    List<String> options = const [],
  }) {
    final List<DropdownMenuItem<String>> items = options
        .map(
          (opt) => DropdownMenuItem<String>(
            value: opt,
            child: Text(
              opt,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ),
        )
        .toList();

    final String? currentValue = options.contains(controller.text)
        ? controller.text
        : null;

    return SizedBox(
      height: 54,
      child: DropdownButtonFormField<String>(
        value: currentValue,
        items: items,
        onChanged: (val) {
          setState(() {
            controller.text = val ?? '';
          });
        },
        isExpanded: true,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF8A2BE2)),
          ),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF8A2BE2),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _multilineField({
    required TextEditingController controller,
    required String hint,
    int minLines = 4,
  }) => TextField(
    controller: controller,
    minLines: minLines,
    maxLines: null,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF8A2BE2)),
      ),
      contentPadding: const EdgeInsets.all(12),
    ),
    style: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      color: Color(0xFF333333),
    ),
  );

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _imagePath = picked.path;
        });
      }
    } catch (_) {}
  }

  Future<void> _saveJob() async {
    setState(() {
      _isSaving = true;
    });
    try {
      final String company = _companyController.text.trim();
      final String title = _jobTitleController.text.trim();
      if (company.isEmpty || title.isEmpty) {
        setState(() {
          _isSaving = false;
        });
        return;
      }

      String imageUrl = '';
      if (_imagePath != null && _imagePath!.isNotEmpty) {
        final CloudinaryService cloud = CloudinaryService();
        final String fileName = 'job_${DateTime.now().millisecondsSinceEpoch}';
        imageUrl = await cloud.uploadCustomImage(
          imagePath: _imagePath!,
          folder: 'job_images',
          fileName: fileName,
        );
      }

      await FirebaseFirestore.instance.collection('jobs').add({
        'company': company,
        'title': title,
        'jobType': _jobTypeController.text.trim(),
        'placement': _placementController.text.trim(),
        'experience': _experienceController.text.trim(),
        'salary': _salaryController.text.trim(),
        'about': _aboutController.text.trim(),
        'responsibilities': _respController.text.trim(),
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      setState(() {
        _isSaving = false;
      });
    }
  }
}
