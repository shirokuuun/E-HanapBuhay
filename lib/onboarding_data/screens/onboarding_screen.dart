import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:async';
import 'package:ehanapbuhay/constants/app_constants.dart';
import 'package:ehanapbuhay/auto-slide-logic/widgets/app_header.dart';
import 'package:ehanapbuhay/widget/page_indicator.dart';
import 'package:ehanapbuhay/auto-slide-logic/widgets/onboarding_buttons.dart';
import 'package:ehanapbuhay/auto-slide-logic/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(AppConstants.autoSlideDuration, (timer) {
      if (_currentPage < AppConstants.onboardingPages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: AppConstants.pageTransitionDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _handleGetStarted() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive sizes
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final topSpacing = isMobile ? 30.0 : 40.0;
    final indicatorSpacing = isMobile ? 30.0 : 40.0;
    final bottomSpacing = isMobile ? 40.0 : 60.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: MaxWidthBox(
        maxWidth: 800, // Limit width on larger screens
        child: ResponsiveScaledBox(
          width: isMobile ? 450 : 800,
          child: Column(
            children: [
              // Header with logo
              const AppHeader(),

              SizedBox(height: topSpacing),

              // PageView with illustrations
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: AppConstants.onboardingPages.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      data: AppConstants.onboardingPages[index],
                    );
                  },
                ),
              ),

              // Page indicator
              PageIndicator(
                currentPage: _currentPage,
                pageCount: AppConstants.onboardingPages.length,
              ),

              SizedBox(height: indicatorSpacing),

              // Buttons
              OnboardingButtons(onGetStarted: _handleGetStarted),

              SizedBox(height: bottomSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
