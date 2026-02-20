import 'package:flutter/material.dart';
import 'package:ehanapbuhay/onboarding_data/screens/job_details_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// APPLICATION STATUS ENUM
// When integrating with Node.js + PostgreSQL, the status field will come from
// the API response: GET /api/applications  →  { status: 'applied' | 'viewed'
// | 'accepted' | 'rejected' }
// ─────────────────────────────────────────────────────────────────────────────
enum ApplicationStatus { applied, viewed, accepted, rejected }

extension ApplicationStatusExt on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.viewed:
        return 'Viewed';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case ApplicationStatus.applied:
        return const Color(0xFF2196F3); // blue
      case ApplicationStatus.viewed:
        return const Color(0xFFFF9800); // orange
      case ApplicationStatus.accepted:
        return const Color(0xFF4CAF50); // green
      case ApplicationStatus.rejected:
        return const Color(0xFFF44336); // red
    }
  }

  Color get bgColor {
    switch (this) {
      case ApplicationStatus.applied:
        return const Color(0xFFE3F2FD);
      case ApplicationStatus.viewed:
        return const Color(0xFFFFF3E0);
      case ApplicationStatus.accepted:
        return const Color(0xFFE8F5E9);
      case ApplicationStatus.rejected:
        return const Color(0xFFFFEBEE);
    }
  }

  IconData get icon {
    switch (this) {
      case ApplicationStatus.applied:
        return Icons.send_rounded;
      case ApplicationStatus.viewed:
        return Icons.visibility_outlined;
      case ApplicationStatus.accepted:
        return Icons.check_circle_outline_rounded;
      case ApplicationStatus.rejected:
        return Icons.cancel_outlined;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APPLIED JOBS SCREEN
// TODO (backend integration): Replace _mockApplications with an API call:
//   final response = await dio.get('/api/applications');
//   final applications = (response.data as List)
//       .map((e) => AppliedJob.fromJson(e))
//       .toList();
// ─────────────────────────────────────────────────────────────────────────────
class AppliedJobsScreen extends StatefulWidget {
  const AppliedJobsScreen({Key? key}) : super(key: key);

  @override
  State<AppliedJobsScreen> createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen> {
  // Mock data — swap this list with API data when backend is ready
  final List<Map<String, dynamic>> _mockApplications = [
    {
      'company': 'Google',
      'logo': 'assets/google_logo.png',
      'title': 'Senior Developer',
      'salary': '₱80000-₱120000',
      'description':
          'Join top clients and find freelance jobs that match your skills! Browse, apply, and get hired for roles like UI/UX design, digital marketing, and more — all in one place!',
      'appliedDate': 'February 12, 2026',
      'status': ApplicationStatus.applied,
    },
    {
      'company': 'Microsoft',
      'logo': 'assets/microsoft_logo.png',
      'title': 'Junior UI/UX Designer',
      'salary': '₱30000-₱50000',
      'description':
          'Join top clients and find freelance jobs that match your skills! Browse, apply, and get hired for roles like UI/UX design, digital marketing, and more — all in one place!',
      'appliedDate': 'February 10, 2026',
      'status': ApplicationStatus.viewed,
    },
    {
      'company': 'Samsung',
      'logo': 'assets/samsung_logo.png',
      'title': 'IT Sales',
      'salary': '₱25000-₱40000',
      'description':
          'Join top clients and find freelance jobs that match your skills! Browse, apply, and get hired for roles like UI/UX design, digital marketing, and more — all in one place!',
      'appliedDate': 'February 8, 2026',
      'status': ApplicationStatus.applied,
    },
    {
      'company': 'Samsung',
      'logo': 'assets/samsung_logo.png',
      'title': 'Software Engineer',
      'salary': '₱60000-₱90000',
      'description':
          'Join top clients and find freelance jobs that match your skills! Browse, apply, and get hired for roles like UI/UX design, digital marketing, and more — all in one place!',
      'appliedDate': 'February 5, 2026',
      'status': ApplicationStatus.accepted,
    },
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Applied', 'Viewed', 'Accepted', 'Rejected'];

  List<Map<String, dynamic>> get _filteredApplications {
    if (_selectedFilter == 'All') return _mockApplications;
    return _mockApplications.where((job) {
      final status = job['status'] as ApplicationStatus;
      return status.label == _selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  // Logo
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Image.asset(
                      'assets/ehanapbuhay.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFEE00),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.work, size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'e-',
                          style: TextStyle(
                            color: Color(0xFFF8E806),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'HanapBuhay',
                          style: TextStyle(
                            color: Color(0xFF0274E5),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Applied Jobs',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEE00),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_mockApplications.length} total',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Filter chips ─────────────────────────────────────────────────
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final f = _filters[i];
                  final isSelected = _selectedFilter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFEE00)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ── Job list ─────────────────────────────────────────────────────
            Expanded(
              child: _filteredApplications.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      itemCount: _filteredApplications.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final job = _filteredApplications[index];
                        return _AppliedJobCard(
                          job: job,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => JobDetailScreen(
                                  job: job,
                                  appliedDate: job['appliedDate'],
                                  applicationStatus: job['status'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.description_outlined,
                size: 34, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Text(
            'No $_selectedFilter applications',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Applications with this status\nwill appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APPLIED JOB CARD
// ─────────────────────────────────────────────────────────────────────────────
class _AppliedJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onTap;

  const _AppliedJobCard({required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = job['status'] as ApplicationStatus;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Company logo
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      job['logo'],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          job['company'][0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['company'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        job['title'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    size: 20, color: Colors.black38),
              ],
            ),

            const SizedBox(height: 10),

            // Divider
            Divider(height: 1, color: Colors.grey[200]),

            const SizedBox(height: 10),

            // Status row
            Row(
              children: [
                Icon(status.icon, size: 15, color: status.color),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: status.bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: status.color,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  job['appliedDate'],
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}