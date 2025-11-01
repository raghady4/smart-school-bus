import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_cubit.dart';
import '../bloc/notification_state.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF0C3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: Text(
                      'الإشعارات',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9B6221),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.5,
                          height: screenWidth * 0.5,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDDECD9),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Positioned(
                          top: -screenHeight * 0.025,
                          left: -screenWidth * 0.1,
                          child: Opacity(
                            opacity: 0.8,
                            child: Image.asset(
                              'assets/images/cloud.png',
                              width: screenWidth * 0.3,
                            ),
                          ),
                        ),
                        Positioned(
                          top: screenHeight * 0.05,
                          right: -screenWidth * 0.09,
                          child: Opacity(
                            opacity: 0.8,
                            child: Image.asset(
                              'assets/images/cloud.png',
                              width: screenWidth * 0.25,
                            ),
                          ),
                        ),
                        Positioned(
                          top: screenHeight * 0.04,
                          child: Image.asset(
                            'assets/images/masage.webp',
                            width: screenWidth * 0.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.08),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.07),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: BlocBuilder<NotificationCubit, NotificationState>(
                        buildWhen: (previous, current) => previous != current,
                        builder: (context, state) {
                          if (state is NotificationLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is NotificationLoaded) {
                            if (state.notifications.isEmpty) {
                              return Center(
                                child: Text('لا توجد إشعارات حالياً'),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: state.notifications.map<Widget>((
                                notif,
                              ) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: ListTile(
                                    title: Text(notif['title'] ?? ''),
                                    subtitle: Text(notif['body'] ?? ''),
                                    trailing: Text(
                                      (notif['created_at'] ?? '')
                                          .toString()
                                          .split('T')
                                          .first,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else if (state is NotificationError) {
                            return Center(child: Text('خطأ: ${state.message}'));
                          }
                          return Center(
                            child: Text('اضغط على زر التحديث لجلب الإشعارات'),
                          );
                        },
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () =>
                context.read<NotificationCubit>().fetchNotifications(),
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () =>
                context.read<NotificationCubit>().registerFcmToken(),
            child: Icon(Icons.notifications_active),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationRow(double width, double height, String text) {
    return Row(
      children: [
        Icon(Icons.access_time, color: Colors.green, size: width * 0.06),
        SizedBox(width: width * 0.03),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: width * 0.04, color: Color(0xFF1B2E42)),
          ),
        ),
      ],
    );
  }
}
