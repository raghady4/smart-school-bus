import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/add_student/bloc/add_student_cubit.dart';
import 'package:smart_bus/add_student/bloc/add_student_state.dart';
import 'package:smart_bus/add_student/presentation/auth_add_student.dart';
import 'package:smart_bus/add_student/presentation/page11.dart';
// import 'package:smart_bus/add_student/presentation/auth_add_student.dart';
// import 'package:smart_bus/add_student/presentation/page11.dart';
import 'package:smart_bus/get_students/get_student_bloc/get_student_state.dart';
import 'package:smart_bus/get_students/get_student_bloc/get_studetns_cubit.dart';
import 'package:smart_bus/get_students/model/students_model.dart';
import 'package:another_flushbar/flushbar.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  List<StudentModel> students = [];

  void _navigateAndAddStudent() async {
    print("99999999999999999999");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AuthAddStudent()),
    );

    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => AuthAddStudent()),
    // );

    // // بعد الرجوع من صفحة إضافة الطالبق
    // if (result != null) {
    //   BlocProvider.of<GetStudentCubit>(context).getMyStudent();
    // }

    // if (result != null && result is Map<String, dynamic>) {
    //   setState(() {
    //     students.add(result);
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetStudentCubit>(context).getMyStudent();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFD7EDF8),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
              child: Text(
                'الطلاب',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF003366),
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocConsumer<GetStudentCubit, GetStudentState>(
              builder: (context, state) {
                if (state is GetStudentSuccess) {
                  students = state.students;
                  return Expanded(
                    child: students.isEmpty
                        ? const Center(
                            child: Text(
                              'لا يوجد طلاب مضافين بعد.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.8,
                                ),
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];
                              return BlocConsumer<
                                AddStudentCubit,
                                AddStudentState
                              >(
                                listener: (context, state) {
                                  if (state is DeleteStudentSuccess) {
                                    // حذف الطالب من القائمة بناءً على الـ ID
                                    setState(() {
                                      students.removeWhere(
                                        (s) =>
                                            s.studentId.toString() ==
                                            state.studentId,
                                      );
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم حذف الطالب بنجاح'),
                                      ),
                                    );
                                  } else if (state is DeleteStudentError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('حذف الطالب'),
                                          content: Text(
                                            'هل تريد حذف الطالب "${student.fullName}"؟',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('إلغاء'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<AddStudentCubit>()
                                                    .deleteStudent(
                                                      studentId: student
                                                          .studentId
                                                          .toString(),
                                                    );
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'حذف',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            student.fullName,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF003366),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            student.address,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF003366),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            student.bus.number,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF003366),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            student.nfcLogsId,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF003366),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
              listener: (context, state) {
                if (state is GetStudentError) {
                  Flushbar(
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.white,
                    messageColor: Colors.black,
                    messageSize: screenHeight * 0.02,
                    message: state.message,
                  ).show(context);
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton.icon(
                  onPressed: _navigateAndAddStudent,
                  icon: const Icon(Icons.add, size: 24, color: Colors.black),
                  label: const Text(
                    'إضافة طالب',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBEDEEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
