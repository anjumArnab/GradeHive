import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:grade_hive/models/student.dart';
import 'package:grade_hive/services/app_script_url.dart';

class SheetAPI {
  static const String baseUrl = APP_SCRIPT_URL;

  // CREATE
  static Future<Student?> createStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'action': 'create',
          'name': student.name,
          'age': student.age.toString(),
          'grade': student.grade,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'SUCCESS') {
          return student;
        }
      }
      return null;
    } catch (e) {
      log("Error creating student: $e");
      return null;
    }
  }

  // READ
  static Future<List<Student>?> getStudents() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // Log the raw response for debugging
        log("Raw API response: ${response.body}");

        final List<dynamic> data = jsonDecode(response.body);

        // More robust parsing with additional logging
        List<Student> students = [];
        for (var json in data) {
          try {
            log("Processing student JSON: $json");
            students.add(Student.fromJson(json));
          } catch (e) {
            log("Error parsing student: $e");
            // Continue with the next item instead of failing completely
          }
        }

        return students;
      }
      return null;
    } catch (e) {
      log("Error fetching students: $e");
      return null;
    }
  }

  // UPDATE
  static Future<bool> updateStudent(int id, Student student) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'action': 'update',
          'id': id.toString(),
          'name': student.name,
          'age': student.age.toString(),
          'grade': student.grade,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'SUCCESS';
      }
      return false;
    } catch (e) {
      log("Error updating student: $e");
      return false;
    }
  }

  // DELETE
  static Future<bool> deleteStudent(int id) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'action': 'delete', 'id': id.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'SUCCESS';
      }
      return false;
    } catch (e) {
      log("Error deleting student: $e");
      return false;
    }
  }
}
