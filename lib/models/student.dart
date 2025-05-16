class Student {
  final String name;
  final String age;
  final String grade;
  final int? row;

  Student({
    required this.name,
    required this.age,
    required this.grade,
    this.row,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    name: json['name'],
    age: json['age'],
    grade: json['grade'],
    row: json['row'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'grade': grade,
    if (row != null) 'row': row,
  };
}
