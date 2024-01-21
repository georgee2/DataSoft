import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_soft/core/firebase_helper.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants.dart';
import '../model/message_model.dart';
import '../view_model/cubit/chat_cubit.dart';
import '../widgets/chat_widgets.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.employeeId});

  String employeeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomChatAppBar(
          employeeId: employeeId,
        ),
        body: Column(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseHelper.employees
                          .doc(employeeId)
                          .collection('chat')
                          .orderBy('dateTime', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return Container();
                        }
                        return ListView(
                          reverse: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            MessageModel messageData = MessageModel.fromJson(
                                document.data()! as Map<String, dynamic>);
                            return messageData.employeeId !=
                                    hubData!.userData!.employeeId!
                                ? receiverMsg(context,
                                    msg: messageData.message!,
                                    date: messageData.dateTime!)
                                : senderMsg(context,
                                    msg: messageData.message!,
                                    date: messageData.dateTime!);
                          }).toList(),
                        );
                      })),
            )),
            ChatBottomRow(employeeId: employeeId)
          ],
        ));
  }
}

class ChatBottomRow extends StatelessWidget {
  const ChatBottomRow({super.key, required this.employeeId});
  final String employeeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          var cubit = ChatCubit.get(context);
          return Container(
              height: 80,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: const Offset(0.0, -2.0),
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 10.0)
              ], color: bgColor),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: CupertinoTextField(
                    placeholder: "Write a message..",
                    controller: cubit.message,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: BoxDecoration(
                        color: bgColor,
                        border: Border.all(
                            width: 0.5,
                            color: const Color(0xff707070).withOpacity(0.31)),
                        borderRadius: BorderRadius.circular(5)),
                  )),
                  GestureDetector(
                    onTap: () {
                      cubit.sendMessage(employeeId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: imageSvg(src: "send_icon", size: 25),
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}
