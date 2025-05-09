import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class SheetsApi {
  // Replace with your Google Apps Script web app URL after deployment
  // This URL will be provided after deploying the Google Apps Script
  static const String _scriptUrl =
      'https://script.google.com/macros/s/AKfycbz88iv8P-Eh4KpClsO9ufc910pBBjpEYbXpgDfWLxKKBhc8ybZCsPi2-nzh6fqtdLFM3g/exec';

  // Create a new student
  static Future<Map<String, dynamic>> createStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse(_scriptUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'create', 'student': student.toJson()}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status': 'error',
          'message':
              'Failed to create student. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Exception occurred: $e'};
    }
  }

  // Get all students
  static Future<Map<String, dynamic>> getAllStudents() async {
    try {
      final response = await http.post(
        Uri.parse(_scriptUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'read'}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return {
          'status': 'error',
          'message':
              'Failed to fetch students. Status code: ${response.statusCode}',
          'students': [],
        };
      }
    } catch (e) {
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
      final response = await http.post(
        Uri.parse(_scriptUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'get', 'id': id}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status': 'error',
          'message':
              'Failed to fetch student. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Exception occurred: $e'};
    }
  }

  // Update an existing student
  static Future<Map<String, dynamic>> updateStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse(_scriptUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'update', 'student': student.toJson()}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status': 'error',
          'message':
              'Failed to update student. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Exception occurred: $e'};
    }
  }

  // Delete a student
  static Future<Map<String, dynamic>> deleteStudent(String id) async {
    try {
      final response = await http.post(
        Uri.parse(_scriptUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'delete', 'id': id}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status': 'error',
          'message':
              'Failed to delete student. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Exception occurred: $e'};
    }
  }
}
