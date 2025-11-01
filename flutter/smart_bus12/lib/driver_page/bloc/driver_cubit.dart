import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:smart_bus/driver_page/bloc/driver_state.dart';
import 'package:smart_bus/driver_page/model/driver_model.dart';
import 'package:smart_bus/driver_page/server/driver_server.dart';

class DriverCubit extends Cubit<DriverState> {
  DriverCubit(this.driverServer) : super(DriverInitial());

  late DriverBusModel driverBusModel;
  final DriverServer driverServer ;

  Future<void> getDriverData() async {
    emit(DriverLoading());
    print("here are Driver");

    final success = await driverServer.getDriverData();

    if (success['success'] == true) {
      driverBusModel = DriverBusModel.fromJson(success['data']);
          emit(DriverSuccess(driverBusModel: driverBusModel));
    } else {
      emit(DriverError('حدث خطأ أثناء جلب البيانات'));
    }
  }
}