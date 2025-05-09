class Student {
  final String id;
  final String name;
  final String result;

  Student({required this.id, required this.name, this.result = ''});

  // Convert Student object to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'result': result};
  }

  // Create Student object from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      result: json['result'] ?? '',
    );
  }

  // Create a copy of Student with optional new values
  Student copyWith({String? id, String? name, String? result}) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      result: result ?? this.result,
    );
  }
}
