import 'package:ehanapbuhay/onboarding_data/models/auth_result.dart';
import 'package:ehanapbuhay/onboarding_data/models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Mock current user
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Mock login - simulates Azure AD response
  Future<AuthResult> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock users for testing different scenarios
    final mockUsers = {
      'test@gmail.com': {'password': 'test123', 'role': 'user', 'name': 'Test User'}
    };

    if (!mockUsers.containsKey(email)) {
      return AuthResult(success: false, error: 'User not found');
    }

    if (mockUsers[email]!['password'] != password) {
      return AuthResult(success: false, error: 'Incorrect password');
    }

    // Simulate successful login
    _currentUser = UserModel(
      id: 'mock-uid-001',
      name: mockUsers[email]!['name']!,
      email: email,
      role: mockUsers[email]!['role']!,
      token: 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
    );

    return AuthResult(success: true, user: _currentUser);
  }

  Future<AuthResult> signUpWithEmail(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // Simulate account creation
    _currentUser = UserModel(
      id: 'mock-uid-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: 'user',
      token: 'mock-jwt-token-new',
    );

    return AuthResult(success: true, user: _currentUser);
  }

  Future<AuthResult> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = UserModel(
      id: 'mock-google-uid-001',
      name: 'Google User',
      email: 'googleuser@gmail.com',
      role: 'user',
      token: 'mock-google-token',
    );

    return AuthResult(success: true, user: _currentUser);
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  Future<bool> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // Just pretend it sent an email
    return true;
  }
}