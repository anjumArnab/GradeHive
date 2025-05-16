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
        if (data['success']) {
          return Student.fromJson(data['data']);
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
        final data = jsonDecode(response.body);
        if (data['success']) {
          return (data['data'] as List)
              .map((e) => Student.fromJson(e))
              .toList();
        }
      }
      return null;
    } catch (e) {
      log("Error fetching students: $e");
      return null;
    }
  }

  // UPDATE
  static Future<bool> updateStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'action': 'update',
          'id': student.id.toString(), // row index from the sheet
          'name': student.name,
          'age': student.age.toString(),
          'grade': student.grade,
        },
      );

      final data = jsonDecode(response.body);
      return data['success'] == true;
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

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      log("Error deleting student: $e");
      return false;
    }
  }
}
