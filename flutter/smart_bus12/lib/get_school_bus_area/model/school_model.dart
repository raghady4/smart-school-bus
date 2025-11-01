import 'package:smart_bus/get_school_bus_area/model/area_model.dart';

class School {
  final int schoolId;
  final dynamic name;
  final int areaId;
  
  final Area area;

  School({
    required this.schoolId,
    required this.name,
    required this.areaId,
 
    required this.area,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolId: json['school_id'],
      name: json['name'],
      areaId: json['area_id'],
   
      area: Area.fromJson(json['area']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_id': schoolId,
      'name': name,
      'area_id': areaId,
      'area': area.toJson(),
    };
  }
}
