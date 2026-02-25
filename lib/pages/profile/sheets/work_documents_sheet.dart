import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ehanapbuhay/services/api_service.dart';
import 'package:ehanapbuhay/widgets/sheet_widgets.dart';
import 'package:ehanapbuhay/widgets/app_toast.dart';

class WorkDocumentsSheet extends StatefulWidget {
  const WorkDocumentsSheet({super.key});

  @override
  State<WorkDocumentsSheet> createState() => _WorkDocumentsSheetState();
}

class _WorkDocumentsSheetState extends State<WorkDocumentsSheet> {
  bool _uploadingResume = false;
  bool _uploadingCover = false;
  bool _loadingDocs = true;
  String? _resumeFileName;
  String? _coverFileName;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    final result = await ApiService.getDocuments();
    if (!mounted) return;
    setState(() {
      _loadingDocs = false;
      if (result.success && result.data != null) {
        _resumeFileName = result.data!['resume_name'] as String?;
        _coverFileName = result.data!['cover_name'] as String?;
      }
    });
  }

  Future<void> _upload(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;

    setState(() {
      if (type == 'resume') _uploadingResume = true;
      if (type == 'cover') _uploadingCover = true;
    });

    final uploadResult =
        await ApiService.uploadDocument(type: type, file: file);

    setState(() {
      if (type == 'resume') {
        _uploadingResume = false;
        if (uploadResult.success) {
          _resumeFileName =
              uploadResult.data?['original_name'] as String? ?? fileName;
        }
      }
      if (type == 'cover') {
        _uploadingCover = false;
        if (uploadResult.success) {
          _coverFileName =
              uploadResult.data?['original_name'] as String? ?? fileName;
        }
      }
    });

    if (!mounted) return;
    if (uploadResult.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        appToast(
            '${type == 'resume' ? 'Resume' : 'Cover Letter'} uploaded!'),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        appToast(uploadResult.error ?? 'Upload failed', isError: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: _loadingDocs
          ? const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sheetHandle(),
                sheetHeader(context, 'Work Documents'),
                const SizedBox(height: 8),
                Text(
                  'Upload documents to attach when applying for jobs.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(height: 24),
                _DocTile(
                  icon: Icons.description_outlined,
                  title: 'Resume / CV',
                  subtitle: _resumeFileName ?? 'PDF, DOC, DOCX (max 5MB)',
                  isLoading: _uploadingResume,
                  isUploaded: _resumeFileName != null,
                  onTap: () => _upload('resume'),
                ),
                const SizedBox(height: 12),
                _DocTile(
                  icon: Icons.article_outlined,
                  title: 'Cover Letter',
                  subtitle: _coverFileName ?? 'PDF, DOC, DOCX (max 5MB)',
                  isLoading: _uploadingCover,
                  isUploaded: _coverFileName != null,
                  onTap: () => _upload('cover'),
                ),
                const SizedBox(height: 8),
              ],
            ),
    );
  }
}

class _DocTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLoading;
  final bool isUploaded;
  final VoidCallback onTap;

  const _DocTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isLoading,
    required this.isUploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUploaded ? const Color(0xFFFFEE00) : Colors.grey[200]!,
            width: isUploaded ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFFFEE00), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isUploaded ? Colors.green[600] : Colors.grey[500],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isUploaded
                          ? Colors.green[50]
                          : const Color(0xFFFFEE00),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isUploaded ? 'Replace' : 'Upload',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            isUploaded ? Colors.green[700] : Colors.black,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}