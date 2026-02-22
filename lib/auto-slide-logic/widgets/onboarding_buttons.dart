import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class OnboardingButtons extends StatelessWidget {
  final VoidCallback onGetStarted;

  const OnboardingButtons({
    Key? key,
    required this.onGetStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final horizontalPadding = isMobile ? 40.0 : 60.0;
    final buttonPadding = isMobile ? 16.0 : 20.0;
    final fontSize = isMobile ? 20.0 : 18.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onGetStarted,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: buttonPadding),
            backgroundColor: const Color(0xFFFFEE00),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            'Get Started',
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}