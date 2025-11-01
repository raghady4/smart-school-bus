class AdminSchoolModel {
  final int schoolId;
  final String schoolName;
  final int busesCount;
  final List<Bus> buses;

  AdminSchoolModel({
    required this.schoolId,
    required this.schoolName,
    required this.busesCount,
    required this.buses,
  });

  factory AdminSchoolModel.fromJson(Map<String, dynamic> json) {

    return AdminSchoolModel(
      schoolId: json['school_id'],
      schoolName: json['school_name'],
      busesCount: json['buses_count'],
      buses: (json['buses'] as List)
          .map((busesJson) => Bus.fromJson(busesJson))
          .toList(),
    );
  }
}

class Bus {
  final int busId;
  final String busNumber;
  final String driver;

  Bus({
    required this.busId,
    required this.busNumber,
    required this.driver,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busId: json['bus_id'],
      busNumber: json['bus_number'],
      driver: json['driver'],
    );
  }
}