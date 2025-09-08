import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../widgets/action_button.dart';
import 'details_form.dart';

class StudentDetails extends StatefulWidget {
  final Student student;

  const StudentDetails({super.key, required this.student});

  @override
  State<StudentDetails> createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  late Student student;

  @override
  void initState() {
    super.initState();
    // Create a copy of the student to avoid modifying the original
    student = Student(
      id: widget.student.id,
      name: widget.student.name,
      age: widget.student.age,
      grade: widget.student.grade,
    );
  }

  Future<void> _deleteStudent() async {
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
      final provider = context.read<StudentProvider>();
      final success = await provider.deleteStudent(student.id!);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${student.name} deleted successfully')),
        );
        Navigator.pop(context); // Return to previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to delete student'),
          ),
        );
      }
    }
  }

  void _editStudent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsForm(student: student)),
    ).then((updated) {
      if (updated == true) {
        Navigator.pop(context, true); // Return to home page
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Student Details'),
        actions: [
          Consumer<StudentProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.delete),
                onPressed: provider.isLoading ? null : _deleteStudent,
              );
            },
          ),
        ],
      ),
      body: Consumer<StudentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Age', student.age.toString()),
                        const Divider(),
                        _buildInfoRow('Grade', student.grade),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ActionButton(label: 'Edit Details', onPressed: _editStudent),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
