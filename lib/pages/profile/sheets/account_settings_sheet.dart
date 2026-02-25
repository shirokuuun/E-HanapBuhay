import 'package:flutter/material.dart';
import 'package:ehanapbuhay/widgets/sheet_widgets.dart';

class AccountSettingsSheet extends StatefulWidget {
  final String email;
  final VoidCallback onSignOut;

  const AccountSettingsSheet({
    super.key,
    required this.email,
    required this.onSignOut,
  });

  @override
  State<AccountSettingsSheet> createState() => _AccountSettingsSheetState();
}

class _AccountSettingsSheetState extends State<AccountSettingsSheet> {
  bool _pushNotifications = true;
  bool _emailAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sheetHandle(),
          sheetHeader(context, 'Account Settings'),
          const SizedBox(height: 20),

          _sectionLabel('Account'),
          const SizedBox(height: 8),
          _card([
            _tile(icon: Icons.email_outlined, title: 'Email Address',
                subtitle: widget.email),
            _divider(),
            _tile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              showArrow: true,
              onTap: () => _showChangePassword(context),
            ),
          ]),

          const SizedBox(height: 16),
          _sectionLabel('Notifications'),
          const SizedBox(height: 8),
          _card([
            _tile(
              icon: Icons.notifications_outlined,
              title: 'Push Notifications',
              trailing: Switch(
                value: _pushNotifications,
                onChanged: (v) => setState(() => _pushNotifications = v),
                activeColor: const Color(0xFF2D2D2D),
                activeTrackColor: const Color(0xFFFFEE00),
              ),
            ),
            _divider(),
            _tile(
              icon: Icons.mark_email_unread_outlined,
              title: 'Email Alerts',
              trailing: Switch(
                value: _emailAlerts,
                onChanged: (v) => setState(() => _emailAlerts = v),
                activeColor: const Color(0xFF2D2D2D),
                activeTrackColor: const Color(0xFFFFEE00),
              ),
            ),
          ]),

          const SizedBox(height: 16),
          _sectionLabel('Danger Zone'),
          const SizedBox(height: 8),
          _card([
            _tile(
              icon: Icons.delete_outline,
              title: 'Delete Account',
              titleColor: Colors.red[400],
              iconColor: Colors.red[400],
              showArrow: true,
              onTap: () => _confirmDelete(context),
            ),
          ]),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
        label,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.5),
      );

  Widget _card(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: children),
      );

  Widget _divider() =>
      Divider(height: 1, indent: 52, endIndent: 16, color: Colors.grey[200]);

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? iconColor,
    Widget? trailing,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 20, color: iconColor ?? Colors.black87),
      title: Text(title,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: titleColor ?? Colors.black87)),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]))
          : null,
      trailing: trailing ??
          (showArrow
              ? const Icon(Icons.chevron_right,
                  size: 18, color: Colors.black38)
              : null),
    );
  }

  void _showChangePassword(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sheetHandle(),
                sheetHeader(ctx, 'Change Password'),
                const SizedBox(height: 20),
                sheetInputField('Current Password', currentCtrl,
                    Icons.lock_outline,
                    obscure: true),
                const SizedBox(height: 14),
                sheetInputField(
                    'New Password', newCtrl, Icons.lock_reset_outlined,
                    obscure: true),
                const SizedBox(height: 14),
                sheetInputField('Confirm New Password', confirmCtrl,
                    Icons.lock_clock_outlined,
                    obscure: true),
                const SizedBox(height: 24),
                ActionButton(
                  label: 'Update Password',
                  isLoading: false,
                  onTap: () async {
                    if (newCtrl.text != confirmCtrl.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Passwords do not match')),
                      );
                      return;
                    }
                    if (newCtrl.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Password must be at least 6 characters')),
                      );
                      return;
                    }
                    // TODO: ApiService.changePassword(...)
                    await Future.delayed(const Duration(seconds: 1));
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'This is permanent and cannot be undone. All your data will be removed.',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: ApiService.deleteAccount()
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}