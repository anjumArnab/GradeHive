import 'package:flutter/material.dart';
import 'package:grade_hive/models/student.dart';
import 'package:grade_hive/services/sheet_api.dart';

class StudentProvider extends ChangeNotifier {
  List<Student> _students = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Student> get students => _students;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Fetch all students
  Future<void> fetchStudents() async {
    _setLoading(true);
    _setError(null);

    try {
      final students = await SheetAPI.getStudents();
      if (students != null) {
        _students = students;
      } else {
        _setError('Failed to fetch students');
      }
    } catch (e) {
      _setError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create a new student
  Future<bool> createStudent(Student student) async {
    _setLoading(true);
    _setError(null);

    try {
      final createdStudent = await SheetAPI.createStudent(student);
      if (createdStudent != null) {
        await fetchStudents(); // Refresh the list
        return true;
      } else {
        _setError('Failed to create student');
        return false;
      }
    } catch (e) {
      _setError('Error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing student
  Future<bool> updateStudent(int id, Student student) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await SheetAPI.updateStudent(id, student);
      if (success) {
        await fetchStudents(); // Refresh the list
        return true;
      } else {
        _setError('Failed to update student');
        return false;
      }
    } catch (e) {
      _setError('Error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete a student
  Future<bool> deleteStudent(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await SheetAPI.deleteStudent(id);
      if (success) {
        await fetchStudents(); // Refresh the list
        return true;
      } else {
        _setError('Failed to delete student');
        return false;
      }
    } catch (e) {
      _setError('Error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Clear error message
  void clearError() {
    _setError(null);
  }
}
