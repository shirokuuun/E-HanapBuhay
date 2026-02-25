import 'package:flutter/material.dart';

/// A reusable shell that wraps any screen with the app's bottom navigation bar.
/// Usage:
///   MainScaffold(currentIndex: 0, body: YourScreen())
class MainScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget body;
  final void Function(int) onNavTap;

  const MainScaffold({
    super.key,
    required this.currentIndex,
    required this.body,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: currentIndex,
        onTap: onNavTap,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM NAV BAR
// ─────────────────────────────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  static const _icons = [
    Icons.home_rounded,
    Icons.description_outlined,
    Icons.bookmark_border_rounded,
    Icons.notifications_none_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            children: List.generate(
              _icons.length,
              (i) => _NavItem(
                icon: _icons[i],
                index: i,
                selected: selectedIndex == i,
                onTap: onTap,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV ITEM
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final bool selected;
  final void Function(int) onTap;

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