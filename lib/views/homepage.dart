import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../views/student_details.dart';
import '../widgets/grade_tile.dart';
import 'details_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load students when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProvider>().fetchStudents();
    });
  }

  void _editStudent(int index) {
    final students = context.read<StudentProvider>().students;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsForm(student: students[index]),
      ),
    );
  }

  void _deleteStudent(int index) async {
    final provider = context.read<StudentProvider>();
    final student = provider.students[index];

    if (student.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete student without ID')),
      );
      return;
    }

    // Show confirmation dialog
    bool confirm =
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Delete Student'),
                content: Text(
                  'Are you sure you want to delete ${student.name}?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;

    if (confirm) {
      final success = await provider.deleteStudent(student.id!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${student.name} deleted successfully')),
        );
      }
    }
  }

  void _viewStudentDetails(int index) {
    final students = context.read<StudentProvider>().students;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetails(student: students[index]),
      ),
    );
  }

  void _addNewStudent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DetailsForm()),
    );
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
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _addNewStudent(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Consumer<StudentProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              );
            }

            if (provider.students.isEmpty) {
              return Center(
                child: Text(
                  'Empty.\nTap + to add a student.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: provider.fetchStudents,
              child: ListView.separated(
                separatorBuilder:
                    (BuildContext context, int index) => const Divider(),
                itemCount: provider.students.length,
                itemBuilder: (context, index) {
                  return GradeTile(
                    student: provider.students[index],
                    onTap: () => _viewStudentDetails(index),
                    onEdit: () => _editStudent(index),
                    onDelete: () => _deleteStudent(index),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
