import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/add_student/presentation/drop_down.dart';
import 'package:smart_bus/get_school_bus_area/bloc/get_all_cubit.dart';
import 'package:smart_bus/get_school_bus_area/bloc/get_all_state.dart';
import 'package:smart_bus/get_school_bus_area/model/area_model.dart';
import 'package:smart_bus/get_school_bus_area/model/bus_model.dart';
import 'package:smart_bus/get_school_bus_area/model/school_model.dart';
import 'package:smart_bus/get_students/presentation/students_page.dart';
import '../bloc/add_student_cubit.dart';
import '../bloc/add_student_state.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController childLocationController = TextEditingController();

  @override
  void dispose() {
    childLocationController.dispose();
    nameController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    return nameController.text.trim().isNotEmpty &&
        childLocationController.text.trim().isNotEmpty;
  }

  List<Area> areas = [];
  List<School> schools = [];
  List<Bus> buses = [];
  List<Bus> busModelBySchoolArea = [];

  int? selectedSchoolId;
  String? selectedSchool;

  int? selectedBusId;
  String? selectedBus;

  int? selectedAresId;
  String? selectedArea;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAllCubit>(context).getAll();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    print("333333333333333333333");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFD7EDF8),
      body: BlocConsumer<GetAllCubit, GetAllState>(
        listener: (context, state) {
          if (state is GetAllError) {
            Flushbar(
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.white,
              messageColor: Colors.black,
              messageSize: screenHeight * 0.02,
              message: state.message,
            ).show(context);
          }
        },
        builder: (context, state) {
          if (state is GetAllSuccess) {
            areas = state.areas;
            schools = state.schools;
            buses = state.buses;

            return BlocConsumer<AddStudentCubit, AddStudentState>(
              listener: (context, state) {
                if (state is AddStudentSuccess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StudentsPage()),
                  );
                  Flushbar(
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.white,
                    messageColor: Colors.black,
                    messageSize: screenHeight * 0.02,
                    message: 'تمت إضافة الطالب بنجاح!',
                  ).show(context);
                }
                if (state is AddStudentError) {
                  Flushbar(
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.white,
                    messageColor: Colors.black,
                    messageSize: screenHeight * 0.02,
                    message: state.message,
                  ).show(context);
                }
              },
              builder: (context, state) {
                if (state is AddStudentLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.92,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF8EF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: screenWidth * 0.12,
                              backgroundColor: const Color(0xFFD7EDF8),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF5F90B3),
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'إضافة طالب',
                              style: TextStyle(
                                color: Color(0xFF003366),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.025),
                            _buildTextField(
                              nameController,
                              'الاسم الثلاثي',
                              screenHeight,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            _buildTextField(
                              childLocationController,
                              'موقع الطفل',
                              screenHeight,
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            CustomDropDown(
                              // searchB: true,
                              list: areas.isEmpty
                                  ? []
                                  : areas.map<DropdownMenuItem<String>>((
                                      Area a,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: a.name,
                                        child: Text(a.name),
                                      );
                                    }).toList(),
                              label: selectedArea != null ? 'المنطقة' : '',
                              hintText: 'المنطقة',
                              w: screenWidth * 0.5,
                              value: selectedArea,

                              selected: selectedArea,
                              onChanged: (value) {
                                // FocusScope.of(context).unfocus();
                                setState(() {
                                  selectedArea = value;
                                  if (value != null) {
                                    selectedAresId = areas
                                        .firstWhere((sc) => sc.name == value)
                                        .areaId;
                                  }
                                });
                                print(
                                  "here select area ${selectedAresId.toString()}",
                                );
                              },
                            ),
                            CustomDropDown(
                              // searchB: true,
                              list: schools.isEmpty
                                  ? []
                                  : schools.map<DropdownMenuItem<String>>((
                                      School sc,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: sc.name,
                                        child: Text(sc.name),
                                      );
                                    }).toList(),
                              label: selectedSchool != null ? 'المدرسة' : '',
                              hintText: 'المدرسة',
                              w: screenWidth * 0.5,
                              value: selectedSchool,

                              selected: selectedSchool,
                              onChanged: (value) {
                                // FocusScope.of(context).unfocus();

                                setState(() {
                                  selectedSchool = value;
                                  if (value != null) {
                                    selectedSchoolId = schools
                                        .firstWhere((sc) => sc.name == value)
                                        .schoolId;
                                    busModelBySchoolArea = [];
                                    busModelBySchoolArea = buses
                                        .where(
                                          (bus) =>
                                              bus.schoolName == selectedSchool  || bus.area.areaId ==selectedAresId
                                            
                                      
                                        )
                                        .toList();
                                    selectedBusId = null;
                                    selectedBus = null;
                                  }
                                });
                                print(
                                  "here select school ${selectedSchoolId.toString()}",
                                );
                              },
                            ),

                            CustomDropDown(
                              // searchB: true,
                              list: busModelBySchoolArea.isEmpty
                                  ? []
                                  : busModelBySchoolArea
                                        .map<DropdownMenuItem<String>>((
                                          Bus bus,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: bus.busNumber,
                                            child: Text(bus.busNumber),
                                          );
                                        })
                                        .toList(),
                              w: screenWidth * 0.5,
                              hintText: 'الباص',
                              label: selectedBus != null ? 'الباص' : '',
                              value: selectedBus,
                              selected: selectedBus,
                              onChanged: (value) {
                                // FocusScope.of(context).unfocus();
                                setState(() {
                                  selectedBus = value;
                                  if (value != null) {
                                    selectedBusId = busModelBySchoolArea
                                        .firstWhere(
                                          (bus) => bus.busNumber == value,
                                        )
                                        .busId;
                                  }
                                });
                                print(
                                  "here select bus ${selectedBusId.toString()}",
                                );
                              },
                            ),

                            SizedBox(
                              height: screenHeight * 0.07,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  print("here bage");
                                  if (_validateFields()) {
                                    context.read<AddStudentCubit>().addStudent(
                                      name: nameController.text.trim(),
                                      address: childLocationController.text
                                          .trim(),
                                      nfcLogsId: "123432",
                                      // "unique_nfc_id_123", // استبدلها بقيمتك الفعلية
                                      schoolId: selectedSchoolId!
                                          .toString(), // استبدلها بمعرف المدرسة الصحيح
                                      busId: selectedBusId!
                                          .toString(), // أو رقم الباص إذا متوفر
                                      areaId: selectedAresId!.toString(),
                                      // imageFile: _imageFile!,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'يرجى تعبئة جميع الحقول ',
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5F90B3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'حفظ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    double screenHeight,
  ) {
    return Container(
      height: screenHeight * 0.085,
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8EF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 1.5),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
