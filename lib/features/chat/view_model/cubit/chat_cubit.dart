import 'package:data_soft/core/firebase_helper.dart';
import 'package:data_soft/features/chat/model/message_model.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  static ChatCubit get(BuildContext context) => BlocProvider.of(context);
  TextEditingController message = TextEditingController();

  sendMessage(employeeId) async {
    if (message.text.trim().isNotEmpty) {
      final msg = message.text.trim();
      message.text = "";
      MessageModel messageData = MessageModel(
          dateTime: DateTime.now().toString(),
          isManager: managerData!.isManager,
          message: msg,
          isRead: false,
          employeeId: hubData!.userData!.employeeId!,
          messageType: "text");
      emit(MessageSendingLoadingState());
      try {
        await FirebaseHelper.employees
            .doc(employeeId)
            .collection('chat')
            .add(messageData.toJson());
        await FirebaseHelper.employees
            .doc(messageData.isManager!
                ? employeeId
                : hubData!.userData!.employeeId!)
            .update({
          "lastMessage": messageData.isManager! ? "Me:  $msg" : msg,
          "lastMessageDate": DateTime.now().toString()
        });
        emit(MessageSendingSuccessState());
      } catch (e) {
        message.text = msg;
        emit(MessageSendingErrorState());
      }
    }
  }
}
