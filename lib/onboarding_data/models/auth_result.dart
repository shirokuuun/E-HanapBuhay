import 'package:ehanapbuhay/onboarding_data/models/user_model.dart';

class AuthResult {
  final bool success;
  final String? error;
  final UserModel? user;

  AuthResult({required this.success, this.error, this.user});
}