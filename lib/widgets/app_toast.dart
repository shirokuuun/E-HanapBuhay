import 'package:flutter/material.dart';

/// Returns a styled [SnackBar].
/// [isError] swaps yellow for red.
SnackBar appToast(String message, {bool isError = false}) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(
        color: isError ? Colors.white : Colors.black87,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: isError ? Colors.red[400] : const Color(0xFFFFEE00),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 2),
  );
}