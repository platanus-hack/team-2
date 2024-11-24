// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/git_commit.dart';

class ApiResponse {
  final String answer;
  final List<GitCommit> context;

  ApiResponse({required this.answer, required this.context});
}

class ApiService {
  static const String baseUrl = 'http://44.220.161.130:5000';  // Update with your server IP
  static const String username = 'test';
  static const String password = 'test';

  static Future<ApiResponse> getChatResponse(String message, String role) async {
    try {
      final uri = Uri.parse('$baseUrl/rag').replace(
        queryParameters: {
          'input': message,
          'user_role': role,
        },
      );

      print('Debug URL: ${uri.toString()}');

      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

      final response = await http.get(
        uri,
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Remove CORS headers from client - they should be on server only
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse(
          answer: data['answer'] ?? '',
          context: (data['context'] as List)
              .map((c) => GitCommit.fromJson(c))
              .toList(),
        );
      }

      throw Exception('API failed: ${response.statusCode}');
    } catch (e) {
      print('Exception details: $e');
      return ApiResponse(
        answer: 'Failed to get response: $e', 
        context: [],
      );
    }
  }
}