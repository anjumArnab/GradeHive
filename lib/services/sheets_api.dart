import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class SheetsApi {
  // Replace with your new Google Apps Script web app URL after deployment
  static const String _scriptUrl =
      'https://script.google.com/macros/s/AKfycby72e0j0ZmBLjFjHz_BqpW-LvaqgzYB0eLfhIlNCVg/dev';

  // Add a timeout to prevent the app from hanging
  static const Duration _timeout = Duration(seconds: 15);

  // Create a new student
  static Future<Map<String, dynamic>> createStudent(Student student) async {
    try {
      final response = await http
          .post(
            Uri.parse(_scriptUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'action': 'create',
              'student': student.toJson(),
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {
          'status': 'error',
          'message':
              'Failed to create student. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Exception details: $e');
      return {'status': 'error', 'message': 'Exception occurred: $e'};
    }
  }

  // Get all students
  static Future<Map<String, dynamic>> getAllStudents() async {
    try {
      print('Fetching all students from: $_scriptUrl');

      final response = await http
          .post(
            Uri.parse(_scriptUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'action': 'read'}),
          )
          .timeout(_timeout);

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print('Response body: ${response.body}');
        return {
          'status': 'error',
          'message':
              'Failed to fetch students. Status code: ${response.statusCode}',
          'students': [],
        };
      }
    } catch (e) {
      print('Exception details: $e');
      return {
        'status': 'error',
        'message': 'Exception occurred: $e',
        'students': [],
      };
    }
  }

  // Get a specific student by ID
  static Future<Map<String, dynamic>> getStudent(String id) async {
    try {
      final response = await http
          .post(
            Uri.parse(_scriptUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'action': 'get', 'id': id}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {
          'status': 'error',
          'message':
              'Failed to fetch student. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Exception details: $e');
      return {'status': 'error', 'message': 'Exception occurred: $e'};
    }
  }

  // Update an existing student
  static Future<Map<String, dynamic>> updateStudent(Student student) async {
    try {
      final response = await http
          .post(
            Uri.parse(_scriptUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'action': 'update',
              'student': student.toJson(),
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {
          'status': 'error',
          'message':
              'Failed to update student. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Exception details: $e');
      return {'status': 'error', 'message': 'Exception occurred: $e'};
    }
  }

  // Delete a student
  static Future<Map<String, dynamic>> deleteStudent(String id) async {
    try {
      final response = await http
          .post(
            Uri.parse(_scriptUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'action': 'delete', 'id': id}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {
          'status': 'error',
          'message':
              'Failed to delete student. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Exception details: $e');
      return {'status': 'error', 'message': 'Exception occurred: $e'};
    }
  }

  // Simple method to test connectivity with the Apps Script
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse(_scriptUrl)).timeout(_timeout);

      print('Test connection status code: ${response.statusCode}');
      print('Test connection response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Test connection exception: $e');
      return false;
    }
  }
}
