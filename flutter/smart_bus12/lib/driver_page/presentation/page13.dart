import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_bus/driver_page/bloc/driver_cubit.dart';
import 'package:smart_bus/driver_page/bloc/driver_state.dart';
import 'package:smart_bus/driver_page/model/driver_model.dart';

// class Student {
//   final String name;
//   final String imageUrl;
//   Student({required this.name, required this.imageUrl});
// }

class DriverScreen extends StatefulWidget {
  final String name;
  final String role;
  DriverScreen({required this.name, required this.role, super.key});

  // DriverScreen({Key? key}) : super(key: key);

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {

  late DriverBusModel driverBusModel ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<DriverCubit>(context).getDriverData();

  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
        body: BlocConsumer<DriverCubit, DriverState>(
          listener: (context, state){
            if (state is DriverError) {
              Flushbar(
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.white,
                messageColor: Colors.black,
                messageSize: screenHeight * 0.02,
                message: state.message,
              ).show(context);
            }
          },
          builder: (context, state){
            if (state is DriverSuccess){
              driverBusModel = state.driverBusModel;
              return  SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    double screenHeight = constraints.maxHeight;
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: const Color(0xFF394B5F),
                                  size: screenWidth * 0.07,
                                ),
                              ),
                              Spacer(),
                              Text(
                                ' السائق ${driverBusModel.busNumber}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF394B5F),
                                ),
                              ),
                              Spacer(flex: 1),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                            height: screenHeight * 0.17,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAE390),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: screenHeight * 0.015,
                                  left: 16,
                                  right: 16,
                                  child: Container(
                                    height: screenHeight * 0.06,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8D674),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${driverBusModel.studentsCount}  طلاب في الحافلة',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF394B5F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: screenHeight * 0.10,
                                  left: 0,
                                  right: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.gps_fixed,
                                          color: const Color(0xFF394B5F),
                                          size: screenWidth * 0.07,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'GPS',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.055,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF394B5F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Expanded(
                            child: driverBusModel.students.isEmpty
                                ? Center(
                              child: Text(
                                'لا يوجد طلاب حالياً.',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                                : ListView.builder(
                              itemCount: driverBusModel.students.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F2F2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          driverBusModel.students[index].fullName,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.05),
                                        Text(
                                          driverBusModel.students[index].address,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDEEAF6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.notifications, color: Color(0xFF394B5F)),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'لا توجد إشعارات جديدة حالياً.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF394B5F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),







    );
  }
}
