import 'package:ehanapbuhay/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ehanapbuhay/pages/job_details/job_details_screen.dart';
import 'package:ehanapbuhay/pages/applied_jobs/applied_jobs_screen.dart';
import 'package:ehanapbuhay/pages/saved_jobs/saved_jobs_screen.dart';
import 'package:ehanapbuhay/pages/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;

  // The 5 pages mapped to the bottom nav
  // TODO (backend): notifications and profile screens to be added later
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _JobListPage(),
      const AppliedJobsScreen(),
      const SavedJobsScreen(),
      const _PlaceholderPage(
        icon: Icons.notifications_none_rounded,
        label: 'Notifications',
      ),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // IndexedStack keeps all pages alive (preserves scroll/filter state)
      body: IndexedStack(index: _selectedNavIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9C4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  index: 0,
                  selected: _selectedNavIndex == 0,
                  onTap: (i) => setState(() => _selectedNavIndex = i),
                ),
                _NavItem(
                  icon: Icons.description_outlined,
                  index: 1,
                  selected: _selectedNavIndex == 1,
                  onTap: (i) => setState(() => _selectedNavIndex = i),
                ),
                _NavItem(
                  icon: Icons.bookmark_border_rounded,
                  index: 2,
                  selected: _selectedNavIndex == 2,
                  onTap: (i) => setState(() => _selectedNavIndex = i),
                ),
                _NavItem(
                  icon: Icons.notifications_none_rounded,
                  index: 3,
                  selected: _selectedNavIndex == 3,
                  onTap: (i) => setState(() => _selectedNavIndex = i),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  index: 4,
                  selected: _selectedNavIndex == 4,
                  onTap: (i) => setState(() => _selectedNavIndex = i),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// JOB LIST PAGE (Home tab)
// ─────────────────────────────────────────────────────────────────────────────
class _JobListPage extends StatefulWidget {
  const _JobListPage();

  @override
  State<_JobListPage> createState() => _JobListPageState();
}

class _JobListPageState extends State<_JobListPage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _jobs = [];

  @override
  void initState() {
    super.initState();
    _fetchJobs();
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final horizontalPadding = isMobile ? 20.0 : 40.0;

    return Column(
      children: [
        // Top Bar
        Container(
          color: Colors.white,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
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

        // Filter chips
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12,
          ),
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
                children: ['All', 'Remote only', 'Onsite only'].map((filter) {
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
                            color: isSelected ? Colors.black : Colors.grey[600],
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

        // Job list
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 4,
            ),
            itemCount: _jobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final job = _jobs[index];
              return _JobCard(
                job: job,
                onBookmarkToggle: () {
                  setState(() {
                    _jobs[index]['isBookmarked'] =
                        !_jobs[index]['isBookmarked'];
                  });
                },
                onApply: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => JobDetailScreen(
                        job: job,
                        appliedDate: null,
                        applicationStatus: null,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER PAGE (Notifications / Profile — to be built later)
// ─────────────────────────────────────────────────────────────────────────────
class _PlaceholderPage extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PlaceholderPage({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
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
                child: Icon(icon, size: 34, color: Colors.grey[400]),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Coming soon',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// JOB CARD
// ─────────────────────────────────────────────────────────────────────────────
class _JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onApply;

  const _JobCard({
    required this.job,
    required this.onBookmarkToggle,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final companyName =
        (job['company'] ?? job['company_name'] ?? '?') as String;
    final jobTitle = (job['title'] ?? '') as String;
    final salary =
        (job['salary_range'] ?? job['salary'] ?? 'Negotiable') as String;
    final description = (job['description'] ?? '') as String;
    final logoUrl = job['logo'] as String?;
    final isBookmarked = (job['isBookmarked'] ?? false) as bool;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: logoUrl != null && logoUrl.startsWith('http')
                      ? Image.network(
                          logoUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Center(
                            child: Text(
                              companyName[0],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            companyName[0],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onBookmarkToggle,
                child: Icon(
                  isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isBookmarked
                      ? const Color(0xFFFFEE00)
                      : Colors.grey[400],
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobTitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Salary: $salary',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2D2D),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAV ITEM
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final bool selected;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: selected
            ? BoxDecoration(
                color: const Color(0xFFFFEE00),
                borderRadius: BorderRadius.circular(18),
              )
            : null,
        child: Icon(
          icon,
          color: selected ? Colors.black : Colors.black.withOpacity(0.25),
          size: 24,
        ),
      ),
    );
  }
}
