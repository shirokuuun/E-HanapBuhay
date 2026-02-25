import 'package:flutter/material.dart';

/// The e-HanapBuhay branded logo row used in screen headers.
/// Pass [size] to scale (default 48). The logo image + wordmark sit
/// side-by-side and can be used on any screen.
class AppLogoHeader extends StatelessWidget {
  final double size;

  const AppLogoHeader({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            'assets/ehanapbuhay.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFEE00),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.work, size: size * 0.45),
            ),
          ),
        ),
        const SizedBox(width: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'e-',
                style: TextStyle(
                  color: const Color(0xFFF8E806),
                  fontSize: size * 0.375,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'HanapBuhay',
                style: TextStyle(
                  color: const Color(0xFF0274E5),
                  fontSize: size * 0.375,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}