import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_soft/core/firebase_helper.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:flutter/material.dart';

import '../../../core/app_fonts.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../view/notification_screen.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, this.isNotificationScreen = false});
  final bool isNotificationScreen;

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
    return StreamBuilder<QuerySnapshot>(
      stream: snapShot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return imageSvg(src: "notification", color: Colors.white, size: 25);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return imageSvg(src: "notification", color: Colors.white, size: 25);
        }
        int notificationsCount = 0;
        // ignore: avoid_function_literals_in_foreach_calls
        snapshot.data!.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          if (data['isRead'] == false) {
            notificationsCount++;
          }
        });
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ));
          },
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Container(
                margin: notificationsCount == 0
                    ? EdgeInsets.zero
                    : const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 5),
                child: imageSvg(
                    src: "notification", color: Colors.white, size: 25),
              ),
              if (notificationsCount != 0)
                CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      notificationsCount.toString(),
                      style: const TextStyle(
                          fontFamily: FontFamilyStrings.ROBOTO_LIGHT,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ))
            ],
          ),
        );
      },
    );
  }
}
