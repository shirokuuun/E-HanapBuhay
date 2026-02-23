import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// API SERVICE
// Drop this file into:  lib/services/api_service.dart
//
// Add to pubspec.yaml dependencies:
//   http: ^1.2.0
//   shared_preferences: ^2.2.3
// ─────────────────────────────────────────────────────────────────────────────

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });
}

class ApiService {
  // ── Change this to your local IP when running on a real device ──────────
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android emulator
  // static const String baseUrl = 'http://localhost:3000/api'; // iOS simulator
  // static const String baseUrl = 'http://YOUR_LOCAL_IP:3000/api'; // Real device

  static const String _tokenKey = 'auth_token';

  // ── Token management ─────────────────────────────────────────────────────

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ── HTTP helpers ─────────────────────────────────────────────────────────

  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static ApiResponse<T> _handle<T>(
    http.Response response,
    T Function(dynamic json) fromJson,
  ) {
    try {
      final body = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          data: body['data'] != null ? fromJson(body['data']) : null,
          message: body['message'],
        );
      }
      return ApiResponse(success: false, error: body['message'] ?? 'Request failed');
    } catch (e) {
      return ApiResponse(success: false, error: 'Failed to parse response');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  /// POST /api/auth/register
  static Future<ApiResponse<Map<String, dynamic>>> register({
    required String fullName,
    required String email,
    required String password,
    String? location,
    String? phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _headers(),
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'password': password,
        if (location != null) 'location': location,
        if (phone != null) 'phone': phone,
      }),
    );
    final result = _handle<Map<String, dynamic>>(response, (j) => Map<String, dynamic>.from(j));
    if (result.success && result.data?['token'] != null) {
      await saveToken(result.data!['token']);
    }
    return result;
  }

  /// POST /api/auth/login
  static Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    final result = _handle<Map<String, dynamic>>(response, (j) => Map<String, dynamic>.from(j));
    if (result.success && result.data?['token'] != null) {
      await saveToken(result.data!['token']);
    }
    return result;
  }

  /// GET /api/auth/me
  static Future<ApiResponse<Map<String, dynamic>>> getMe() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: await _headers(auth: true),
    );
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  /// Logout — just clears the local token
  static Future<void> logout() async => clearToken();

  // ═══════════════════════════════════════════════════════════════════════════
  // JOBS
  // ═══════════════════════════════════════════════════════════════════════════

  /// GET /api/jobs?work_setup=Remote&search=designer&page=1
  static Future<ApiResponse<Map<String, dynamic>>> getJobs({
    String? workSetup,
    String? search,
    int page = 1,
  }) async {
    final params = <String, String>{'page': '$page'};
    if (workSetup != null) params['work_setup'] = workSetup;
    if (search != null && search.isNotEmpty) params['search'] = search;

    final uri = Uri.parse('$baseUrl/jobs').replace(queryParameters: params);
    final response = await http.get(uri, headers: await _headers(auth: true));
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  /// GET /api/jobs/:id
  static Future<ApiResponse<Map<String, dynamic>>> getJobById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/$id'),
      headers: await _headers(auth: true),
    );
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // APPLICATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// GET /api/applications?status=Applied
  static Future<ApiResponse<List<Map<String, dynamic>>>> getApplications({
    String? status,
  }) async {
    final params = <String, String>{};
    if (status != null && status != 'All') params['status'] = status;

    final uri = Uri.parse('$baseUrl/applications').replace(queryParameters: params);
    final response = await http.get(uri, headers: await _headers(auth: true));
    return _handle(response, (j) => List<Map<String, dynamic>>.from(j));
  }

  /// POST /api/applications  — multipart (includes file upload)
  static Future<ApiResponse<Map<String, dynamic>>> submitApplication({
    required String jobId,
    // Step 1
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String location,
    // Step 2
    File? resumeFile,
    File? coverLetterFile,
    // Step 3
    required String jobTitle,
    String? companyName,
    DateTime? workFrom,
    DateTime? workTo,
    bool currentlyWorking = false,
    String? workCity,
    String? workDescription,
    // Step 4
    required String schoolName,
    String? eduCity,
    String? degree,
    String? major,
    DateTime? eduFrom,
    DateTime? eduTo,
    bool currentlyStudying = false,
  }) async {
    final token = await getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/applications'),
    );

    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'job_id': jobId,
      'applicant_first_name': firstName,
      'applicant_last_name': lastName,
      'applicant_phone': phone,
      'applicant_email': email,
      'applicant_location': location,
      'job_title': jobTitle,
      if (companyName != null) 'company_name': companyName,
      if (workFrom != null) 'work_from': workFrom.toIso8601String().split('T').first,
      if (workTo != null) 'work_to': workTo.toIso8601String().split('T').first,
      'currently_working': '$currentlyWorking',
      if (workCity != null) 'work_city': workCity,
      if (workDescription != null) 'work_description': workDescription,
      'school_name': schoolName,
      if (eduCity != null) 'edu_city': eduCity,
      if (degree != null) 'degree': degree,
      if (major != null) 'major': major,
      if (eduFrom != null) 'edu_from': eduFrom.toIso8601String().split('T').first,
      if (eduTo != null) 'edu_to': eduTo.toIso8601String().split('T').first,
      'currently_studying': '$currentlyStudying',
    });

    if (resumeFile != null) {
      request.files.add(await http.MultipartFile.fromPath('resume', resumeFile.path));
    }
    if (coverLetterFile != null) {
      request.files.add(await http.MultipartFile.fromPath('cover_letter', coverLetterFile.path));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SAVED JOBS
  // ═══════════════════════════════════════════════════════════════════════════

  /// GET /api/saved-jobs
  static Future<ApiResponse<List<Map<String, dynamic>>>> getSavedJobs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/saved-jobs'),
      headers: await _headers(auth: true),
    );
    return _handle(response, (j) => List<Map<String, dynamic>>.from(j));
  }

  /// POST /api/saved-jobs
  static Future<ApiResponse<Map<String, dynamic>>> saveJob(String jobId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/saved-jobs'),
      headers: await _headers(auth: true),
      body: jsonEncode({'job_id': jobId}),
    );
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  /// DELETE /api/saved-jobs/:jobId
  static Future<ApiResponse<void>> unsaveJob(String jobId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/saved-jobs/$jobId'),
      headers: await _headers(auth: true),
    );
    return _handle(response, (_) {});
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PROFILE
  // ═══════════════════════════════════════════════════════════════════════════

  /// GET /api/profile
  static Future<ApiResponse<Map<String, dynamic>>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: await _headers(auth: true),
    );
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  /// PUT /api/profile
  static Future<ApiResponse<Map<String, dynamic>>> updateProfile({
    String? fullName,
    String? location,
    String? phone,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: await _headers(auth: true),
      body: jsonEncode({
        if (fullName != null) 'full_name': fullName,
        if (location != null) 'location': location,
        if (phone != null) 'phone': phone,
      }),
    );
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }
}
