import 'package:data_soft/features/registration/model/registration_model.dart';

class NotificationModel {
  String? to;
  NotificationHeader? notification;
  Data? data;
  String? dateTime;
  String? senderId;
  String? name;
  String? notificationId;
  String? image;
  bool? isManager;
  bool? isRead;
  String? type;

  NotificationModel({this.to, required this.notification, required this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    to = "/topics/${json['to']}";
    type = json['type'];
    notification = json['notification'] != null
        ? NotificationHeader.fromJson(json['notification'])
        : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    senderId = json['senderId'];
    dateTime = json['dateTime'];
    isManager = json['isManager'];
    name = json['userName'];
    isRead = json['isRead'];
    notificationId = json['NotificationId'];
    image = json['image'];
  }

  Map<String, dynamic> toJson(bool? isToFirebase) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (isToFirebase == true) {
      data['type'] = type;
      data['dateTime'] = DateTime.now().toString();
      data['isManager'] = managerData!.isManager;
      data['senderId'] = hubData!.userData!.employeeId;
      data['userName'] = managerData!.isManager == true
          ? managerData!.managerName
          : userData!.fullName;
      data['NotificationId'] = null;
      data['isRead'] = false;
      data['image'] = userData?.bannerImage == null
          ? null
          : 'http://154.38.165.213:1212${userData?.bannerImage}';
    }
    data['to'] =
        "/topics/${managerData!.isManager! ? to : hubData!.userData?.managerId}";
    if (notification != null) {
      data['notification'] = notification!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class NotificationHeader {
  String? title;
  String? body;
  String? sound;

  NotificationHeader({
    this.title,
    required this.body,
  });

  NotificationHeader.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    sound = "default";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = userData!.fullName;
    data['body'] = body;
    data['sound'] = "default";
    return data;
  }
}

class Data {
  String? type;
  String? screenCode;
  String? employeeId;
  String? clickAction;

  Data({required this.type, required this.screenCode});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    screenCode = json['screenCode'];
    employeeId = json['employeeId'];
    clickAction = "FLUTTER_NOTIFICATION_CLICK";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['screenCode'] = screenCode;
    data['employeeId'] = managerData!.isManager!
        ? hubData!.userData!.employeeId
        : hubData!.userData?.managerId;
    data['click_action'] = "FLUTTER_NOTIFICATION_CLICK";
    return data;
  }
}
