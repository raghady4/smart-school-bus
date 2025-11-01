import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/admin_page/bloc/admin_page_cubit.dart';
import 'package:smart_bus/admin_page/bloc/admin_page_state.dart';
import 'package:smart_bus/admin_page/model/admin_page_model.dart';

class AdminScreen extends StatefulWidget {
  final String name;
  final String role;
  AdminScreen({required this.name, required this.role, super.key});

  // const AdminScreen({super.key});


  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late AdminSchoolModel adminSchoolModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AdminSchoolCubit>(context).getAdminSchoolData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFD7EDF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD7EDF8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الإدارة',
          style: TextStyle(
            color: Color(0xFF394B5F),
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: BlocConsumer<AdminSchoolCubit, AdminSchoolState>(
        listener: (context, state) {
          if (state is AdminSchoolError) {
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
          if (state is AdminSchoolSuccess) {
            adminSchoolModel = state.adminSchoolModel;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // الصندوقين عدد الحافلات وعدد الطلاب
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // الصندوق اليسار - عدد الحافلات
                        Container(
                          width: screenWidth * 0.35,
                          height: screenHeight * 0.22,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7EDF8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.15,
                                height: screenWidth * 0.15,
                                child: Image.asset('assets/images/boy.webp'),
                              ),
                              const SizedBox(height: 10),
                               Text(
                                adminSchoolModel.busesCount.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF394B5F),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'عدد الحافلات',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF394B5F),
                                ),
                              ),
                            ],
                          ),
                        ), // الصندوق اليمين - عدد الطلاب
                        Container(
                          width: screenWidth * 0.35,
                          height: screenHeight * 0.22,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD7EDF8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.15,
                                height: screenWidth * 0.15,
                                child: Image.asset('assets/images/boy.webp'),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '24',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF394B5F),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'عدد الطلاب',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF394B5F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // الصندوق الجديد للسائقين
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    height: screenHeight * 0.50, // نسبة من ارتفاع الشاشة
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'السائقون',
                        style: TextStyle(
                          color: Color(0xFF394B5F),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
