import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import '../../../core/app_datetime.dart';
import '../../../core/firebase_helper.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../model/message_model.dart';

// ignore: must_be_immutable
class CustomChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String employeeId;
  FirebaseUserData? firebaseUserData;

  CustomChatAppBar({
    super.key,
    required this.employeeId,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff42C6F3),
            approvedColor,
          ],
        ),
      ),
      child: SafeArea(
        top: true,
        left: false,
        right: false,
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: imageSvg(src: "arrow_left_circle"),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseHelper.employees
                  .doc(managerData?.isManager == true
                      ? employeeId
                      : hubData!.userData?.managerId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                Map<String, dynamic>? data =
                    snapshot.data?.data() as Map<String, dynamic>?;
                firebaseUserData = FirebaseUserData.fromJson(data ?? {});
                return Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                          child: custProviderNetWorkImage(
                              image: firebaseUserData?.userImage, radius: 27),
                        ),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.circle,
                              color: firebaseUserData?.userStatus == true
                                  ? approvedColor
                                  : rejectedColor,
                              size: 15),
                        )
                      ],
                    ),
                    const SizedBox(width: 7),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(firebaseUserData?.userName ?? "",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(
                              firebaseUserData?.userStatus == true
                                  ? "Online"
                                  : firebaseUserData?.lastMessageDate != null
                                      ? "last seen ${DateTimeFormating.formatCustomDate(date: firebaseUserData?.lastMessageDate, formatType: "dd MMM h:mm a")}"
                                      : "",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade700)),
                        ])
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 80);
}

Widget receiverMsg(context, {required String msg, required String date}) {
  return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChatBubble(
          clipper: ChatBubbleClipper2(
              type: BubbleType.receiverBubble, nipHeight: 15, nipRadius: 0),
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(top: 20),
          backGroundColor: const Color(0xffEAECF2),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
            ),
            child: Text(
              msg,
              style: const TextStyle(color: Color(0xff63697B)),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(date,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w200))
      ],
    ),
  ]);
}

Widget senderMsg(context, {required String msg, required String date}) {
  return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ChatBubble(
              clipper: ChatBubbleClipper2(
                  type: BubbleType.sendBubble, nipHeight: 15, nipRadius: 0),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 20),
              backGroundColor: Colors.blue,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                ),
                child: Text(
                  msg,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(date,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w200)),
          ],
        ),
      ]);
}
