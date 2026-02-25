import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    Key? key,
    required this.currentPage,
    required this.pageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get responsive sizes
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final activeWidth = isMobile ? 24.0 : 32.0;
    final inactiveWidth = isMobile ? 8.0 : 10.0;
    final height = isMobile ? 8.0 : 10.0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 6),
          width: currentPage == index ? activeWidth : inactiveWidth,
          height: height,
          decoration: BoxDecoration(
            color: currentPage == index
                ? const Color(0xFFFFEE00)
                : AppColors.pageIndicatorInactive,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}