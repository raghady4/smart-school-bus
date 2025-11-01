
import 'package:smart_bus/admin_page/model/admin_page_model.dart';

abstract class AdminSchoolState {}

class AdminSchoolInitial extends AdminSchoolState {}

class AdminSchoolLoading extends AdminSchoolState {}

class AdminSchoolSuccess extends AdminSchoolState {
  AdminSchoolModel adminSchoolModel;
  AdminSchoolSuccess({required this.adminSchoolModel});
}

class AdminSchoolError extends AdminSchoolState {
  final String message;
  AdminSchoolError(this.message);
}