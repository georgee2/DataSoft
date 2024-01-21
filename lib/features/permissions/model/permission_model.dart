class PermissionsModel {
  Message? message;

  PermissionsModel({this.message});

  PermissionsModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  List<UPermissions> permissions = [];

  Message({required this.permissions});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['u_permissions'] != null) {
      permissions = <UPermissions>[];
      json['u_permissions'].forEach((v) {
        permissions.add(UPermissions.fromJson(v));
      });
    }
  }
}

class UPermissions {
  String? name;
  String? employee;
  String? status;
  String? employeeName;
  String? permissionType;
  String? fromTime;
  String? toTime;
  String? reason;
  String? approver;
  String? attachFile;
  String? date;

  UPermissions(
      {required this.employee,
      required this.permissionType,
      required this.fromTime,
      required this.toTime,
      required this.date,
      required this.reason,
      required this.attachFile,
      this.name,
      required this.status,
      this.employeeName,
      this.approver});

  UPermissions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    employee = json['employee'];
    status = json['status'];
    employeeName = json['employee_name'];
    permissionType = json['permission_type'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    reason = json['reason'];
    approver = json['approver'];
    attachFile = json['attach_files'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['employee'] = employee;
    data['status'] = status;
    data['employee_name'] = employeeName;
    data['permission_type'] = permissionType;
    data['from_time'] = fromTime;
    data['to_time'] = toTime;
    data['reason'] = reason;
    data['approver'] = approver;
    data['date'] = date;
    data['attach_files'] = attachFile;
    return data;
  }
}
