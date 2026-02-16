import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ehanapbuhay/constants/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Handle login logic
      print('Login pressed');
      print('Email: ${_emailController.text}');
    }
  }

  void _handleGoogleLogin() {
    // Handle Google login
    print('Google Login pressed');
  }

  void _handleForgotPassword() {
    // Handle forgot password
    print('Forgot Password pressed');
  }

  void _handleRegister() {
    // Navigate to sign up screen
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final horizontalPadding = isMobile ? 24.0 : 40.0;
    final titleSize = isMobile ? 24.0 : 28.0;
    final labelSize = isMobile ? 14.0 : 16.0;
    final buttonHeight = isMobile ? 56.0 : 64.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed Top Bar with Back Button (in SafeArea)
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: isMobile ? 12 : 16,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        
          SizedBox(height: isMobile ? 16 : 20),
          
          // Scrollable Content
          Expanded(
            child: MaxWidthBox(
              maxWidth: 600,
              child: ResponsiveScaledBox(
                width: isMobile ? 450 : 600,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: isMobile ? 24 : 32),
                          
                          // Title
                          Text(
                            'Login to your Account',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          
                          SizedBox(height: isMobile ? 32 : 40),
                          
                          // Email Field
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: labelSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'example@gmail.com',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: labelSize,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: isMobile ? 16 : 20,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          
                          SizedBox(height: isMobile ? 20 : 24),
                          
                          // Password Field
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: labelSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Enter your password...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: labelSize,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: isMobile ? 16 : 20,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          
                          SizedBox(height: isMobile ? 32 : 40),
                          
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFEE00),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: isMobile ? 16 : 20),
                          
                          // Forgot Password
                          Center(
                            child: TextButton(
                              onPressed: _handleForgotPassword,
                              child: Text(
                                'Forgot your Password?',
                                style: TextStyle(
                                  color: const Color(0xFFFFEE00),
                                  fontSize: labelSize - 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: isMobile ? 24 : 32),
                          
                          // Divider with text
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Or sign in with',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: labelSize - 2,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey[300])),
                            ],
                          ),
                          
                          SizedBox(height: isMobile ? 24 : 32),
                          
                          // Google Login Button
                          Center(
                            child: InkWell(
                              onTap: _handleGoogleLogin,
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                width: isMobile ? 56 : 64,
                                height: isMobile ? 56 : 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/google_icon.png',
                                    width: isMobile ? 24 : 28,
                                    height: isMobile ? 24 : 28,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback if image not found
                                      return Icon(
                                        Icons.g_mobiledata,
                                        size: isMobile ? 36 : 40,
                                        color: Colors.blue,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: isMobile ? 32 : 40),
                          
                          // Register link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: labelSize - 2,
                                  ),
                                ),
                                TextButton(
                                  onPressed: _handleRegister,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Register here',
                                    style: TextStyle(
                                      color: const Color(0xFFFFEE00),
                                      fontSize: labelSize - 2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: isMobile ? 40 : 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}