import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ehanapbuhay/services/api_service.dart';
import 'package:ehanapbuhay/widgets/app_toast.dart';
import 'profile_hero_card.dart' show ProfileHeroCard;
import 'profile_menu.dart' show ProfileMenu;
import 'sheets/edit_profile_sheet.dart' show EditProfileSheet;
import 'sheets/work_documents_sheet.dart' show WorkDocumentsSheet;
import 'sheets/account_settings_sheet.dart' show AccountSettingsSheet;
import 'sheets/contact_info_sheet.dart' show ContactInfoSheet;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  String? _error;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  String? _buildAvatarUrl(String? path) {
    if (path == null) return null;
    if (path.startsWith('http')) return path;
    return 'http://10.0.2.2:3000$path';
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final result = await ApiService.getProfile();
    if (result.success && result.data != null) {
      setState(() {
        _profile = result.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result.error ?? 'Failed to load profile';
        _isLoading = false;
      });
    }
  }

  String _getInitials(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return '?';
    final parts = fullName.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  // ── Image picker ──────────────────────────────────────────────────────────
  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Text(
                'Update Profile Photo',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: _iconBox(Icons.camera_alt_outlined),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  _uploadImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: _iconBox(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _uploadImage(ImageSource.gallery);
                },
              ),
              if (_profile?['avatar_url'] != null)
                ListTile(
                  leading: _iconBox(Icons.delete_outline,
                      bg: Colors.red[50]!,
                      color: Colors.red[400]!),
                  title: Text('Remove photo',
                      style: TextStyle(color: Colors.red[400])),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(appToast('Remove photo — coming soon!'));
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBox(IconData icon,
      {Color bg = const Color(0xFFF5F5F5), Color color = Colors.black87}) {
    return Container(
      width: 36,
      height: 36,
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, size: 18, color: color),
    );
  }

  Future<void> _uploadImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _isUploadingImage = true);
    final result =
        await ApiService.uploadAvatar(imageFile: File(picked.path));
    setState(() => _isUploadingImage = false);

    if (!mounted) return;
    if (result.success) {
      await _loadProfile();
      ScaffoldMessenger.of(context)
          .showSnackBar(appToast('Profile photo updated!'));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          appToast(result.error ?? 'Upload failed', isError: true));
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F7F7),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(
                  onPressed: _loadProfile, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final fullName = _profile?['full_name'] ?? 'Unknown User';
    final email = _profile?['email'] ?? '';
    final phone = _profile?['phone_number'] ?? 'Not set';
    final location = _profile?['location'] ?? 'Not set';
    final role = _profile?['role'] ?? 'jobseeker';
    final initials = _getInitials(fullName);
    final avatarUrl = _buildAvatarUrl(_profile?['avatar_url']);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _openAccountSettings(email),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.settings_outlined,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Hero card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProfileHeroCard(
                  fullName: fullName,
                  location: location,
                  role: role,
                  initials: initials,
                  avatarUrl: avatarUrl,
                  isUploadingImage: _isUploadingImage,
                  onAvatarTap: _showImageOptions,
                  onEditTap: () =>
                      _openEditProfile(fullName, phone, location),
                ),
              ),

              const SizedBox(height: 20),

              // Menu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProfileMenu(
                  onPersonalInfo: () =>
                      _openEditProfile(fullName, phone, location),
                  onContactInfo: () =>
                      _openContactInfo(email, phone, location),
                  onWorkDocuments: _openWorkDocuments,
                  onAccountSettings: () =>
                      _openAccountSettings(email),
                ),
              ),

              const SizedBox(height: 20),

              // Sign out
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _confirmSignOut(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded,
                            size: 18, color: Colors.red[400]),
                        const SizedBox(width: 8),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sheet openers ─────────────────────────────────────────────────────────
  void _openEditProfile(String fullName, String phone, String location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProfileSheet(
        initialName: fullName,
        initialPhone: phone == 'Not set' ? '' : phone,
        initialLocation: location == 'Not set' ? '' : location,
        onSave: (name, ph, loc) async {
          final result = await ApiService.updateProfile(
            fullName: name,
            phone: ph.isNotEmpty ? ph : null,
            location: loc.isNotEmpty ? loc : null,
          );
          if (result.success) {
            await _loadProfile();
            if (mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(appToast('Profile updated!'));
            }
            return true;
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  appToast(result.error ?? 'Update failed', isError: true));
            }
            return false;
          }
        },
      ),
    );
  }

  void _openContactInfo(String email, String phone, String location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ContactInfoSheet(
        email: email,
        phone: phone,
        location: location,
      ),
    );
  }

  void _openWorkDocuments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WorkDocumentsSheet(),
    );
  }

  void _openAccountSettings(String email) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AccountSettingsSheet(
        email: email,
        onSignOut: () {
          Navigator.pop(context);
          _confirmSignOut(context);
        },
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.logout();
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (_) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFEE00),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}