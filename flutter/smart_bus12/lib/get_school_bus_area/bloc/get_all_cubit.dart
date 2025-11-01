import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/get_school_bus_area/bloc/get_all_state.dart';
import 'package:smart_bus/get_school_bus_area/model/area_model.dart';
import 'package:smart_bus/get_school_bus_area/model/bus_model.dart';
import 'package:smart_bus/get_school_bus_area/model/school_model.dart';
import 'package:smart_bus/get_school_bus_area/server/get_all.dart';

class GetAllCubit extends Cubit<GetAllState> {
  GetAllCubit(this.getSchoolBusAreaServer) : super(GetAllInitial());
  final GetSchoolBusAreaServer getSchoolBusAreaServer;
  List<Area> areas = [];
  List<School> schools = [];
  List<Bus> buses = [];
  Future<void> getAll() async {
    emit(GetAllLoading());
    print("here are cubit");

    try {
      final responses = await Future.wait([
        getSchoolBusAreaServer.getAreas(),
        getSchoolBusAreaServer.getSchool(),
        getSchoolBusAreaServer.getBuses(),
      ]);
      final areasResponse = responses[0];
      final schoolsResponse = responses[1];
      final busesResponse = responses[2];

      final success =
          areasResponse['success'] == true &&
          schoolsResponse['success'] == true &&
          busesResponse['success'] == true;

      print('areasResponse $areasResponse');
      print('schoolsResponse $schoolsResponse');
      print('busesResponse $busesResponse');
      if (success) {
        try {
          areas = (areasResponse['data'] as List)
              .map((json) => Area.fromJson(json))
              .toList();
          print("✅ areas parsed");
        } catch (e) {
          print("❌ Area parse error: $e");
        }

        try {
          schools = (schoolsResponse['data'] as List)
              .map((json) => School.fromJson(json))
              .toList();
          print("✅ schools parsed");
        } catch (e) {
          print("❌ School parse error: $e");
        }

        try {
          buses = (busesResponse['data'] as List)
              .map((json) => Bus.fromJson(json))
              .toList();
          print("✅ buses parsed");
        } catch (e) {
          print("❌ Bus parse error: $e");
        }

        // print("here get all area");
        // final List<Area> areas = (areasResponse['data'] as List)
        //     .map((json) => Area.fromJson(json))
        //     .toList();

        // final List<School> schools = (schoolsResponse['data'] as List)
        //     .map((json) => School.fromJson(json))
        //     .toList();

        // final List<Bus> buses = (busesResponse['data'] as List)
        //     .map((json) => Bus.fromJson(json))
        //     .toList();

        emit(GetAllSuccess(areas, buses, schools));
      } else {
        emit(GetAllError('فشل في جلب بعض البيانات'));
      }
    } catch (e) {
      emit(GetAllError('حدث خطأ أثناء جلب البيانات'));
    }
  }
}
