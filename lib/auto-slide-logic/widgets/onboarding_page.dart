import 'package:ehanapbuhay/onboarding_data/models/onboarding_data.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get responsive sizes
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final containerHeight = isMobile ? 300.0 : 400.0;
    final horizontalPadding = isMobile ? 24.0 : 40.0;
    final titleSize = isMobile ? 24.0 : 32.0;
    final descSize = isMobile ? 14.0 : 16.0;
    
    return Column(
      children: [
        // Illustration container
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
          height: containerHeight,
          decoration: BoxDecoration(
            color: data.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: _buildIllustration(isMobile)),
        ),

        SizedBox(height: isMobile ? 30 : 40),

        // Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            data.title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: isMobile ? 16 : 20),

        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding + 16),
          child: Text(
            data.description,
            style: TextStyle(
              fontSize: descSize,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration(bool isMobile) {
    final imageSize = isMobile ? 200.0 : 280.0;
    
    return Image.asset(
      data.illustration,
      fit: BoxFit.contain,
      width: imageSize,
      height: imageSize,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.work_outline, 
          size: isMobile ? 80 : 100, 
          color: Colors.blue[700],
        );
      },
    );
  }
}