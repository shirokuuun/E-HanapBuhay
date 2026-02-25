import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SHEET HANDLE
// ─────────────────────────────────────────────────────────────────────────────
Widget sheetHandle() {
  return Center(
    child: Container(
      margin: const EdgeInsets.only(top: 12, bottom: 20),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SHEET HEADER  (title + close button)
// ─────────────────────────────────────────────────────────────────────────────
Widget sheetHeader(BuildContext context, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.close, size: 16),
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// INPUT FIELD  (label + text field)
// ─────────────────────────────────────────────────────────────────────────────
Widget sheetInputField(
  String label,
  TextEditingController controller,
  IconData icon, {
  TextInputType keyboardType = TextInputType.text,
  bool obscure = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 18, color: Colors.black54),
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFFEE00), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION BUTTON  (save / submit with loading state)
// ─────────────────────────────────────────────────────────────────────────────
class ActionButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey[300] : const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(14),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}