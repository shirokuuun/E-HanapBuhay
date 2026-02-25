import 'package:flutter/material.dart';

/// The white card containing the four profile menu items.
class ProfileMenu extends StatelessWidget {
  final VoidCallback onPersonalInfo;
  final VoidCallback onContactInfo;
  final VoidCallback onWorkDocuments;
  final VoidCallback onAccountSettings;

  const ProfileMenu({
    super.key,
    required this.onPersonalInfo,
    required this.onContactInfo,
    required this.onWorkDocuments,
    required this.onAccountSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.person_outline_rounded,
            label: 'Personal Information',
            isFirst: true,
            onTap: onPersonalInfo,
          ),
          _MenuItem(
            icon: Icons.contact_phone_outlined,
            label: 'Contact Information',
            onTap: onContactInfo,
          ),
          _MenuItem(
            icon: Icons.description_outlined,
            label: 'Work Documents',
            onTap: onWorkDocuments,
          ),
          _MenuItem(
            icon: Icons.settings_outlined,
            label: 'Account Settings',
            isLast: true,
            onTap: onAccountSettings,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: isFirst ? 16 : 14,
              bottom: isLast ? 16 : 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: const Color(0xFF2D2D2D)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.chevron_right,
                      size: 16, color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(height: 1, indent: 66, endIndent: 16, color: Colors.grey[100]),
      ],
    );
  }
}