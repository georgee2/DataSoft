import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/core/firebase_helper.dart';
import 'package:data_soft/features/chat/view/view_chat.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../registration/model/registration_model.dart';
import '../model/message_model.dart';

class ManagerChat extends StatelessWidget {
  ManagerChat({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(screenName: "Requests"),
      body: Column(
        children: [
          CustAppBar(
              title: "Chat", scaffoldKey: scaffoldKey, imageSrc: "chat_icon"),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseHelper.employees
                .where('employeeId',
                    isNotEqualTo: hubData!.userData!.employeeId)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  FirebaseUserData userDataModel =
                      FirebaseUserData.fromJson(data);

                  return items(context, userDataModel: userDataModel);
                }).toList(),
              );
            },
          ))
        ],
      ),
    );
  }

  Widget items(context,
      {required FirebaseUserData userDataModel,
      lastMsg,
      image,
      dateTime,
      employeeId}) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      employeeId: userDataModel.employeeId!,
                    ),
                  ));
            },
            leading: SizedBox(
              height: 50,
              width: 50,
              child: custProviderNetWorkImage(
                  image: userDataModel.userImage, radius: 27),
            ),
            title: Text(
              userDataModel.userName.toString(),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamilyStrings.ROBOTO_BOLD),
            ),
            subtitle: Text(
              userDataModel.lastMessage.toString(),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamilyStrings.ROBOTO_MEDIUM,
                  color: Colors.grey.withOpacity(0.7)),
            ),
            trailing: Text(DateTimeFormating.formatCustomDate(
                date: userDataModel.lastMessageDate, formatType: "h:mm a")),
          ),
        ),
      ],
    );
  }
}
