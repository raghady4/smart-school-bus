class DriverBusModel {
  final int busId;
  final String busNumber;
  final String busName;
  final int studentsCount;
  final List<Student> students;
  final String schoolName;
  final String areaName;

  DriverBusModel({
    required this.busId,
    required this.busNumber,
    required this.studentsCount,
    required this.students,
    required this.areaName,
    required this.busName,
    required this.schoolName,
  });

  factory DriverBusModel.fromJson(Map<String, dynamic> json) {
    return DriverBusModel(
      busId: json['bus_id'],
      busNumber: json['bus_number'],
      studentsCount: json['students_count'],
      students: (json['students'] as List)
          .map((studentJson) => Student.fromJson(studentJson))
          .toList(),
      areaName: json['area_name'],
      busName: json['driver_name'],
      schoolName: json['school_name'],
    );
  }
}

class Student {
  final int studentId;
  final String fullName;
  final String address;

  Student({
    required this.studentId,
    required this.fullName,
    required this.address,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      fullName: json['full_name'],
      address: json['address'],
    );
  }
}