import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/sheets_api.dart';
import '../widgets/student_list_item.dart';
import 'add_student_page.dart';
import 'student_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> _students = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final response = await SheetsApi.getAllStudents();

    setState(() {
      _isLoading = false;
      if (response['status'] == 'success') {
        _students =
            (response['students'] as List)
                .map((studentJson) => Student.fromJson(studentJson))
                .toList();
      } else {
        _errorMessage = response['message'] ?? 'Error fetching students';
      }
    });
  }

  Future<void> _deleteStudent(String id) async {
    final response = await SheetsApi.deleteStudent(id);
    if (response['status'] == 'success') {
      // Update local list without refetching from API
      setState(() {
        _students.removeWhere((student) => student.id == id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Error deleting student'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GradeHive'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddStudentPage()),
              );

              if (result == true) {
                _fetchStudents();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchStudents,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_errorMessage',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _fetchStudents,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
              : _students.isEmpty
              ? const Center(
                child: Text(
                  'No students found.\nAdd your first student by tapping the + button.',
                  textAlign: TextAlign.center,
                ),
              )
              : ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final student = _students[index];
                  return StudentListItem(
                    student: student,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => StudentDetailsPage(student: student),
                        ),
                      );

                      if (result == true) {
                        _fetchStudents();
                      }
                    },
                    onDelete: () => _deleteStudent(student.id),
                  );
                },
              ),
    );
  }
}
