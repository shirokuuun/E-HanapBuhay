import 'package:flutter/material.dart';
import 'package:ehanapbuhay/pages/home/home_tab.dart';
import 'package:ehanapbuhay/pages/applied_jobs/applied_jobs_screen.dart';
import 'package:ehanapbuhay/pages/saved_jobs/saved_jobs_screen.dart';
import 'package:ehanapbuhay/pages/notifications/notifications_screen.dart';
import 'package:ehanapbuhay/pages/profile/profile_screen.dart';
import 'package:ehanapbuhay/widgets/main_scaffold.dart';

/// Root screen that owns bottom-nav state and keeps all tabs alive via
/// [IndexedStack]. Every tab can be reached by calling
/// `AppShell.switchTab(context, index)`.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  /// Programmatically switch tab from anywhere in the tree.
  static void switchTab(BuildContext context, int index) {
    context.findAncestorStateOfType<_AppShellState>()?.switchTab(index);
  }

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  void switchTab(int index) => setState(() => _selectedIndex = index);

  static const _pages = <Widget>[
    HomeTab(),
    AppliedJobsScreen(),
    SavedJobsScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: _selectedIndex,
      onNavTap: switchTab,
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }
}