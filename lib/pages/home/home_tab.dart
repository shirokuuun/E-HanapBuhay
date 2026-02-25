import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ehanapbuhay/services/api_service.dart';
import 'package:ehanapbuhay/widgets/app_logo_header.dart';
import 'package:ehanapbuhay/widgets/job_card.dart';
import 'package:ehanapbuhay/pages/job_details/job_details_screen.dart';

/// The "Home" tab — job list with search bar and work-setup filters.
/// Does NOT contain a Scaffold; it is rendered inside [AppShell].
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchJobs({String? filter}) async {
    final activeFilter = filter ?? _selectedFilter;
    String? workSetup;
    if (activeFilter == 'Remote only') workSetup = 'Remote';
    if (activeFilter == 'Onsite only') workSetup = 'Onsite';

    final result = await ApiService.getJobs(workSetup: workSetup);
    if (result.success && mounted) {
      setState(() {
        _jobs = List<Map<String, dynamic>>.from(result.data!['jobs']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final hp = isMobile ? 20.0 : 40.0;

    return Column(
      children: [
        // ── Top bar ────────────────────────────────────────────────────────
        Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hp, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo — use the large variant with the full wordmark
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/ehanapbuhay.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFEE00),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.work, size: 28),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-16, 0),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'e-',
                                style: TextStyle(
                                  color: Color(0xFFF8E806),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'HanapBuhay',
                                style: TextStyle(
                                  color: Color(0xFF0274E5),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search Job',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2D),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Filter chips ───────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hp, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${_jobs.length} New jobs available',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children:
                    ['All', 'Remote only', 'Onsite only'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedFilter = filter);
                        _fetchJobs(filter: filter);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFFEE00)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFFFEE00)
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected ? Colors.black : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // ── Job list ───────────────────────────────────────────────────────
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: hp, vertical: 4),
            itemCount: _jobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final job = _jobs[index];
              return JobCard(
                job: job,
                onBookmarkToggle: () => setState(
                  () => _jobs[index]['isBookmarked'] =
                      !(_jobs[index]['isBookmarked'] ?? false),
                ),
                onApply: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => JobDetailScreen(
                      job: job,
                      appliedDate: null,
                      applicationStatus: null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}