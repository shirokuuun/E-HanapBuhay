import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ApplyScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const ApplyScreen({Key? key, required this.job}) : super(key: key);

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  int _currentStep = 0;
  final int _totalSteps = 4;

  // ── Step 1: Contact Info ────────────────────────────────────────────────────
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _emailError;
  String? _locationError;

  // ── Step 2: Resume / Cover Letter ──────────────────────────────────────────
  PlatformFile? _resumeFile;
  PlatformFile? _coverLetterFile;

  String? _resumeError;
  String? _coverLetterError;

  // ── Step 3: Work Experience ─────────────────────────────────────────────────
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  bool _currentlyWorkHere = false;
  DateTime? _workFrom;
  DateTime? _workTo;
  final _workCityController = TextEditingController();
  final _workDescriptionController = TextEditingController();

  String? _jobTitleError;
  String? _workFromError;
  String? _workToError;

  // ── Step 4: Education ───────────────────────────────────────────────────────
  final _educationController = TextEditingController();
  final _eduCityController = TextEditingController();
  final _degreeController = TextEditingController();
  final _majorController = TextEditingController();
  bool _currentlyAttend = false;
  DateTime? _eduFrom;
  DateTime? _eduTo;

  String? _educationError;
  String? _eduFromError;
  String? _eduToError;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _workCityController.dispose();
    _workDescriptionController.dispose();
    _educationController.dispose();
    _eduCityController.dispose();
    _degreeController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  // ── Validation ──────────────────────────────────────────────────────────────

  bool _validateStep1() {
    setState(() {
      _firstNameError = _firstNameController.text.trim().isEmpty
          ? 'First name is required'
          : null;

      _lastNameError = _lastNameController.text.trim().isEmpty
          ? 'Last name is required'
          : null;

      final phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        _phoneError = 'Mobile number is required';
      } else if (!RegExp(r'^[\d\s\+\-\(\)]{7,15}$').hasMatch(phone)) {
        _phoneError = 'Enter a valid phone number';
      } else {
        _phoneError = null;
      }

      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailError = 'Email address is required';
      } else if (!RegExp(r'^[\w\.\+\-]+@[\w\-]+\.\w{2,}$').hasMatch(email)) {
        _emailError = 'Enter a valid email address';
      } else {
        _emailError = null;
      }

      _locationError = _locationController.text.trim().isEmpty
          ? 'Location is required'
          : null;
    });

    return _firstNameError == null &&
        _lastNameError == null &&
        _phoneError == null &&
        _emailError == null &&
        _locationError == null;
  }

  bool _validateStep2() {
    setState(() {
      _resumeError =
          _resumeFile == null ? 'Please upload your resume' : null;
      // Cover letter is optional — no validation required
      _coverLetterError = null;
    });
    return _resumeError == null;
  }

  bool _validateStep3() {
    setState(() {
      _jobTitleError = _jobTitleController.text.trim().isEmpty
          ? 'Job title is required'
          : null;

      _workFromError = _workFrom == null ? 'Start date is required' : null;

      if (!_currentlyWorkHere) {
        if (_workTo == null) {
          _workToError = 'End date is required';
        } else if (_workFrom != null && !_workTo!.isAfter(_workFrom!)) {
          _workToError = 'End date must be after start date';
        } else {
          _workToError = null;
        }
      } else {
        _workToError = null;
      }
    });

    return _jobTitleError == null &&
        _workFromError == null &&
        _workToError == null;
  }

  bool _validateStep4() {
    setState(() {
      _educationError = _educationController.text.trim().isEmpty
          ? 'School/University is required'
          : null;

      _eduFromError = _eduFrom == null ? 'Start date is required' : null;

      if (!_currentlyAttend) {
        if (_eduTo == null) {
          _eduToError = 'End date is required';
        } else if (_eduFrom != null && !_eduTo!.isAfter(_eduFrom!)) {
          _eduToError = 'End date must be after start date';
        } else {
          _eduToError = null;
        }
      } else {
        _eduToError = null;
      }
    });

    return _educationError == null &&
        _eduFromError == null &&
        _eduToError == null;
  }

  void _next() {
    final validators = [
      _validateStep1,
      _validateStep2,
      _validateStep3,
      _validateStep4,
    ];

    if (!validators[_currentStep]()) return;

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully applied to ${widget.job['title']} at ${widget.job['company']}!',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color(0xFFFFEE00),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  // ── File Picker ─────────────────────────────────────────────────────────────

  Future<void> _pickFile({required bool isResume}) async {
    try {
      // Clear any previous error state first
      setState(() {
        if (isResume) {
          _resumeError = null;
        } else {
          _coverLetterError = null;
        }
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        // Validate file size — max 10MB
        if (file.size > 10 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'File is too large. Maximum size is 10MB.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.red[400],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
          return;
        }
        setState(() {
          if (isResume) {
            _resumeFile = file;
            _resumeError = null;
          } else {
            _coverLetterFile = file;
            _coverLetterError = null;
          }
        });
      }
    } on Exception catch (e) {
      debugPrint('FilePicker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Unable to open file picker. Check storage permissions.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  // ── Date Picker ─────────────────────────────────────────────────────────────

  Future<void> _pickDate({
    required DateTime? current,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFFFEE00),
            onPrimary: Colors.black,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null || bytes == 0) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Apply to ${widget.job['company'] ?? 'Company'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Step counter badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEE00),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentStep + 1}/$_totalSteps',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Progress bar ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_totalSteps, (i) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(
                          right: i < _totalSteps - 1 ? 6 : 0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _currentStep
                            ? const Color(0xFFFFEE00)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 4),

            // ── Step content ──────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: _buildCurrentStep(),
              ),
            ),

            // ── Bottom nav ─────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    GestureDetector(
                      onTap: _back,
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                  GestureDetector(
                    onTap: _next,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEE00),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        _currentStep == _totalSteps - 1 ? 'Submit' : 'Next',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildContactInfo();
      case 1:
        return _buildResume();
      case 2:
        return _buildWorkExperience();
      case 3:
        return _buildEducation();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Step 1: Contact Info ────────────────────────────────────────────────────

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact info',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        // Profile preview card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                    color: Color(0xFFE0E0E0), shape: BoxShape.circle),
                child:
                    const Icon(Icons.person, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Profile',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  Text('Fill in your details below',
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _buildLabel('First Name', required: true),
        _buildTextField(
          _firstNameController,
          'Enter first name',
          errorText: _firstNameError,
          onChanged: (_) {
            if (_firstNameError != null)
              setState(() => _firstNameError = null);
          },
        ),
        const SizedBox(height: 14),

        _buildLabel('Last Name', required: true),
        _buildTextField(
          _lastNameController,
          'Enter last name',
          errorText: _lastNameError,
          onChanged: (_) {
            if (_lastNameError != null) setState(() => _lastNameError = null);
          },
        ),
        const SizedBox(height: 14),

        _buildLabel('Mobile phone number', required: true),
        _buildTextField(
          _phoneController,
          '+63 9XX XXX XXXX',
          keyboardType: TextInputType.phone,
          errorText: _phoneError,
          onChanged: (_) {
            if (_phoneError != null) setState(() => _phoneError = null);
          },
        ),
        const SizedBox(height: 14),

        _buildLabel('Email address', required: true),
        _buildTextField(
          _emailController,
          'you@email.com',
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          onChanged: (_) {
            if (_emailError != null) setState(() => _emailError = null);
          },
        ),
        const SizedBox(height: 14),

        _buildLabel('Location (city)', required: true),
        _buildTextField(
          _locationController,
          'e.g. Mandaluyong City',
          errorText: _locationError,
          onChanged: (_) {
            if (_locationError != null)
              setState(() => _locationError = null);
          },
        ),
      ],
    );
  }

  // ── Step 2: Resume ──────────────────────────────────────────────────────────

  Widget _buildResume() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Resume',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Be sure to include an updated resume',
            style: TextStyle(fontSize: 13, color: Colors.grey[500])),
        const SizedBox(height: 20),

        _buildUploadButton(
          label: 'Upload Resume',
          file: _resumeFile,
          errorText: _resumeError,
          onTap: () => _pickFile(isResume: true),
          onRemove: () => setState(() {
            _resumeFile = null;
            _resumeError = 'Please upload your resume';
          }),
        ),
        const SizedBox(height: 6),
        Text('DOC, DOCX, PDF',
            style: TextStyle(fontSize: 11, color: Colors.grey[400])),

        const SizedBox(height: 28),

        Row(
          children: [
            const Text('Cover Letter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Optional',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Text('Be sure to include an updated cover letter',
            style: TextStyle(fontSize: 13, color: Colors.grey[500])),
        const SizedBox(height: 16),

        _buildUploadButton(
          label: 'Upload Cover Letter',
          file: _coverLetterFile,
          errorText: _coverLetterError,
          onTap: () => _pickFile(isResume: false),
          onRemove: () => setState(() {
            _coverLetterFile = null;
            _coverLetterError = 'Please upload a cover letter';
          }),
        ),
        const SizedBox(height: 6),
        Text('DOC, DOCX, PDF',
            style: TextStyle(fontSize: 11, color: Colors.grey[400])),
      ],
    );
  }

  // ── Step 3: Work Experience ─────────────────────────────────────────────────

  Widget _buildWorkExperience() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Work Experience',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        _buildLabel('Your title', required: true),
        _buildTextField(
          _jobTitleController,
          'e.g. UI/UX Designer',
          errorText: _jobTitleError,
          onChanged: (_) {
            if (_jobTitleError != null)
              setState(() => _jobTitleError = null);
          },
        ),
        const SizedBox(height: 14),

        _buildLabel('Company'),
        _buildTextField(_companyController, 'e.g. Volkswagen'),
        const SizedBox(height: 14),

        const Text('Dates of Employment',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: () =>
              setState(() => _currentlyWorkHere = !_currentlyWorkHere),
          child: Row(
            children: [
              _buildCheckbox(_currentlyWorkHere),
              const SizedBox(width: 8),
              const Text('I currently work here',
                  style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 10),

        _buildLabel('From', required: true),
        _buildDateField(
          value: _workFrom,
          hint: 'MM/YYYY',
          errorText: _workFromError,
          onTap: () => _pickDate(
            current: _workFrom,
            onPicked: (d) => setState(() {
              _workFrom = d;
              _workFromError = null;
            }),
          ),
        ),

        if (!_currentlyWorkHere) ...[
          const SizedBox(height: 14),
          _buildLabel('To', required: true),
          _buildDateField(
            value: _workTo,
            hint: 'MM/YYYY',
            errorText: _workToError,
            onTap: () => _pickDate(
              current: _workTo,
              onPicked: (d) => setState(() {
                _workTo = d;
                _workToError = null;
              }),
            ),
          ),
        ],

        const SizedBox(height: 14),
        _buildLabel('City'),
        _buildTextField(_workCityController, 'e.g. Manila'),
        const SizedBox(height: 14),

        _buildLabel('Description'),
        _buildTextField(
          _workDescriptionController,
          'Describe your role and responsibilities...',
          maxLines: 4,
        ),
      ],
    );
  }

  // ── Step 4: Education ───────────────────────────────────────────────────────

  Widget _buildEducation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Education',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        _buildLabel('School / University', required: true),
        _buildTextField(
          _educationController,
          'e.g. University of the Philippines',
          errorText: _educationError,
          onChanged: (_) {
            if (_educationError != null)
              setState(() => _educationError = null);
          },
        ),
        const SizedBox(height: 14),

        _buildLabel('City'),
        _buildTextField(_eduCityController, 'e.g. Quezon City'),
        const SizedBox(height: 14),

        _buildLabel('Degree'),
        _buildTextField(_degreeController, "e.g. Bachelor's Degree"),
        const SizedBox(height: 14),

        _buildLabel('Major / Field of study'),
        _buildTextField(_majorController, 'e.g. Computer Science'),
        const SizedBox(height: 16),

        const Text('Dates of Attendance',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: () =>
              setState(() => _currentlyAttend = !_currentlyAttend),
          child: Row(
            children: [
              _buildCheckbox(_currentlyAttend),
              const SizedBox(width: 8),
              const Text('I currently attend this institution',
                  style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 10),

        _buildLabel('From', required: true),
        _buildDateField(
          value: _eduFrom,
          hint: 'MM/YYYY',
          errorText: _eduFromError,
          onTap: () => _pickDate(
            current: _eduFrom,
            onPicked: (d) => setState(() {
              _eduFrom = d;
              _eduFromError = null;
            }),
          ),
        ),

        if (!_currentlyAttend) ...[
          const SizedBox(height: 14),
          _buildLabel('To', required: true),
          _buildDateField(
            value: _eduTo,
            hint: 'MM/YYYY',
            errorText: _eduToError,
            onTap: () => _pickDate(
              current: _eduTo,
              onPicked: (d) => setState(() {
                _eduTo = d;
                _eduToError = null;
              }),
            ),
          ),
        ],

        const SizedBox(height: 8),
      ],
    );
  }

  // ── Shared Helpers ──────────────────────────────────────────────────────────

  Widget _buildLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87),
          children: [
            TextSpan(text: text),
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: hasError ? const Color(0xFFFFF0F0) : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasError ? Colors.red.shade300 : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  TextStyle(color: Colors.grey[400], fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 13, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                errorText,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDateField({
    required DateTime? value,
    required String hint,
    required VoidCallback onTap,
    String? errorText,
  }) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: hasError ? const Color(0xFFFFF0F0) : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasError ? Colors.red.shade300 : Colors.transparent,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null ? _formatDate(value) : hint,
                    style: TextStyle(
                      fontSize: 14,
                      color: value != null
                          ? Colors.black87
                          : Colors.grey[400],
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: hasError ? Colors.red.shade300 : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 13, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                errorText,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildUploadButton({
    required String label,
    required PlatformFile? file,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    String? errorText,
  }) {
    final hasFile = file != null;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Attached file card — shown when file is selected
        if (hasFile)
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDE7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFEE00)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: const Icon(Icons.description_outlined,
                      size: 18, color: Color(0xFF2D2D2D)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (file.size > 0)
                        Text(
                          _formatFileSize(file.size),
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[500]),
                        ),
                    ],
                  ),
                ),
                // Remove button
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Icon(Icons.close,
                        size: 14, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),

        // Upload / Replace button
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasError
                    ? Colors.red.shade300
                    : const Color(0xFFFFEE00),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file_outlined,
                  size: 18,
                  color: hasError ? Colors.red : Colors.black87,
                ),
                const SizedBox(width: 8),
                Text(
                  hasFile ? 'Replace File' : label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: hasError ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (hasError) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 13, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                errorText,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCheckbox(bool value) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: value ? const Color(0xFFFFEE00) : Colors.white,
        border: Border.all(
          color: value ? const Color(0xFFFFEE00) : Colors.grey[400]!,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: value
          ? const Icon(Icons.check, size: 13, color: Colors.black)
          : null,
    );
  }
}