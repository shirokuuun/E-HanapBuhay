import 'package:ehanapbuhay/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class OnboardingButtons extends StatelessWidget {
  final VoidCallback onSignUp;
  final VoidCallback onSignIn;

  const OnboardingButtons({
    Key? key,
    required this.onSignUp,
    required this.onSignIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get responsive sizes
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final horizontalPadding = isMobile ? 40.0 : 60.0;
    final buttonPadding = isMobile ? 16.0 : 20.0;
    final fontSize = isMobile ? 20.0 : 18.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onSignUp,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: buttonPadding),
                side: BorderSide(color: const Color(0xFFFFEE00)),
                backgroundColor: AppColors.lightYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: ElevatedButton(
              onPressed: onSignIn,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: buttonPadding),
                backgroundColor: const Color(0xFFFFEE00),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}