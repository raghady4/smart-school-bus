class StudentModel {
  final int studentId;
  final String fullName;
  final String? photo;
  final String address;
  final String nfcLogsId;
  final String status;
  final Parent parent;
  final Bus bus;
  final DateTime createdAt;

  StudentModel({
    required this.studentId,
    required this.fullName,
    this.photo,
    required this.address,
    required this.nfcLogsId,
    required this.status,
    required this.parent,
    required this.bus,
    required this.createdAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['student_id'],
      fullName: json['full_name'],
      photo: json['photo'],
      address: json['address'],
      nfcLogsId: json['nfc_logs_id'],
      status: json['status'],
      parent: Parent.fromJson(json['parent']),
      bus: Bus.fromJson(json['bus']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}


class Parent {
  final int userId;
  final String fullName;
  final String phone;

  Parent({
    required this.userId,
    required this.fullName,
    required this.phone,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      userId: json['user_id'],
      fullName: json['full_name'],
      phone: json['phone'],
    );
  }
}


class Bus {
  final int busId;
  final String number;
  final String color;

  Bus({
    required this.busId,
    required this.number,
    required this.color,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busId: json['bus_id'],
      number: json['number'],
      color: json['color'],
    );
  }
}
