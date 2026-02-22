import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ehanapbuhay/pages/apply_screen.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobDetailScreen({Key? key, required this.job, required appliedDate, required applicationStatus}) : super(key: key);

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Job', 'Company', 'Connections'];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final horizontalPadding = isMobile ? 20.0 : 40.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: back + share
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back, size: 24),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share link copied!', style: TextStyle(color: Colors.black),),
                          backgroundColor: Color(0xFFFFEE00),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Icon(Icons.share_outlined, size: 24),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Company logo
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          widget.job['logo'] ?? '',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Center(
                            child: Text(
                              widget.job['company']?[0] ?? '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Company name
                    Text(
                      widget.job['company'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Job title + type
                    Text(
                      '${widget.job['title'] ?? ''} • Full-Time',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Apply + Save buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ApplyScreen(job: widget.job),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.open_in_new,
                              size: 16,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Apply',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFEE00),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Job saved!', style: TextStyle(color: Colors.black),),
                                  backgroundColor: Color(0xFFFFEE00),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.yellow[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Info grid (Remote, Technology, Experience, Employees)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _InfoItem(
                                  icon: Icons.location_on_outlined,
                                  label: 'Remote',
                                ),
                              ),
                              Expanded(
                                child: _InfoItem(
                                  icon: Icons.category_outlined,
                                  label: 'Technology',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _InfoItem(
                                  icon: Icons.work_outline,
                                  label: '4 Years',
                                ),
                              ),
                              Expanded(
                                child: _InfoItem(
                                  icon: Icons.group_outlined,
                                  label: '1000+',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tab selector
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: List.generate(_tabs.length, (index) {
                          final isSelected = _selectedTab == index;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedTab = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFEE00)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  _tabs[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tab content
                    _buildTabContent(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _JobTabContent(job: widget.job);
      case 1:
        return _CompanyTabContent(job: widget.job);
      case 2:
        return _ConnectionsTabContent(job: widget.job);
      default:
        return const SizedBox.shrink();
    }
  }
}

// Info item widget used in the grid
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.black87),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}

// --- Job Tab ---
class _JobTabContent extends StatelessWidget {
  final Map<String, dynamic> job;

  const _JobTabContent({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Role',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            job['description'] ??
                'Join top clients and find freelance jobs that match your skills! Browse, apply, and get hired for roles like UI/UX design, digital marketing, and more — all in one place! We\'re looking for engineers who bring fresh ideas from all areas, including information retrieval and distributed systems.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Responsibilities',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'As a ${job['title'] ?? 'professional'} at ${job['company'] ?? 'the company'}, you will design, develop, test, and maintain scalable software systems that power products used by millions of users worldwide. You will work collaboratively with cross-functional teams—including product managers, designers, and other engineers—to build innovative, high-performance solutions that improve user experience and drive technological advancement.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Requirements',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...[
            'Bachelor\'s degree in Computer Science or related field',
            'Strong problem-solving skills and attention to detail',
            'Experience with modern frameworks and tools',
            'Excellent communication and teamwork skills',
          ].map(
            (req) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFEE00),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      req,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Company Tab ---
class _CompanyTabContent extends StatelessWidget {
  final Map<String, dynamic> job;

  const _CompanyTabContent({required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About the Company',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${job['company'] ?? 'This company'} is a world-renowned organization known for innovation, quality, and impact. With over 1,000 employees globally, we are committed to building products and services that make a real difference in people\'s everyday lives.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Company Details',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _CompanyDetailRow(
            icon: Icons.business_outlined,
            label: 'Industry',
            value: 'Technology',
          ),
          _CompanyDetailRow(
            icon: Icons.people_outline,
            label: 'Company Size',
            value: '1,000+ employees',
          ),
          _CompanyDetailRow(
            icon: Icons.public_outlined,
            label: 'Website',
            value: 'www.${(job['company'] ?? 'company').toLowerCase()}.com',
          ),
          _CompanyDetailRow(
            icon: Icons.location_city_outlined,
            label: 'Headquarters',
            value: 'Global',
          ),
          const SizedBox(height: 20),
          const Text(
            'Culture & Benefits',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Health Insurance',
              'Remote Work',
              'Flexible Hours',
              '401(k)',
              'Learning Budget',
              'Team Events',
            ].map(
              (benefit) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDE7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFEE00)),
                ),
                child: Text(
                  benefit,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class _CompanyDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CompanyDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[500]),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Connections Tab ---
class _ConnectionsTabContent extends StatelessWidget {
  final Map<String, dynamic> job;

  const _ConnectionsTabContent({required this.job});

  // Mock connections data
  static const List<Map<String, dynamic>> _connections = [
    {
      'name': 'Maria Santos',
      'role': 'Sr. UI/UX Designer',
      'mutual': 3,
      'initials': 'MS',
      'color': Color(0xFF4CAF50),
    },
    {
      'name': 'Juan Dela Cruz',
      'role': 'Product Manager',
      'mutual': 5,
      'initials': 'JD',
      'color': Color(0xFF2196F3),
    },
    {
      'name': 'Ana Reyes',
      'role': 'Frontend Developer',
      'mutual': 2,
      'initials': 'AR',
      'color': Color(0xFFFF9800),
    },
    {
      'name': 'Carlos Mendoza',
      'role': 'Backend Engineer',
      'mutual': 7,
      'initials': 'CM',
      'color': Color(0xFF9C27B0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'People you may know at ${job['company'] ?? 'this company'}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Connect with colleagues already working there',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          ..._connections.map(
            (person) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: person['color'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        person['initials'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
                          person['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          person['role'],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${person['mutual']} mutual connections',
                          style: const TextStyle(
                            color: Color(0xFF0274E5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Connected with ${person['name']}!',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: const Color(0xFFFFEE00),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFEE00)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}