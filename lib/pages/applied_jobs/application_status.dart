import 'package:flutter/material.dart';

enum ApplicationStatus { applied, viewed, accepted, rejected }

extension ApplicationStatusExt on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.viewed:
        return 'Viewed';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case ApplicationStatus.applied:
        return const Color(0xFF2196F3);
      case ApplicationStatus.viewed:
        return const Color(0xFFFF9800);
      case ApplicationStatus.accepted:
        return const Color(0xFF4CAF50);
      case ApplicationStatus.rejected:
        return const Color(0xFFF44336);
    }
  }

  Color get bgColor {
    switch (this) {
      case ApplicationStatus.applied:
        return const Color(0xFFE3F2FD);
      case ApplicationStatus.viewed:
        return const Color(0xFFFFF3E0);
      case ApplicationStatus.accepted:
        return const Color(0xFFE8F5E9);
      case ApplicationStatus.rejected:
        return const Color(0xFFFFEBEE);
    }
  }

  IconData get icon {
    switch (this) {
      case ApplicationStatus.applied:
        return Icons.send_rounded;
      case ApplicationStatus.viewed:
        return Icons.visibility_outlined;
      case ApplicationStatus.accepted:
        return Icons.check_circle_outline_rounded;
      case ApplicationStatus.rejected:
        return Icons.cancel_outlined;
    }
  }
}