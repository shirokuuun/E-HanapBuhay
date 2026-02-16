import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get responsive size
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final imageSize = isMobile ? 250.0 : 350.0;
    
    return Container(
      padding: EdgeInsets.only(
        top: isMobile ? 20 : 30,
        bottom: isMobile ? 10 : 15,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/ehanapbuhay.png',
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}