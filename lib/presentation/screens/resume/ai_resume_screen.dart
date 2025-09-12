import 'package:flutter/material.dart';
import 'package:innerexec/presentation/widgets/custom_text_field.dart';

/// AI Resume & Cover Letter screen with multi-step form using IndexedStack
class AiResumeScreen extends StatefulWidget {
  /// Creates a new AI resume screen
  const AiResumeScreen({super.key});

  @override
  State<AiResumeScreen> createState() => _AiResumeScreenState();
}

class _AiResumeScreenState extends State<AiResumeScreen> {
  int _currentStep = 0;
  final int _totalSteps = 5;

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

  // Form controllers for step 3 (Education)
  final _degreeTitleController = TextEditingController();
  final _instituteNameController = TextEditingController();
  final _educationStartDateController = TextEditingController();
  final _educationEndDateController = TextEditingController();

  // Variables for step 4 (Skills & Achievements)
  final List<String> _selectedSkills = [];

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
    _degreeTitleController.dispose();
    _instituteNameController.dispose();
    _educationStartDateController.dispose();
    _educationEndDateController.dispose();
    super.dispose();
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

  /// Handles image upload
  void _handleImageUpload() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image upload feature coming soon!'),
        backgroundColor: Color(0xFF8A2BE2),
      ),
    );
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add multiple jobs feature coming soon!'),
        backgroundColor: Color(0xFF8A2BE2),
      ),
    );
  }

  /// Shows skills selection dialog
  void _showSkillsDialog() {
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

    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableSkills.length,
                itemBuilder: (context, index) {
                  final skill = availableSkills[index];
                  final isSelected = _selectedSkills.contains(skill);

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
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                    activeColor: const Color(0xFF8A2BE2),
                  );
                },
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
                  setState(() {
                    // Update the main widget state
                  });
                  Navigator.of(context).pop();
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
  }

  /// Handles file upload for certifications
  void _uploadCertifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File upload functionality coming soon!'),
        backgroundColor: Color(0xFF8A2BE2),
      ),
    );
  }

  /// Handles sharing the resume
  void _shareResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        backgroundColor: Color(0xFF8A2BE2),
      ),
    );
  }

  /// Handles editing the resume
  void _editResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality coming soon!'),
        backgroundColor: Color(0xFF8A2BE2),
      ),
    );
  }

  /// Handles regenerating the resume
  void _regenerateResume() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Regenerating resume...'),
        backgroundColor: Color(0xFF8A2BE2),
      ),
    );
  }

  /// Handles downloading the resume as PDF
  void _downloadPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading PDF...'),
        backgroundColor: Color(0xFF8A2BE2),
      ),
    );
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
                  _buildStep2(), // Placeholder for step 2
                  _buildStep3(), // Placeholder for step 3
                  _buildStep4(), // Placeholder for step 4
                  _buildStep5(), // Placeholder for step 5
                ],
              ),
              const SizedBox(height: 20),
              // Navigation buttons outside the frame
              _buildNavigationButtons(),
              const SizedBox(height: 40), // Add bottom padding for scroll
            ],
          ),
        ),
      ),
    ),
  );

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
                        width: 32,
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
      height: 508,
      margin: const EdgeInsets.only(top: 40),
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
              fontFamily: 'Poppins',
              fontSize: 20,
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
          // Image upload
          Center(
            child: GestureDetector(
              onTap: _handleImageUpload,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
                ),
                child: const Center(
                  child: Text(
                    'Upload Image',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
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
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  // Handle add phone number
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE1E1E1),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF8A2BE2),
                    size: 20,
                  ),
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
    // For the final step (Step 5), show different buttons
    if (_currentStep == _totalSteps - 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Regenerate button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _regenerateResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2BE2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Regenerate',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Download PDF button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _downloadPdf,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2BE2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Download Pdf',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // For other steps, show the regular Next button
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
          child: const Text(
            'Next',
            style: TextStyle(
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
      height: 496,
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
          // Job Title field with add button
          Row(
            children: [
              Expanded(child: _buildFieldLabel('Job Title')),
              GestureDetector(
                onTap: _handleAddJob,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A2BE2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _jobTitleController,
            hintText: 'Enter your title here',
            width: double.infinity,
            height: 54,
            borderRadius: 8,
            borderWidth: 1,
            fillColor: Colors.white,
            borderColor: const Color(0xFFE1E1E1),
          ),
          const SizedBox(height: 16),
          // Company Name field
          _buildFieldLabel('Company Name'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _companyNameController,
            hintText: 'Enter company name here',
            width: double.infinity,
            height: 54,
            borderRadius: 8,
            borderWidth: 1,
            fillColor: Colors.white,
            borderColor: const Color(0xFFE1E1E1),
          ),
          const SizedBox(height: 16),
          // Date fields in a row
          Row(
            children: [
              // Start Date field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Start Date'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectStartDate,
                      child: CustomTextField(
                        controller: _startDateController,
                        hintText: 'Select start date',
                        readOnly: true,
                        width: 148,
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
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // End Date field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('End Date'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectEndDate,
                      child: CustomTextField(
                        controller: _endDateController,
                        hintText: 'Select end date',
                        readOnly: true,
                        width: 148,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Responsibilities field
          _buildFieldLabel('Responsibilities'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _responsibilitiesController,
            hintText: 'Enter your responsibilities here',
            maxLines: 2,
            width: double.infinity,
            height: 60,
            borderRadius: 8,
            borderWidth: 1,
            fillColor: Colors.white,
            borderColor: const Color(0xFFE1E1E1),
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
          // Degree Title field with add button
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Degree Title'),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _degreeTitleController,
                      hintText: 'Enter your title here',
                      height: 54,
                      borderRadius: 8,
                      borderWidth: 1,
                      fillColor: Colors.white,
                      borderColor: const Color(0xFFE1E1E1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  // Handle add degree
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE1E1E1),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF8A2BE2),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Institute Name field
          _buildFieldLabel('Institute Name'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _instituteNameController,
            hintText: 'Enter institute name here',
            width: double.infinity,
            height: 54,
            borderRadius: 8,
            borderWidth: 1,
            fillColor: Colors.white,
            borderColor: const Color(0xFFE1E1E1),
          ),
          const SizedBox(height: 16),
          // Date fields in a row
          Row(
            children: [
              // Start Date field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Start Date'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectEducationStartDate,
                      child: CustomTextField(
                        controller: _educationStartDateController,
                        hintText: 'Select start date',
                        readOnly: true,
                        width: 148,
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
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // End Date field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('End Date'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _selectEducationEndDate,
                      child: CustomTextField(
                        controller: _educationEndDateController,
                        hintText: 'Select end date',
                        readOnly: true,
                        width: 148,
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
                    ),
                  ],
                ),
              ),
            ],
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
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _uploadCertifications,
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE1E1E1), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.upload_file,
                    color: Color(0xFF000000),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload Certifications',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Microsoft Word or PDF only (5MB)',
                    style: TextStyle(
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

  /// Builds the Resume Review step (Step 5)
  Widget _buildStep5() => Center(
    child: Container(
      width: 336,
      height: 600, // Increased height to accommodate full resume
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
            // Header with name and action icons
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'JOHN DOE',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
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
            // Contact Information
            Row(
              children: [
                const Icon(Icons.phone, color: Color(0xFF000000), size: 16),
                const SizedBox(width: 8),
                const Text(
                  '(123) 456-7890',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.link, color: Color(0xFF000000), size: 16),
                const SizedBox(width: 8),
                const Text(
                  'linkedin.com/in/johndoe',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Professional Summary
            _buildResumeSection(
              'Professional Summary',
              'Results-driven marketing professional with 5+ years of experience creating high-impact campaigns and driving measurable growth. Skilled in digital strategy, brand positioning, and data-driven decision-making.',
            ),
            const SizedBox(height: 16),
            // Work Experience
            _buildResumeSection(
              'Work Experience',
              '• Increased social media engagement by 65% through targeted content strategy.\n'
                  '• Managed \$500K annual ad budget, optimizing ROI by 28%.\n'
                  '• Led a team of 5 marketers, delivering 12+ successful product launches.\n'
                  '• Implemented SEO strategies that improved organic traffic by 40%.\n'
                  '• Designed and executed email campaigns with a 22% conversion rate.',
            ),
            const SizedBox(height: 16),
            // Education
            _buildResumeSection(
              'Education',
              'B.A. in Marketing - New York University (2012 - 2016)',
            ),
            const SizedBox(height: 16),
            // Skills
            _buildResumeSection(
              'Skills',
              'Digital Marketing | SEO & SEM | Google Analytics | Campaign Management | Leadership',
            ),
            const SizedBox(height: 16),
            // Achievements
            _buildResumeSection(
              'Achievements',
              '• Winner, 2021 National Marketing Innovation Award',
            ),
            const SizedBox(height: 20),
            // Page indicator
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Pg 1 of 1',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: const Color(0xFF8A2BE2),
                ),
              ),
            ),
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
