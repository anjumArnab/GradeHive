class Student {
  final int? id;
  final String name;
  final int age;
  final String grade;

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.grade,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      age: int.parse(json['age'].toString()),
      grade: json['grade'],
    );
  }

  get row => null;

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'age': age, 'grade': grade};
  }
}
