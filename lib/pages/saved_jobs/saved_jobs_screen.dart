import 'package:flutter/material.dart';
import 'package:ehanapbuhay/widgets/app_logo_header.dart';
import 'package:ehanapbuhay/widgets/app_toast.dart';
import 'package:ehanapbuhay/pages/job_details/job_details_screen.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  // TODO (backend): replace with GET /api/saved-jobs
  final List<Map<String, dynamic>> _savedJobs = [
    {
      'company': 'Volkswagen',
      'logo': 'assets/volkswagen_logo.png',
      'title': 'Jr. UI/UX Designer',
      'salary': '₱7000-₱10000',
      'type': 'Remote',
      'description':
          'Join top clients and find freelance jobs that match your skills!',
      'savedDate': 'Feb 18, 2026',
    },
    {
      'company': 'Ikea',
      'logo': 'assets/ikea_logo.png',
      'title': 'Product Manager',
      'salary': '₱50000-₱80000',
      'type': 'Onsite',
      'description':
          'Join top clients and find freelance jobs that match your skills!',
      'savedDate': 'Feb 15, 2026',
    },
    {
      'company': 'Google',
      'logo': 'assets/google_logo.png',
      'title': 'Senior Android Developer',
      'salary': '₱100000-₱150000',
      'type': 'Remote',
      'description':
          'Join top clients and find freelance jobs that match your skills!',
      'savedDate': 'Feb 12, 2026',
    },
    {
      'company': 'Microsoft',
      'logo': 'assets/microsoft_logo.png',
      'title': 'Cloud Solutions Architect',
      'salary': '₱120000-₱180000',
      'type': 'Hybrid',
      'description':
          'Join top clients and find freelance jobs that match your skills!',
      'savedDate': 'Feb 9, 2026',
    },
  ];

  void _unsaveJob(int index) {
    final jobTitle = _savedJobs[index]['title'];
    setState(() => _savedJobs.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$jobTitle removed from saved jobs.',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFFFFEE00),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.black,
          onPressed: () {
            // TODO: re-call POST /api/saved-jobs when backend is ready
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: const AppLogoHeader(),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saved Jobs',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEE00),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_savedJobs.length} saved',
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
          const SizedBox(height: 16),

          // ── List ──────────────────────────────────────────────────────────
          Expanded(
            child: _savedJobs.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    itemCount: _savedJobs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final job = _savedJobs[index];
                      return SavedJobCard(
                        job: job,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => JobDetailScreen(
                              job: job,
                              appliedDate: null,
                              applicationStatus: null,
                            ),
                          ),
                        ),
                        onUnsave: () => _unsaveJob(index),
                      );
                    },
                  ),
          ),
        ],
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
            child: Icon(
              Icons.bookmark_border_rounded,
              size: 34,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No saved jobs yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Jobs you bookmark will appear here.',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SAVED JOB CARD
// ─────────────────────────────────────────────────────────────────────────────
class SavedJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  const SavedJobCard({
    super.key,
    required this.job,
    required this.onTap,
    required this.onUnsave,
  });

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          children: [
            // Logo
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  job['logo'],
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(
                      job['company'][0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    job['company'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFDE7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFFFEE00),
                          ),
                        ),
                        child: Text(
                          job['type'] ?? 'Remote',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        job['salary'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bookmark
            GestureDetector(
              onTap: onUnsave,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Icon(
                  Icons.bookmark_rounded,
                  color: Color(0xFFFFEE00),
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}