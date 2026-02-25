import 'package:flutter/material.dart';
import 'package:ehanapbuhay/widgets/sheet_widgets.dart';

class EditProfileSheet extends StatefulWidget {
  final String initialName;
  final String initialPhone;
  final String initialLocation;
  final Future<bool> Function(String, String, String) onSave;

  const EditProfileSheet({
    super.key,
    required this.initialName,
    required this.initialPhone,
    required this.initialLocation,
    required this.onSave,
  });

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _locationCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _phoneCtrl = TextEditingController(text: widget.initialPhone);
    _locationCtrl = TextEditingController(text: widget.initialLocation);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sheetHandle(),
              sheetHeader(context, 'Personal Information'),
              const SizedBox(height: 20),
              sheetInputField('Full Name', _nameCtrl, Icons.person_outline),
              const SizedBox(height: 14),
              sheetInputField('Phone Number', _phoneCtrl,
                  Icons.phone_outlined,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 14),
              sheetInputField(
                  'Location', _locationCtrl, Icons.location_on_outlined),
              const SizedBox(height: 24),
              ActionButton(
                label: 'Save Changes',
                isLoading: _isSaving,
                onTap: () async {
                  if (_nameCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Full name cannot be empty')),
                    );
                    return;
                  }
                  setState(() => _isSaving = true);
                  final success = await widget.onSave(
                    _nameCtrl.text.trim(),
                    _phoneCtrl.text.trim(),
                    _locationCtrl.text.trim(),
                  );
                  if (mounted) {
                    setState(() => _isSaving = false);
                    if (success) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}