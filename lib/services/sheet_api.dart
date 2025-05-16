import 'dart:convert';
import 'dart:developer';
import 'package:grade_hive/models/student.dart';
import 'package:http/http.dart' as http;

class SheetAPI {
  static const String baseUrl =
      'https://script.google.com/macros/s/YOUR_SCRIPT_ID/exec';

  // Create Student
  static Future<Student?> createStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'create', ...student.toJson()}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Student.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      log("Error creating student: $e");
      return null;
    }
  }

  // Read Students
  static Future<List<Student>?> getStudents() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'read'}),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((student) => Student.fromJson(student)).toList();
      }
      return null;
    } catch (e) {
      log("Error fetching students: $e");
      return null;
    }
  }

  // Update Student
  static Future<Student?> updateStudent(String name, Student student) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'update',
          'searchName':
              name, // Using name as identifier for which student to update
          ...student.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        return Student.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      log("Error updating student: $e");
      return null;
    }
  }

  // Update Student Partially
  static Future<bool> updateStudentPartially(
    String name,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'updatePartial',
          'name': name,
          ...updatedData,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      log("Error updating student partially: $e");
      return false;
    }
  }

  // Delete Student
  static Future<bool> deleteStudent(String name) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'delete', 'name': name}),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      log("Error deleting student: $e");
      return false;
    }
  }
}
