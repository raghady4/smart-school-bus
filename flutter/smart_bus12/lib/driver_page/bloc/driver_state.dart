import 'package:smart_bus/driver_page/model/driver_model.dart';

abstract class DriverState {}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverSuccess extends DriverState {
  DriverBusModel driverBusModel;
  DriverSuccess({required this.driverBusModel});
}

class DriverError extends DriverState {
  final String message;
  DriverError(this.message);
}