import 'package:flutter/material.dart';

/// A card showing company logo, job title, salary, description,
/// a bookmark toggle and an Apply button.
class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onApply;

  const JobCard({
    super.key,
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
          // ── Company row ──────────────────────────────────────────────────
          Row(
            children: [
              _CompanyLogo(name: companyName, logoUrl: logoUrl),
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

          // ── Description ──────────────────────────────────────────────────
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // ── Title + salary + apply ────────────────────────────────────────
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
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey[400]),
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
// COMPANY LOGO  (network image with initial fallback)
// ─────────────────────────────────────────────────────────────────────────────
class _CompanyLogo extends StatelessWidget {
  final String name;
  final String? logoUrl;
  final double size;

  const _CompanyLogo({required this.name, this.logoUrl, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: logoUrl != null && logoUrl!.startsWith('http')
            ? Image.network(
                logoUrl!,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _Initial(name),
              )
            : _Initial(name),
      ),
    );
  }
}

class _Initial extends StatelessWidget {
  final String name;
  const _Initial(this.name);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0] : '?',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}