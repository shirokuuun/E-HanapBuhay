import 'package:ehanapbuhay/onboarding_data/models/onboarding_data.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryYellow = Color(0xFFFBBF24);
  static const Color lightYellow = Color(0xFFFEF9C3);
  static const Color darkBlue = Color(0xFF1E3A8A);
  static const Color pageIndicatorInactive = Color(0xFFE5E7EB);
  
  // Onboarding backgrounds
  static const Color onboarding1Bg = Color(0xFFFFE5D9);
  static const Color onboarding2Bg = Color(0xFFD4E7FF);
  static const Color onboarding3Bg = Color(0xFFCCEEFF);
}

class AppConstants {
  static const Duration autoSlideDuration = Duration(seconds: 3);
  static const Duration pageTransitionDuration = Duration(milliseconds: 400);
  
  static List<OnboardingData> onboardingPages = [
    OnboardingData(
      title: 'Land your Job',
      description: 'Connect, Apply, and Get Hired\nwith your favorite job around Manila',
      backgroundColor: AppColors.onboarding1Bg,
      illustration: 'assets/onboarding1.png',
    ),
    OnboardingData(
      title: 'Career Moves Made Easy',
      description: 'Skip the endless searching. Get matched\nwith jobs in Manila that actually fit your skills',
      backgroundColor: AppColors.onboarding2Bg,
      illustration: 'assets/onboarding2.png',
    ),
    OnboardingData(
      title: 'Find Work You\'ll Love',
      description: 'We bridge the gap between Manila\'s\nbrightest talent and its most exciting workplaces',
      backgroundColor: AppColors.onboarding3Bg,
      illustration: 'assets/onboarding3.png',
    ),
  ];
}