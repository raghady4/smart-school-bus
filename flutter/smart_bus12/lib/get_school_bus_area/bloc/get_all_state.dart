import 'package:smart_bus/get_school_bus_area/model/area_model.dart';
import 'package:smart_bus/get_school_bus_area/model/bus_model.dart';
import 'package:smart_bus/get_school_bus_area/model/school_model.dart';

abstract class GetAllState {}

class GetAllInitial extends GetAllState {}

class GetAllLoading extends GetAllState {}

class GetAllSuccess extends GetAllState {
  List<Area> areas;
  List<Bus> buses;
  List<School> schools;
  GetAllSuccess(this.areas, this.buses, this.schools);
}

class GetAllError extends GetAllState {
  final String message;
  GetAllError(this.message);
}
