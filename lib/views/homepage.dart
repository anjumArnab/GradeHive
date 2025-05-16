import 'package:flutter/material.dart';
import 'package:grade_hive/services/sheet_api.dart';
import 'package:grade_hive/views/student_details.dart';
import '../widgets/grade_tile.dart';
import 'details_form.dart';
import '../models/student.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      isLoading = true;
    });

    final fetchedStudents = await SheetAPI.getStudents();

    setState(() {
      students = fetchedStudents ?? [];
      isLoading = false;
    });
  }

  void _editStudent(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsForm(student: students[index]),
      ),
    ).then((_) => _loadStudents());
  }

  void _deleteStudent(int index) async {
    final student = students[index];

    // Show confirmation dialog
    bool confirm =
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Delete Student'),
                content: Text(
                  'Are you sure you want to delete ${student.name}?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
        ) ??
        false;

    if (confirm) {
      setState(() {
        isLoading = true;
      });

      bool success = await SheetAPI.deleteStudent(student.row!);

      setState(() {
        isLoading = false;
      });

      if (success) {
        _loadStudents();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${student.name} deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete ${student.name}')),
        );
      }
    }
  }

  void _viewStudentDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetails(student: students[index]),
      ),
    ).then((_) => _loadStudents());
  }

  void _addNewStudent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DetailsForm()),
    ).then((_) => _loadStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GradeHive'),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        shape: const CircleBorder(), // Explicitly makes it circular
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _addNewStudent(context),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple),
                )
                : students.isEmpty
                ? Center(
                  child: Text(
                    'Empty.\nTap + to add a student.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
                : RefreshIndicator(
                  onRefresh: _loadStudents,
                  child: ListView.separated(
                    separatorBuilder:
                        (BuildContext context, int index) => const Divider(),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return GradeTile(
                        student: students[index],
                        onTap: () => _viewStudentDetails(index),
                        onEdit: () => _editStudent(index),
                        onDelete: () => _deleteStudent(index),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
