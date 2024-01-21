import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';
import '../../../core/firebase_helper.dart';
import '../../registration/model/registration_model.dart';
import '../model/notification_model.dart';
import '../view_model/notification_helper.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapShot;
    if (managerData?.isManager == true) {
      snapShot = FirebaseHelper.notificationPath
          .where('isManager', isEqualTo: false)
          .orderBy('dateTime', descending: true)
          .snapshots();
    } else {
      snapShot = FirebaseHelper.notificationPath
          .where('to', isEqualTo: "/topics/${hubData!.userData!.employeeId}")
          .where('isManager', isEqualTo: true)
          .orderBy('dateTime', descending: true)
          .snapshots();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: FontFamilyStrings.ROBOTO_BOLD),
        ),
        leading: GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                navigateAndKill(
                    context: context, navigateAndKill: NavigateAndKill.Home);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: imageSvg(src: "back_icon", size: 20),
            )),
        leadingWidth: 55,
        toolbarHeight: 60,
        backgroundColor: bgColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: snapShot,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          int notificationsCount = 0;
          // ignore: avoid_function_literals_in_foreach_calls
          snapshot.data!.docs.forEach((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            if (data['isRead'] == false) {
              notificationsCount++;
            }
          });
          return snapshot.data!.docs.isEmpty
              ? noDataFound(context, type: "Notification")
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (notificationsCount != 0)
                          Wrap(
                            children: [
                              const Text("You have "),
                              Text(
                                "$notificationsCount Notifications ",
                                style: const TextStyle(color: secondryColor),
                              ),
                              const Text("unread"),
                            ],
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        ...snapshot.data!.docs.map((e) {
                          Map<String, dynamic> data =
                              e.data()! as Map<String, dynamic>;
                          NotificationModel notificationModel =
                              NotificationModel.fromJson(data);
                          return GestureDetector(
                            onTap: () {
                              if (notificationModel.isRead == false) {
                                updateNotification(
                                    notificationModel.notificationId);
                              }
                              notificationAction(
                                  context, notificationModel.data?.type,
                                  fromScreen: true);
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 75,
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      if (notificationsCount != 0)
                                        CircleAvatar(
                                          radius: 5,
                                          backgroundColor:
                                              notificationModel.isRead == true
                                                  ? Colors.transparent
                                                  : Colors.red,
                                        ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      custProviderNetWorkImage(
                                          image: notificationModel.image),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notificationModel
                                                  .notification!.title
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: FontFamilyStrings
                                                      .ROBOTO_BOLD),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(notificationModel
                                                .notification!.body
                                                .toString()),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        DateTimeFormating.formatCustomDate(
                                            date: notificationModel.dateTime,
                                            formatType: "h:mm a\ndd MMM yyyy"),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                                const Divider()
                              ],
                            ),
                          );
                        }).toList()
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
