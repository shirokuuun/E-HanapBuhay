import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;

  ApiResponse({required this.success, this.data, this.message, this.error});
}

class ApiService {
  // static const String baseUrl = 'http://192.168.8.157:3000/api'; // Real device:
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Emulator:
  // static const String baseUrl = 'http://localhost:3000/api'; // iOS sim:
  // Real device: update IP above

  static const String _tokenKey = 'auth_token';

  // ── Token management ──────────────────────────────────────────────────────

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

  // ── HTTP helpers ──────────────────────────────────────────────────────────

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
      return ApiResponse(
        success: false,
        error: body['message'] ?? 'Request failed',
      );
    } catch (e) {
      return ApiResponse(success: false, error: 'Failed to parse response');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH
  // ═══════════════════════════════════════════════════════════════════════════

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
    final result = _handle<Map<String, dynamic>>(
      response,
      (j) => Map<String, dynamic>.from(j),
    );
    if (result.success && result.data?['token'] != null) {
      await saveToken(result.data!['token']);
    }
    return result;
  }

  static Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    final result = _handle<Map<String, dynamic>>(
      response,
      (j) => Map<String, dynamic>.from(j),
    );
    if (result.success && result.data?['token'] != null) {
      await saveToken(result.data!['token']);
    }
    return result;
  }

  static Future<ApiResponse<Map<String, dynamic>>> getMe() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: await _headers(auth: true),
    );
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  static Future<void> logout() async => clearToken();

  // ═══════════════════════════════════════════════════════════════════════════
  // JOBS
  // ═══════════════════════════════════════════════════════════════════════════

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

  static Future<ApiResponse<List<Map<String, dynamic>>>> getApplications({
    String? status,
  }) async {
    final params = <String, String>{};
    if (status != null && status != 'All') params['status'] = status;

    final uri = Uri.parse(
      '$baseUrl/applications',
    ).replace(queryParameters: params);
    final response = await http.get(uri, headers: await _headers(auth: true));
    return _handle(response, (j) => List<Map<String, dynamic>>.from(j));
  }

  static Future<ApiResponse<Map<String, dynamic>>> submitApplication({
    required String jobId,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String location,
    File? resumeFile,
    File? coverLetterFile,
    required String jobTitle,
    String? companyName,
    DateTime? workFrom,
    DateTime? workTo,
    bool currentlyWorking = false,
    String? workCity,
    String? workDescription,
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
      if (workFrom != null)
        'work_from': workFrom.toIso8601String().split('T').first,
      if (workTo != null) 'work_to': workTo.toIso8601String().split('T').first,
      'currently_working': '$currentlyWorking',
      if (workCity != null) 'work_city': workCity,
      if (workDescription != null) 'work_description': workDescription,
      'school_name': schoolName,
      if (eduCity != null) 'edu_city': eduCity,
      if (degree != null) 'degree': degree,
      if (major != null) 'major': major,
      if (eduFrom != null)
        'edu_from': eduFrom.toIso8601String().split('T').first,
      if (eduTo != null) 'edu_to': eduTo.toIso8601String().split('T').first,
      'currently_studying': '$currentlyStudying',
    });

    if (resumeFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('resume', resumeFile.path),
      );
    }
    if (coverLetterFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('cover_letter', coverLetterFile.path),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SAVED JOBS
  // ═══════════════════════════════════════════════════════════════════════════

  static Future<ApiResponse<List<Map<String, dynamic>>>> getSavedJobs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/saved-jobs'),
      headers: await _headers(auth: true),
    );
    return _handle(response, (j) => List<Map<String, dynamic>>.from(j));
  }

  static Future<ApiResponse<Map<String, dynamic>>> saveJob(String jobId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/saved-jobs'),
      headers: await _headers(auth: true),
      body: jsonEncode({'job_id': jobId}),
    );
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  static Future<ApiResponse<void>> unsaveJob(String jobId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/saved-jobs/$jobId'),
      headers: await _headers(auth: true),
    );
    return _handle(response, (_) {});
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PROFILE  — all under /api/user/...
  // ═══════════════════════════════════════════════════════════════════════════

  /// GET /api/user/profile  (uses JWT token — no ID needed)
  static Future<ApiResponse<Map<String, dynamic>>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'), // ← was /profile
      headers: await _headers(auth: true),
    );
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  /// PUT /api/user/profile  (uses JWT token — no ID needed)
  static Future<ApiResponse<Map<String, dynamic>>> updateProfile({
    String? fullName,
    String? location,
    String? phone,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/profile'), // ← was /profile
      headers: await _headers(auth: true),
      body: jsonEncode({
        if (fullName != null) 'full_name': fullName,
        if (location != null) 'location': location,
        if (phone != null) 'phone_number': phone,
      }),
    );
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  /// POST /api/user/avatar
  static Future<ApiResponse<Map<String, dynamic>>> uploadAvatar({
    required File imageFile,
  }) async {
    final token = await getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/user/avatar'), // ← was /profile/avatar
    );
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    final ext = imageFile.path.split('.').last.toLowerCase();
    final mimeType = ext == 'png' ? 'png' : 'jpeg';
    request.files.add(
      await http.MultipartFile.fromPath(
        'avatar',
        imageFile.path,
        contentType: MediaType('image', mimeType),
      ),
    );
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  /// GET /api/user/documents
  static Future<ApiResponse<Map<String, dynamic>>> getDocuments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/documents'), // ← was /profile/documents
      headers: await _headers(auth: true),
    );
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }

  /// POST /api/user/documents
  static Future<ApiResponse<Map<String, dynamic>>> uploadDocument({
    required String type,
    required File file,
  }) async {
    final token = await getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/user/documents'), // ← was /profile/documents
    );
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    final ext = file.path.split('.').last.toLowerCase();
    final mimeMap = {
      'pdf': MediaType('application', 'pdf'),
      'doc': MediaType('application', 'msword'),
      'docx': MediaType(
        'application',
        'vnd.openxmlformats-officedocument.wordprocessingml.document',
      ),
    };

    request.fields['document_type'] = type;
    request.files.add(
      await http.MultipartFile.fromPath(
        type == 'resume' ? 'resume' : 'cover_letter',
        file.path,
        contentType: mimeMap[ext] ?? MediaType('application', 'octet-stream'),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handle(response, (j) => Map<String, dynamic>.from(j));
  }
}
