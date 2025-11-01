class Bus {
  final int busId;
  final String busNumber;
  final String driverName;
  final String schoolName;
  final AreaBus area;
  final int studentsCount;
  final bool isActive;

  Bus({
    required this.busId,
    required this.busNumber,
    required this.driverName,
    required this.schoolName,
    required this.area,
    required this.studentsCount,
    required this.isActive,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busId: json['bus_id'],
      busNumber: json['bus_number'],
      driverName: json['driver_name'],
      schoolName: json['school_name'],
      area: AreaBus.fromJson(json['area']),
      studentsCount: json['students_count'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bus_id': busId,
      'bus_number': busNumber,
      'driver_name': driverName,
      'school_name': schoolName,
      'area': area.toJson(),
      'students_count': studentsCount,
      'is_active': isActive,
    };
  }
}
class AreaBus {
  final int areaId;
  final String name;

  AreaBus({
    required this.areaId,
    required this.name,
  });

  factory AreaBus.fromJson(Map<String, dynamic> json) {
    return AreaBus(
      areaId: json['area_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area_id': areaId,
      'name': name,
    };
  }
}
