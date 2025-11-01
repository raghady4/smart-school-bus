import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/admin_page/bloc/admin_page_state.dart';
import 'package:smart_bus/admin_page/model/admin_page_model.dart';
import 'package:smart_bus/admin_page/server/admin_page_server.dart';


class AdminSchoolCubit extends Cubit<AdminSchoolState> {
  AdminSchoolCubit(this.adminSchoolServer) : super(AdminSchoolInitial());

  late AdminSchoolModel adminSchoolModel;
  final AdminSchoolServer adminSchoolServer ;

  Future<void> getAdminSchoolData() async {
    emit(AdminSchoolLoading());
    print("here are Driver");

    final success = await adminSchoolServer.getAdminSchoolData();

    if (success['success'] == true) {
      adminSchoolModel = AdminSchoolModel.fromJson(success['data']);
      emit(AdminSchoolSuccess(adminSchoolModel: adminSchoolModel));
    } else {
      emit(AdminSchoolError('حدث خطأ أثناء جلب البيانات'));
    }
  }
}