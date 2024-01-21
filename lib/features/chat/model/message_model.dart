import 'package:data_soft/core/app_datetime.dart';

class MessageModel {
  String? dateTime;
  String? message;
  String? employeeId;
  String? messageType;
  bool? isManager;
  bool? isRead;
  MessageModel({
    required this.dateTime,
    required this.isManager,
    required this.message,
    required this.isRead,
    required this.messageType,
    required this.employeeId,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    dateTime = DateTimeFormating.formatCustomDate(
        date: json["dateTime"], formatType: "h:mm a");
    message = json['message'].toString();
    isManager = json['isManager'];
    isRead = json['isRead'];
    employeeId = json['employeeId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dateTime'] = dateTime;
    data['message'] = message;
    data['dateTime'] = dateTime.toString();
    data['isManager'] = isManager;
    data['isRead'] = isRead;
    data['employeeId'] = employeeId;
    return data;
  }
}

class FirebaseUserData {
  String? lastSeen;
  String? userImage;
  String? userName;
  String? employeeId;
  bool? userStatus;
  String? lastMessage;
  String? lastMessageDate;
  bool? isManager;

  FirebaseUserData({
    required this.lastMessage,
    required this.isManager,
    required this.userImage,
    required this.lastMessageDate,
    required this.lastSeen,
    required this.userStatus,
    required this.userName,
    required this.employeeId,
  });

  FirebaseUserData.fromJson(Map<String, dynamic> json) {
    lastMessage = json['lastMessage'];
    isManager = json['isManager'];
    userImage = json['userImage'] != null
        ? "http://154.38.165.213:1212${json['userImage']}"
        : null;
    lastMessageDate = json['lastMessageDate'];
    lastSeen = json['lastSeen'];
    userStatus = json['userStatus'];
    userName = json['userName'];
    employeeId = json['employeeId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userImage'] = userImage;
    data['lastMessage'] = lastMessage;
    data['isManager'] = isManager;
    data['lastMessageDate'] = lastMessageDate;
    data['lastSeen'] = lastSeen;
    data['userStatus'] = userStatus;
    data['userName'] = userName;
    data['employeeId'] = employeeId;
    return data;
  }
}
