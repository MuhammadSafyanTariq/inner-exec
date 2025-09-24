import 'package:flutter/material.dart';
import 'package:innerexec/presentation/widgets/custom_text_field.dart';
import 'package:innerexec/core/services/openai_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pdfc;
import 'package:printing/printing.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:innerexec/core/services/cloudinary_service.dart';
import 'package:file_picker/file_picker.dart' as fp;

/// AI Resume & Cover Letter screen with multi-step form using IndexedStack
class WorkExperienceEntry {
  final TextEditingController jobTitle = TextEditingController();
  final TextEditingController company = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController responsibilities = TextEditingController();
  void dispose() {
    jobTitle.dispose();
    company.dispose();
    startDate.dispose();
    endDate.dispose();
    responsibilities.dispose();
  }
}

class EducationEntry {
  final TextEditingController degree = TextEditingController();
  final TextEditingController institute = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  void dispose() {
    degree.dispose();
    institute.dispose();
    startDate.dispose();
    endDate.dispose();
  }
}

class AiResumeScreen extends StatefulWidget {
  /// Creates a new AI resume screen
  const AiResumeScreen({super.key});

  @override
  State<AiResumeScreen> createState() => _AiResumeScreenState();
}

class _AiResumeScreenState extends State<AiResumeScreen> {
  int _currentStep = 0;
  final int _totalSteps = 6;

  // Form controllers for step 1 (Basic Information)
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _linksController = TextEditingController();

  // Form controllers for step 2 (Work Experience)
  final _jobTitleController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _responsibilitiesController = TextEditingController();
  // Multiple work experiences
  final List<WorkExperienceEntry> _workExperiences = [WorkExperienceEntry()];

  // Form controllers for step 3 (Education)
  final _degreeTitleController = TextEditingController();
  final _instituteNameController = TextEditingController();
  final _educationStartDateController = TextEditingController();
  final _educationEndDateController = TextEditingController();
  // Multiple education entries
  final List<EducationEntry> _educations = [EducationEntry()];

  // Variables for step 4 (Skills & Achievements)
  final List<String> _selectedSkills = [];
  String? _generatedResume;
  bool _loading = false;

  // Resume-only headshot state
  String? _headshotLocalPath;
  String? _headshotUrl; // Stored only for resume generation/PDF
  bool _isUploadingHeadshot = false;

  // New: store structured AI JSON
  Map<String, dynamic>? _aiJson;

  // Certifications upload state
  bool _isUploadingCerts = false;
  final List<String> _certificationUrls = [];
  final List<String> _certificationNames = [];

  // Style & Tone (Step 5)
  final List<String> _styleOptions = const [
    'Professional',
    'Modern',
    'Creative',
    'Concise',
    'ATS-friendly',
  ];
  String? _selectedStyle;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _linksController.dispose();
    _jobTitleController.dispose();
    _companyNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _responsibilitiesController.dispose();
    for (final e in _workExperiences) {
      e.dispose();
    }
    _degreeTitleController.dispose();
    _instituteNameController.dispose();
    _educationStartDateController.dispose();
    _educationEndDateController.dispose();
    for (final e in _educations) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    OpenAiService.init();
  }

  String _collectResumeData() {
    final sb = StringBuffer();
    sb.writeln('Name: ${_fullNameController.text}');
    sb.writeln('Phone: ${_phoneNumberController.text}');
    sb.writeln('Links: ${_linksController.text}\n');
    sb.writeln('Work Experience:');
    // Primary entry from existing fields
    sb.writeln('${_jobTitleController.text} at ${_companyNameController.text}');
    sb.writeln(
      'From ${_startDateController.text} to ${_endDateController.text}',
    );
    sb.writeln('Responsibilities: ${_responsibilitiesController.text}\n');
    // Additional entries
    for (final e in _workExperiences) {
      if (e.jobTitle.text.isEmpty &&
          e.company.text.isEmpty &&
          e.startDate.text.isEmpty &&
          e.endDate.text.isEmpty &&
          e.responsibilities.text.isEmpty) {
        continue;
      }
      sb.writeln('${e.jobTitle.text} at ${e.company.text}');
      sb.writeln('From ${e.startDate.text} to ${e.endDate.text}');
      sb.writeln('Responsibilities: ${e.responsibilities.text}\n');
    }
    sb.writeln('Education:');
    sb.writeln(
      '${_degreeTitleController.text} at ${_instituteNameController.text}',
    );
    sb.writeln(
      'From ${_educationStartDateController.text} to ${_educationEndDateController.text}\n',
    );
    for (final ed in _educations) {
      if (ed.degree.text.isEmpty &&
          ed.institute.text.isEmpty &&
          ed.startDate.text.isEmpty &&
          ed.endDate.text.isEmpty) {
        continue;
      }
      sb.writeln('${ed.degree.text} at ${ed.institute.text}');
      sb.writeln('From ${ed.startDate.text} to ${ed.endDate.text}\n');
    }
    sb.writeln('Skills: ${_selectedSkills.join(", ")}');
    sb.writeln('Achievements:');
    return sb.toString();
  }

  Future<void> _savePdf(String text) async {
    final pdf = pw.Document();

    // Colors & text styles
    final pdfc.PdfColor purple = pdfc.PdfColor.fromInt(0xFF8A2BE2);
    final sectionTitle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: purple,
    );
    final bodyStyle = const pw.TextStyle(fontSize: 10, height: 1.35);
    // Header subtitle style removed; contact is shown in header lines

    // Try to load headshot image for PDF if available
    pw.ImageProvider? headshotImage;
    if (_headshotUrl != null && _headshotUrl!.isNotEmpty) {
      try {
        headshotImage = await networkImage(_headshotUrl!);
      } catch (_) {
        headshotImage = null;
      }
    }

    // Gather structured data from form
    final String fullName = _fullNameController.text.isNotEmpty
        ? _fullNameController.text
        : 'Your Name';
    final String phone = _phoneNumberController.text;
    final String links = _linksController.text;
    final String jobTitle = _jobTitleController.text;
    final String companyName = _companyNameController.text;
    final String startDate = _startDateController.text;
    final String endDate = _endDateController.text;
    final String responsibilities = _responsibilitiesController.text;
    final String degree = _degreeTitleController.text;
    final String institute = _instituteNameController.text;
    final String eduStart = _educationStartDateController.text;
    final String eduEnd = _educationEndDateController.text;

    // Prefer parsed JSON fields if available, else extract sections from text
    final _AiParsedResume ai = _aiJson != null && _aiJson!.isNotEmpty
        ? _extractFromJson(_aiJson!)
        : _extractAiSections(text);
    // Summary/About from AI or fallback snippet (sanitized)
    String aboutMe = '';
    if (ai.summary.isNotEmpty) {
      aboutMe = sanitizeText(_sanitizeInline(ai.summary));
    } else if (text.trim().isNotEmpty) {
      aboutMe = sanitizeText(_sanitizeInline(text.trim()));
    }
    if (aboutMe.length > 400) {
      aboutMe = aboutMe.substring(0, 400) + '...';
    }
    // Merge and sanitize skills from AI and manual selection
    final List<String> mergedSkills = _mergeSkills(_selectedSkills, ai.skills);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: pdfc.PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: purple, width: 2),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            padding: const pw.EdgeInsets.fromLTRB(18, 18, 18, 22),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header - image left, name + contacts right
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (headshotImage != null)
                      pw.Container(
                        width: 60,
                        height: 60,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          image: pw.DecorationImage(
                            image: headshotImage,
                            fit: pw.BoxFit.cover,
                          ),
                        ),
                      ),
                    if (headshotImage != null) pw.SizedBox(width: 12),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            fullName.toUpperCase(),
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: purple,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          () {
                            final String? email = _extractEmail(links);
                            final String? linkedin = _extractLinkedIn(links);
                            final String? website = _extractWebsite(links);
                            final String topLine = [
                              if (phone.isNotEmpty)
                                'Phone: ' + sanitizeText(phone),
                              if (email != null && email.isNotEmpty)
                                'Email: ' + sanitizeText(email),
                            ].join('  |  ');
                            final String bottomLine = [
                              if (linkedin != null && linkedin.isNotEmpty)
                                'LinkedIn: ' + sanitizeText(linkedin),
                              if (website != null && website.isNotEmpty)
                                'Website: ' + sanitizeText(website),
                            ].join('  |  ');
                            return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                if (topLine.isNotEmpty)
                                  pw.Text(
                                    topLine,
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                      color: pdfc.PdfColors.grey700,
                                    ),
                                  ),
                                if (bottomLine.isNotEmpty)
                                  pw.Text(
                                    bottomLine,
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                      color: pdfc.PdfColors.grey700,
                                    ),
                                  ),
                                if (links.trim().isNotEmpty)
                                  pw.Text(
                                    sanitizeText(links),
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      color: pdfc.PdfColors.grey700,
                                    ),
                                  ),
                              ],
                            );
                          }(),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Container(height: 1.5, color: purple),
                pw.SizedBox(height: 10),

                // Two columns
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Left column
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('ABOUT ME', style: sectionTitle),
                          pw.Container(height: 1, color: purple),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            aboutMe.isNotEmpty ? aboutMe : ' ',
                            style: bodyStyle,
                          ),
                          pw.SizedBox(height: 14),

                          pw.Text('SKILLS', style: sectionTitle),
                          pw.Container(height: 1, color: purple),
                          pw.SizedBox(height: 6),
                          if (mergedSkills.isNotEmpty)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                for (final s in mergedSkills)
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                      bottom: 4,
                                    ),
                                    child: pw.Text(
                                      '- ' + sanitizeText(s),
                                      style: bodyStyle,
                                    ),
                                  ),
                              ],
                            )
                          else
                            pw.Text(' ', style: bodyStyle),
                          pw.SizedBox(height: 14),

                          if (_certificationUrls.isNotEmpty ||
                              ai.certifications.isNotEmpty) ...[
                            pw.Text('CERTIFICATIONS', style: sectionTitle),
                            pw.SizedBox(height: 6),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                // From manual uploads as clickable links (sanitized labels)
                                for (
                                  int i = 0;
                                  i < _certificationUrls.length;
                                  i++
                                )
                                  pw.UrlLink(
                                    destination: _certificationUrls[i],
                                    child: pw.Padding(
                                      padding: const pw.EdgeInsets.only(
                                        bottom: 6,
                                      ),
                                      child: pw.Text(
                                        '- ' +
                                            sanitizeText(
                                              (_certificationNames.length > i
                                                  ? _certificationNames[i]
                                                  : _certName(
                                                      _certificationUrls[i],
                                                    )),
                                            ),
                                        style: bodyStyle.copyWith(
                                          color: purple,
                                        ),
                                      ),
                                    ),
                                  ),
                                // From AI
                                for (final c in ai.certifications)
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                      bottom: 6,
                                    ),
                                    child: pw.Text(
                                      '- ' + sanitizeText(c),
                                      style: bodyStyle,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Vertical divider between columns
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 12),
                      child: pw.Container(width: 1, height: 380, color: purple),
                    ),

                    // Right column
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('EDUCATION', style: sectionTitle),
                          pw.Divider(color: purple, thickness: 0.5),
                          pw.SizedBox(height: 6),
                          if (_aiJson != null && _aiJson!.isNotEmpty)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                for (final e
                                    in ((_aiJson!['education'] as List?) ?? []))
                                  if (e is Map<String, dynamic>)
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          sanitizeText(_cleanText(e['degree'])),
                                          style: pw.TextStyle(
                                            fontSize: 13,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                        pw.Text(
                                          sanitizeText(
                                            '${_cleanText(e['institute'])} — ${_cleanText(e['year'])}',
                                          ),
                                          style: const pw.TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        pw.SizedBox(height: 6),
                                      ],
                                    ),
                              ],
                            )
                          else if (ai.education.isNotEmpty)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                for (final l in _linesFrom(ai.education))
                                  pw.Text(
                                    '- ' + sanitizeText(l),
                                    style: bodyStyle,
                                  ),
                              ],
                            )
                          else
                            pw.Text(
                              [
                                if (degree.isNotEmpty) degree,
                                if (institute.isNotEmpty) institute,
                                if (eduStart.isNotEmpty || eduEnd.isNotEmpty)
                                  '($eduStart – $eduEnd)',
                              ].where((e) => e.trim().isNotEmpty).join(' \n '),
                              style: bodyStyle,
                            ),
                          pw.SizedBox(height: 14),

                          pw.Text('EXPERIENCE', style: sectionTitle),
                          pw.Divider(color: purple, thickness: 0.5),
                          pw.SizedBox(height: 6),
                          if (_aiJson != null && _aiJson!.isNotEmpty)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                for (final e
                                    in ((_aiJson!['experience'] as List?) ??
                                        []))
                                  if (e is Map<String, dynamic>)
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          sanitizeText(
                                            '${_cleanText(e['title'])} — ${_cleanText(e['company'])}',
                                          ),
                                          style: pw.TextStyle(
                                            fontSize: 13,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                        pw.Text(
                                          sanitizeText(_cleanText(e['date'])),
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            color: pdfc.PdfColors.grey700,
                                          ),
                                        ),
                                        pw.SizedBox(height: 4),
                                        pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            for (final r
                                                in ((e['responsibilities']
                                                        as List?) ??
                                                    []))
                                              pw.Padding(
                                                padding:
                                                    const pw.EdgeInsets.only(
                                                      bottom: 2,
                                                    ),
                                                child: pw.Text(
                                                  '- ' +
                                                      sanitizeText(
                                                        _cleanText(r),
                                                      ),
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        pw.SizedBox(height: 10),
                                      ],
                                    ),
                              ],
                            )
                          else ...[
                            pw.Text(
                              [
                                if (jobTitle.isNotEmpty &&
                                    companyName.isNotEmpty)
                                  '$jobTitle – $companyName',
                                if (startDate.isNotEmpty || endDate.isNotEmpty)
                                  '($startDate – $endDate)',
                              ].where((e) => e.trim().isNotEmpty).join(' '),
                              style: bodyStyle.copyWith(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            if (responsibilities.trim().isNotEmpty) ...[
                              pw.SizedBox(height: 4),
                              pw.Bullet(
                                text: responsibilities,
                                style: bodyStyle,
                                bulletColor: purple,
                              ),
                            ],
                          ],
                          pw.SizedBox(height: 14),

                          // Contact section removed; it's rendered in the header now
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'AI_Resume.pdf');
  }

  // Saves a simple PDF containing the full AI-generated resume text
  Future<void> _savePlainTextPdf(String text) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(text, style: const pw.TextStyle(fontSize: 12, height: 1.35)),
        ],
      ),
    );
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'AI_Resume.pdf');
  }

  // Utility to stringify JSON for preview fallback
  String _stringFromJson(Map<String, dynamic> json) {
    final summary = (json['summary'] ?? '').toString();
    final List skills = (json['skills'] as List?) ?? [];
    final List certs = (json['certifications'] as List?) ?? [];
    final List edu = (json['education'] as List?) ?? [];
    final List exp = (json['experience'] as List?) ?? [];
    final sb = StringBuffer();
    if (summary.isNotEmpty) sb.writeln(summary);
    if (skills.isNotEmpty) sb.writeln('\nSkills: ' + skills.join(', '));
    if (certs.isNotEmpty) sb.writeln('\nCertifications: ' + certs.join(', '));
    if (edu.isNotEmpty)
      sb.writeln('\nEducation: ' + edu.map((e) => e.toString()).join(' | '));
    if (exp.isNotEmpty)
      sb.writeln('\nExperience: ' + exp.map((e) => e.toString()).join(' | '));
    return sb.toString();
  }

  /// Navigates back to the previous screen
  void _navigateBack() {
    Navigator.of(context).pop();
  }

  /// Handles step navigation by tapping on progress circles
  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  /// Handles headshot picking and upload to Cloudinary (resume-only)
  Future<void> _handleImageUpload() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;

      setState(() {
        _headshotLocalPath = picked.path;
        _isUploadingHeadshot = true;
      });

      final cloud = CloudinaryService();
      final String fileName =
          'resume_headshot_${DateTime.now().millisecondsSinceEpoch}';
      final String url = await cloud.uploadCustomImage(
        imagePath: picked.path,
        folder: 'resume_headshots',
        fileName: fileName,
      );

      if (!mounted) return;
      setState(() {
        _headshotUrl = url;
        _isUploadingHeadshot = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isUploadingHeadshot = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload image. Please try again.'),
          backgroundColor: Color(0xFF8A2BE2),
        ),
      );
    }
  }

  /// Handles date picking for start date
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  /// Handles date picking for end date
  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  /// Selects start date for education
  Future<void> _selectEducationStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _educationStartDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  /// Selects end date for education
  Future<void> _selectEducationEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _educationEndDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  /// Handles adding another job
  void _handleAddJob() {
    setState(() {
      _workExperiences.add(WorkExperienceEntry());
    });
  }

  /// Shows skills selection dialog
  Future<void> _showSkillsDialog() async {
    final List<String> availableSkills = [
      'JavaScript',
      'Python',
      'React',
      'Flutter',
      'Node.js',
      'Java',
      'C++',
      'Swift',
      'Kotlin',
      'Dart',
      'HTML/CSS',
      'SQL',
      'Git',
      'AWS',
      'Docker',
      'Machine Learning',
      'Data Analysis',
      'Project Management',
      'UI/UX Design',
      'Agile/Scrum',
    ];
    final List<String> tempSelected = List<String>.from(_selectedSkills);

    final List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          final TextEditingController manualController =
              TextEditingController();
          return AlertDialog(
            title: const Text(
              'Select Skills',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableSkills.length,
                      itemBuilder: (context, index) {
                        final skill = availableSkills[index];
                        final isSelected = tempSelected.contains(skill);

                        return CheckboxListTile(
                          title: Text(
                            skill,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (!tempSelected.contains(skill)) {
                                  tempSelected.add(skill);
                                }
                              } else {
                                tempSelected.remove(skill);
                              }
                            });
                          },
                          activeColor: const Color(0xFF8A2BE2),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: manualController,
                          decoration: const InputDecoration(
                            hintText: 'Add another skill',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final String value = manualController.text.trim();
                          if (value.isNotEmpty &&
                              !tempSelected.contains(value)) {
                            setState(() {
                              tempSelected.add(value);
                              manualController.clear();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8A2BE2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(tempSelected);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2BE2),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ],
          );
        },
      ),
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        _selectedSkills
          ..clear()
          ..addAll(result);
      });
    }
  }

  /// Handles file upload for certifications (PDF/DOC/DOCX up to 5MB each)
  Future<void> _uploadCertifications() async {
    try {
      final fp.FilePickerResult? result = await fp.FilePicker.platform
          .pickFiles(
            allowMultiple: true,
            type: fp.FileType.custom,
            allowedExtensions: const ['pdf', 'doc', 'docx'],
            withData: true,
          );
      if (result == null || result.files.isEmpty) return;

      setState(() => _isUploadingCerts = true);

      final cloud = CloudinaryService();
      for (final file in result.files) {
        final int sizeBytes = file.size;
        // 5 MB limit
        if (sizeBytes > 5 * 1024 * 1024) {
          continue; // Skip oversized
        }
        final String? path = file.path;
        if (path == null) continue;

        final String fileName =
            'cert_${DateTime.now().millisecondsSinceEpoch}_${file.name}';
        final String url = await cloud.uploadCustomImage(
          imagePath: path,
          folder: 'certifications',
          fileName: fileName,
        );
        _certificationUrls.add(url);
        _certificationNames.add(file.name);
      }

      if (!mounted) return;
      setState(() => _isUploadingCerts = false);

      if (_certificationUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No valid files uploaded. Max 5MB, PDF/DOC/DOCX.'),
            backgroundColor: Color(0xFF8A2BE2),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isUploadingCerts = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload certifications. Please try again.'),
          backgroundColor: Color(0xFF8A2BE2),
        ),
      );
    }
  }

  /// Handles sharing the resume
  Future<void> _shareResume() async {
    // Generate resume content from form data if AI generation failed or wasn't used
    String resumeContent = _generatedResume ?? _collectResumeData();

    if (resumeContent.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in some basic information first.'),
          backgroundColor: Color(0xFF8A2BE2),
        ),
      );
      return;
    }
    await _savePdf(resumeContent);
  }

  /// Handles editing the resume
  Future<void> _editResume() async {
    final TextEditingController controller = TextEditingController(
      text: _generatedResume ?? '',
    );
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Edit Generated Resume',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: TextField(
              controller: controller,
              maxLines: 12,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Edit your resume text here',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A2BE2),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null && mounted) {
      setState(() => _generatedResume = result);
    }
  }

  /// Handles regenerating the resume
  Future<void> _regenerateResume() async {
    setState(() => _loading = true);
    try {
      final resumeText = _collectResumeData();
      final jobDescription =
          'Example job description here\nPreferred Resume Style: ' +
          (_selectedStyle ?? 'Professional');
      final aiResume = await OpenAiService.generateResume(
        resumeText,
        jobDescription,
        _selectedStyle ?? 'Professional',
      );
      setState(() => _generatedResume = aiResume);
    } catch (e) {
      if (mounted) {
        // Check if it's an API key error
        if (e.toString().contains('401') || e.toString().contains('API key')) {
          _showApiKeyDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error generating resume: $e'),
              backgroundColor: const Color(0xFF8A2BE2),
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Shows API key setup dialog
  void _showApiKeyDialog() {
    final TextEditingController keyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('OpenAI API Key Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'To use AI resume generation, you need to set up your OpenAI API key.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'sk-...',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            const Text(
              'You can get your API key from: https://platform.openai.com/account/api-keys',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (keyController.text.trim().isNotEmpty) {
                OpenAiService.setApiKey(keyController.text.trim());
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('API key set successfully!'),
                    backgroundColor: Color(0xFF8A2BE2),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Handles downloading the resume as PDF
  Future<void> _downloadPdf() async {
    // Prefer structured JSON if we have it; else use text or fallback to form
    String resumeContent = _collectResumeData();
    if (_aiJson != null && _aiJson!.isNotEmpty) {
      // Build content from structured JSON inside _savePdf directly
      resumeContent = _stringFromJson(_aiJson!);
    } else if (_generatedResume != null &&
        _generatedResume!.trim().isNotEmpty) {
      resumeContent = _generatedResume!;
    }

    if (resumeContent.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in some basic information first.'),
          backgroundColor: Color(0xFF8A2BE2),
        ),
      );
      return;
    }
    await _savePdf(resumeContent);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
              // Header with back button and title
              _buildHeader(),
              const SizedBox(height: 20),
              // Progress indicator
              _buildProgressIndicator(),
              const SizedBox(height: 40),
              // Main content using IndexedStack
              IndexedStack(
                index: _currentStep,
                children: [
                  _buildBasicInformationStep(),
                  _buildStep2(),
                  _buildStep3(),
                  _buildStep4(),
                  _buildStyleStep(), // Step 5: Style & Tone
                  _buildPreviewStep(), // Step 6: Preview & actions
                ],
              ),

              // Navigation buttons outside the frame
              _buildNavigationButtons(),
              const SizedBox(height: 40), // Add bottom padding for scroll
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildExperienceCard({
    required String title,
    required TextEditingController jobTitleController,
    required TextEditingController companyController,
    required TextEditingController startController,
    required TextEditingController endController,
    required TextEditingController respController,
    required VoidCallback onPickStart,
    required VoidCallback onPickEnd,
    bool showDelete = false,
    VoidCallback? onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8A2BE2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildFieldLabel('Job Title'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: jobTitleController,
            hintText: 'Enter your title here',
            height: 54,
            borderRadius: 8,
            borderWidth: 1,
            fillColor: Colors.white,
            borderColor: const Color(0xFFE1E1E1),
          ),
          const SizedBox(height: 12),
          _buildFieldLabel('Company Name'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: companyController,
            hintText: 'Enter company name here',
            height: 54,
            borderRadius: 8,
            borderWidth: 1,
            fillColor: Colors.white,
            borderColor: const Color(0xFFE1E1E1),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Start Date'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: startController,
                      hintText: 'Select start date',
                      readOnly: true,
                      onTap: onPickStart,
                      height: 54,
                      borderRadius: 8,
                      borderWidth: 1,
                      fillColor: Colors.white,
                      borderColor: const Color(0xFFE1E1E1),
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF8A2BE2),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('End Date'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: endController,
                      hintText: 'Select end date',
                      readOnly: true,
                      onTap: onPickEnd,
                      height: 54,
                      borderRadius: 8,
                      borderWidth: 1,
                      fillColor: Colors.white,
                      borderColor: const Color(0xFFE1E1E1),
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF8A2BE2),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFieldLabel('Responsibilities'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: respController,
            hintText: 'Enter your responsibilities here',
            maxLines: 2,
            height: 60,
            borderRadius: 8,
            borderWidth: 1,
            fillColor: Colors.white,
            borderColor: const Color(0xFFE1E1E1),
          ),
          if (showDelete)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the header with back button and title
  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        // Back button
        GestureDetector(
          onTap: _navigateBack,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF8A2BE2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.keyboard_double_arrow_left,
              color: Color(0xFF8A2BE2),
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Title
        const Expanded(
          child: Text(
            'AI Resume & Cover Letter',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 50), // Balance the back button
      ],
    ),
  );

  /// Builds the progress indicator
  Widget _buildProgressIndicator() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),

    child: Column(
      children: [
        const SizedBox(height: 16),
        // Progress circles and counter
        Row(
          children: [
            // Progress circles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalSteps, (index) {
                final isActive = index == _currentStep;

                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => _goToStep(index),
                      child: Container(
                        width: 42,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF8A2BE2)
                              : const Color(0xFFE1E1E1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Add spacing between circles (except for the last one)
                    if (index < _totalSteps - 1) const SizedBox(width: 12),
                  ],
                );
              }),
            ),
            const SizedBox(width: 16),
            // Step counter
            Text(
              '${_currentStep + 1} of $_totalSteps',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8A2BE2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Progress bar under the numbers
        Container(
          height: 4,
          width: (_totalSteps - 1) * 44, // Match the width of the circles row
          decoration: BoxDecoration(
            color: const Color(0xFFE1E1E1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: (_currentStep + 1) / _totalSteps,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8A2BE2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  /// Builds the Basic Information step (Step 1)
  Widget _buildBasicInformationStep() => Center(
    child: Container(
      width: 340,
      height: 540,

      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8A2BE2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Basic Information',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle
          const Text(
            'Let\'s start with the personal Info.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 10),
          // Image upload / preview
          Center(
            child: GestureDetector(
              onTap: _isUploadingHeadshot ? null : _handleImageUpload,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE1E1E1),
                        width: 1,
                      ),
                      image: _headshotLocalPath != null
                          ? DecorationImage(
                              image: FileImage(File(_headshotLocalPath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _headshotLocalPath == null
                        ? const Center(
                            child: Text(
                              'Upload Image',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF999999),
                              ),
                            ),
                          )
                        : null,
                  ),
                  if (_isUploadingHeadshot)
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              Color(0xFF8A2BE2),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Full Name field
          _buildFieldLabel('Full Name'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _fullNameController,
            hintText: 'Enter your name here',
            width: double.infinity,
            height: 54,
            borderRadius: 8,
            borderWidth: 1,
            fillColor: Colors.white,
            borderColor: const Color(0xFFE1E1E1),
          ),
          const SizedBox(height: 16),
          // Phone Number field
          _buildFieldLabel('Phone Number'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _phoneNumberController,
                  hintText: 'Enter your number here',
                  keyboardType: TextInputType.phone,
                  height: 54,
                  borderRadius: 8,
                  borderWidth: 1,
                  fillColor: Colors.white,
                  borderColor: const Color(0xFFE1E1E1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Your Links field
          _buildFieldLabel('Your Links'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _linksController,
            hintText: 'Enter your links here',
            keyboardType: TextInputType.url,
            width: double.infinity,
            height: 54,
            borderRadius: 8,
            borderWidth: 1,
            fillColor: Colors.white,
            borderColor: const Color(0xFFE1E1E1),
          ),
        ],
      ),
    ),
  );

  /// Builds a field label
  Widget _buildFieldLabel(String label) => Text(
    label,
    style: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF000000),
    ),
  );

  /// Builds navigation buttons outside the frame
  Widget _buildNavigationButtons() {
    // Show Generate Resume on Style & Tone step (index 4)
    if (_currentStep == 4) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _loading
                ? null
                : () async {
                    setState(() => _loading = true);
                    final resumeText = _collectResumeData();
                    final jobDescription = '';
                    // Try structured JSON first
                    final Map<String, dynamic> json =
                        await OpenAiService.generateStructuredResume(
                          resumeText,
                          jobDescription,
                          _selectedStyle ?? 'Professional',
                        );
                    String aiText = '';
                    if (json.isNotEmpty) {
                      _aiJson = json;
                      aiText = _stringFromJson(json);
                    } else {
                      // Fallback to legacy text generation
                      aiText = await OpenAiService.generateResume(
                        resumeText,
                        jobDescription,
                        _selectedStyle ?? 'Professional',
                      );
                    }
                    if (!mounted) return;
                    setState(() {
                      _loading = false;
                      _generatedResume = aiText.isNotEmpty
                          ? aiText
                          : resumeText;
                      _currentStep = 5; // Show visual preview step
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A2BE2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              _loading ? 'Generating...' : 'Generate Resume',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    // No preview step here anymore

    // For other steps, show the regular Next/Done button
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (_currentStep < _totalSteps - 1) {
              setState(() {
                _currentStep++;
              });
            } else {
              Navigator.of(context).pop(); // Done → back to assistant
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8A2BE2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: Text(
            _currentStep == _totalSteps - 1 ? 'Done' : 'Next',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the Work Experience step (Step 2)
  Widget _buildStep2() => Center(
    child: Container(
      width: 336,
      height: 515,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8A2BE2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Work Experience',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle
          const Text(
            'Add experience — AI enhances it.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 20),
          // Multiple experience blocks
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Primary block (existing controllers)
                  _buildExperienceCard(
                    title: 'Experience 1',
                    jobTitleController: _jobTitleController,
                    companyController: _companyNameController,
                    startController: _startDateController,
                    endController: _endDateController,
                    respController: _responsibilitiesController,
                    onPickStart: _selectStartDate,
                    onPickEnd: _selectEndDate,
                    showDelete: false,
                  ),
                  // Extra blocks
                  ..._workExperiences.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final exp = entry.value;
                    return _buildExperienceCard(
                      title: 'Experience ${idx + 2}',
                      jobTitleController: exp.jobTitle,
                      companyController: exp.company,
                      startController: exp.startDate,
                      endController: exp.endDate,
                      respController: exp.responsibilities,
                      onPickStart: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          exp.startDate.text = '${d.day}/${d.month}/${d.year}';
                        }
                      },
                      onPickEnd: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          exp.endDate.text = '${d.day}/${d.month}/${d.year}';
                        }
                      },
                      showDelete: true,
                      onDelete: () {
                        setState(() {
                          _workExperiences.removeAt(idx);
                        });
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _handleAddJob,
                    icon: const Icon(Icons.add, color: Color(0xFF8A2BE2)),
                    label: const Text('Add Experience'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  /// Builds the Education step (Step 3)
  Widget _buildStep3() => Center(
    child: Container(
      width: 336,
      height: 430,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8A2BE2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Education',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle
          const Text(
            'Share education — AI improves it.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 20),
          // Dynamic education list
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._educations.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final edu = entry.value;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF8A2BE2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Education ${idx + 1}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (_educations.length > 1)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      setState(() => _educations.removeAt(idx)),
                                ),
                            ],
                          ),
                          _buildFieldLabel('Degree Title'),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: edu.degree,
                            hintText: 'Enter your title here',
                            height: 54,
                            borderRadius: 8,
                            borderWidth: 1,
                            fillColor: Colors.white,
                            borderColor: const Color(0xFFE1E1E1),
                          ),
                          const SizedBox(height: 12),
                          _buildFieldLabel('Institute Name'),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: edu.institute,
                            hintText: 'Enter institute name here',
                            height: 54,
                            borderRadius: 8,
                            borderWidth: 1,
                            fillColor: Colors.white,
                            borderColor: const Color(0xFFE1E1E1),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('Start Date'),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      controller: edu.startDate,
                                      hintText: 'Select start date',
                                      readOnly: true,
                                      onTap: () async {
                                        final d = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1990),
                                          lastDate: DateTime(2100),
                                        );
                                        if (d != null) {
                                          edu.startDate.text =
                                              '${d.day}/${d.month}/${d.year}';
                                        }
                                      },
                                      height: 54,
                                      borderRadius: 8,
                                      borderWidth: 1,
                                      fillColor: Colors.white,
                                      borderColor: const Color(0xFFE1E1E1),
                                      suffixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: Color(0xFF8A2BE2),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('End Date'),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      controller: edu.endDate,
                                      hintText: 'Select end date',
                                      readOnly: true,
                                      onTap: () async {
                                        final d = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1990),
                                          lastDate: DateTime(2100),
                                        );
                                        if (d != null) {
                                          edu.endDate.text =
                                              '${d.day}/${d.month}/${d.year}';
                                        }
                                      },
                                      height: 54,
                                      borderRadius: 8,
                                      borderWidth: 1,
                                      fillColor: Colors.white,
                                      borderColor: const Color(0xFFE1E1E1),
                                      suffixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: Color(0xFF8A2BE2),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _educations.add(EducationEntry())),
                    icon: const Icon(Icons.add, color: Color(0xFF8A2BE2)),
                    label: const Text('Add Education'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  /// Builds the Skills & Achievements step (Step 4)
  Widget _buildStep4() => Center(
    child: Container(
      width: 336,
      height: 430,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8A2BE2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Skills & Achievements',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle
          const Text(
            'Showcase your skills and wins.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 20),
          // Skills List field
          _buildFieldLabel('Skills List'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showSkillsDialog,
            child: Container(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedSkills.isEmpty
                          ? 'Select your skills here'
                          : _selectedSkills.join(', '),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: _selectedSkills.isEmpty
                            ? const Color(0xFF999999)
                            : const Color(0xFF000000),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF8A2BE2),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Upload Certifications section
          _buildFieldLabel('Upload Certifications'),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: _uploadCertifications,
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isUploadingCerts)
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Color(0xFF8A2BE2)),
                      ),
                    )
                  else
                    const Icon(
                      Icons.upload_file,
                      color: Color(0xFF000000),
                      size: 32,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    _isUploadingCerts
                        ? 'Uploading...'
                        : 'Upload Certifications',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _certificationNames.isEmpty
                        ? 'Microsoft Word or PDF only (5MB)'
                        : '${_certificationNames.length} file(s) selected',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  /// Builds Step 5: Style & Tone selector
  Widget _buildStyleStep() => Center(
    child: Container(
      width: 336,
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8A2BE2), width: 1),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Style & Tone header
            const Text(
              'Style & Tone',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Decide your professional style.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Style',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedStyle,
                  hint: const Text(
                    'Select your style here',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                  ),
                  items: _styleOptions
                      .map(
                        (s) => DropdownMenuItem<String>(
                          value: s,
                          child: Text(
                            s,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedStyle = val),
                  isExpanded: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );

  /// Builds Step 6: Preview & actions
  Widget _buildPreviewStep() => Center(
    child: Container(
      width: 336,
      height: 600,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF8A2BE2), width: 1),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with dynamic name and actions + optional headshot
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_headshotLocalPath != null) ...[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: FileImage(File(_headshotLocalPath!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    _fullNameController.text.isNotEmpty
                        ? _fullNameController.text
                        : 'Your Name',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8A2BE2),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _shareResume,
                  child: const Icon(
                    Icons.share,
                    color: Color(0xFF000000),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _editResume,
                  child: const Icon(
                    Icons.edit,
                    color: Color(0xFF000000),
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Contact and links from Step 1
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Color(0xFF000000)),
                const SizedBox(width: 8),
                Text(
                  _phoneNumberController.text.isNotEmpty
                      ? _phoneNumberController.text
                      : 'Add phone in Step 1',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.link, size: 16, color: Color(0xFF000000)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _linksController.text.isNotEmpty
                        ? _linksController.text
                        : 'Add links in Step 1',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // AI generated resume text preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F7FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE1D9FF)),
              ),
              child: Text(
                (_generatedResume != null &&
                        _generatedResume!.trim().isNotEmpty)
                    ? _generatedResume!
                    : 'Your AI-generated resume will appear here after you tap Regenerate.',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  height: 1.4,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            if (_jobTitleController.text.isNotEmpty ||
                _companyNameController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildResumeSection(
                'Work Experience',
                '${_jobTitleController.text} at ${_companyNameController.text}\nFrom ${_startDateController.text} to ${_endDateController.text}\nResponsibilities: ${_responsibilitiesController.text}',
              ),
            ],
            if (_degreeTitleController.text.isNotEmpty ||
                _instituteNameController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildResumeSection(
                'Education',
                '${_degreeTitleController.text} at ${_instituteNameController.text}\nFrom ${_educationStartDateController.text} to ${_educationEndDateController.text}',
              ),
            ],
            if (_selectedSkills.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildResumeSection('Skills', _selectedSkills.join(' | ')),
            ],
            if (_certificationNames.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildResumeSection(
                'Certifications',
                '• ' + _certificationNames.join('\n• '),
              ),
            ],
            const SizedBox(height: 16),

            // Actions: Regenerate and Download PDF
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _regenerateResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2BE2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(_loading ? 'Generating...' : 'Regenerate'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _downloadPdf,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2BE2),
                  foregroundColor: const Color(0xFFF3EAFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text('Download PDF'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );

  /// Builds a resume section with title and content
  Widget _buildResumeSection(String title, String content) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8A2BE2),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        content,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Color(0xFF000000),
          height: 1.4,
        ),
      ),
    ],
  );
}

/// Minimal parser to extract sections from AI resume text
class _AiParsedResume {
  final String summary;
  final List<String> skills;
  final List<String> certifications;
  final String experience;
  final String education;
  const _AiParsedResume({
    required this.summary,
    required this.skills,
    required this.certifications,
    required this.experience,
    required this.education,
  });
}

_AiParsedResume _extractAiSections(String text) {
  final String cleaned = text.replaceAll('\r', '').trim();
  if (cleaned.isEmpty) {
    return const _AiParsedResume(
      summary: '',
      skills: [],
      certifications: [],
      experience: '',
      education: '',
    );
  }

  String takeBetween(String start, List<String> ends) {
    final lower = cleaned.toLowerCase();
    final sIdx = lower.indexOf(start.toLowerCase());
    if (sIdx == -1) return '';
    int eIdx = cleaned.length;
    for (final e in ends) {
      final idx = lower.indexOf(e.toLowerCase(), sIdx + start.length);
      if (idx != -1 && idx < eIdx) eIdx = idx;
    }
    return cleaned.substring(sIdx + start.length, eIdx).trim();
  }

  String summary = '';
  // Common headings
  final headings = ['summary', 'professional summary', 'profile', 'objective'];
  for (final h in headings) {
    summary = takeBetween(h, [
      'skills',
      'experience',
      'work experience',
      'education',
      'academic',
    ]);
    if (summary.isNotEmpty) break;
  }
  if (summary.isEmpty) {
    // fallback: first paragraph
    summary = cleaned.split('\n\n').first.trim();
  }

  // Skills
  String skillsBlock = takeBetween('skills', [
    'experience',
    'work experience',
    'education',
    'projects',
  ]);
  final List<String> skills = skillsBlock
      .split(RegExp(r'[\n,•\-]'))
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty && s.length < 40)
      .toSet()
      .toList();

  // Experience
  String experience = takeBetween('experience', [
    'education',
    'academic',
    'projects',
    'certifications',
  ]);
  if (experience.isEmpty) {
    experience = takeBetween('work experience', [
      'education',
      'academic',
      'projects',
      'certifications',
    ]);
  }

  // Education
  String education = takeBetween('education', [
    'experience',
    'work experience',
    'skills',
    'projects',
  ]);

  return _AiParsedResume(
    summary: summary,
    skills: skills,
    certifications: const [],
    experience: experience,
    education: education,
  );
}

_AiParsedResume _extractFromJson(Map<String, dynamic> json) {
  String summary = (json['summary'] ?? '').toString().trim();
  if (summary.length > 400) summary = summary.substring(0, 400) + '...';

  final List<String> skills = ((json['skills'] as List?) ?? [])
      .map((e) => e.toString().trim())
      .where((e) => e.isNotEmpty)
      .toList();

  final List<String> certs = ((json['certifications'] as List?) ?? [])
      .map((e) => e.toString().trim())
      .where((e) => e.isNotEmpty)
      .toList();

  final List eduList = (json['education'] as List?) ?? [];
  final String education = eduList
      .map((e) {
        final m = e as Map<String, dynamic>;
        final degree = (m['degree'] ?? '').toString();
        final institute = (m['institute'] ?? '').toString();
        final year = (m['year'] ?? '').toString();
        return [
          degree,
          institute,
          year.isNotEmpty ? '($year)' : '',
        ].where((s) => s.trim().isNotEmpty).join(' – ');
      })
      .where((s) => s.trim().isNotEmpty)
      .join('\n');

  final List expList = (json['experience'] as List?) ?? [];
  final String experience = expList
      .map((e) {
        final m = e as Map<String, dynamic>;
        final title = (m['title'] ?? '').toString();
        final company = (m['company'] ?? '').toString();
        final date = (m['date'] ?? '').toString();
        final resp = ((m['responsibilities'] as List?) ?? [])
            .map((r) => '• ' + r.toString())
            .join('\n');
        final header = [
          title,
          company,
          date.isNotEmpty ? '($date)' : '',
        ].where((s) => s.trim().isNotEmpty).join(' – ');
        return [header, resp].where((s) => s.trim().isNotEmpty).join('\n');
      })
      .where((s) => s.trim().isNotEmpty)
      .join('\n\n');

  return _AiParsedResume(
    summary: summary,
    skills: skills,
    certifications: certs,
    experience: experience,
    education: education,
  );
}

String _cleanCert(String urlOrName) {
  if (urlOrName.contains('http')) {
    try {
      final last = urlOrName.split('/').last;
      return last.split('_').last.replaceAll('%20', ' ');
    } catch (_) {
      return urlOrName;
    }
  }
  return urlOrName;
}

String? _extractEmail(String links) {
  final match = RegExp(r"[\w\.-]+@[\w\.-]+\.[A-Za-z]{2,}").firstMatch(links);
  return match?.group(0);
}

String? _extractLinkedIn(String links) {
  final match = RegExp(
    r"https?:\/\/(www\.)?linkedin\.com\/[\w\-/_%]+",
    caseSensitive: false,
  ).firstMatch(links);
  return match?.group(0);
}

String? _extractWebsite(String links) {
  final match = RegExp(
    r"https?:\/\/([\w-]+\.)+[\w-]+(\/[\w\-._~:?#\[\]@!$&'()*+,;=%]*)?",
    caseSensitive: false,
  ).firstMatch(links);
  final url = match?.group(0);
  if (url == null) return null;
  // Prefer non-LinkedIn websites here
  if (url.toLowerCase().contains('linkedin.com')) return null;
  return url;
}

String _cleanAscii(String input) {
  return input
      .replaceAll(RegExp(r'[^\x00-\x7F]'), '')
      .replaceAll('•', '-')
      .trim();
}

// Strict sanitizer: printable ASCII only and remove GPT bullets/dashes
String sanitizeText(String input) {
  return input
      .replaceAll(RegExp(r'[^\x20-\x7E]'), '')
      .replaceAll(RegExp(r'[•▪‣◦●–-]'), '')
      .trim();
}

String _certName(String url) {
  final last = url.split('/').last;
  return last
      .replaceAll(RegExp(r'[_.-]'), ' ')
      .replaceAll('.pdf', '')
      .replaceAll('.docx', '')
      .replaceAll('.doc', '')
      .trim();
}

// Remove markdown artifacts and decorative separators
String _sanitizeInline(String s) {
  return s
      .replaceAll('**', '')
      .replaceAll(RegExp(r'^-\s*', multiLine: true), '')
      .replaceAll(RegExp(r'\n\s*[-–]{2,}\s*\n'), '\n')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

// Convert a blob of AI text into clean bullet lines
List<String> _linesFrom(String s) {
  final cleaned = s.replaceAll('**', '').replaceAll('\r', '');
  final raw = cleaned
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  final List<String> out = [];
  for (final line in raw) {
    String l = line;
    l = l.replaceFirst(RegExp(r'^[•\-–\*]\s*'), '');
    if (l == '---' || l == '--') continue;
    out.add(l);
  }
  // de-duplicate short lines
  return out.toSet().toList();
}

// Merge, sanitize and cap skills for chips
List<String> _mergeSkills(List<String> manual, List<String> fromAi) {
  final List<String> all =
      [
            ...manual,
            ...fromAi
                .expand(
                  (e) => e.split(RegExp(r'[,/|]')),
                ) // split by common separators
                .toList(),
          ]
          .map((s) => s.replaceAll('**', '').trim())
          .where((s) => s.isNotEmpty)
          .toList();

  final seen = <String>{};
  final List<String> unique = [];
  for (final s in all) {
    final key = s.toLowerCase();
    if (seen.add(key)) unique.add(s);
    if (unique.length >= 14) break; // cap chips to keep layout tidy
  }
  return unique;
}

String _cleanText(dynamic v) => v == null
    ? ''
    : v.toString().replaceAll('**', '').replaceAll('\r', '').trim();
