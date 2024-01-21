class AttendanceModel {
  Message? message;

  AttendanceModel({this.message});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  bool? success;
  List<Data> data = [];

  Message({this.success, required this.data});

  Message.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  String? name;
  String? employee;
  String? employeeName;
  String? workingHours;
  String? status;
  String? attendanceDate;
  String? leaveType;
  String? shift;
  String? startTime;
  String? endTime;

  Data(
      {this.name,
      this.employee,
      this.employeeName,
      this.workingHours,
      this.status,
      this.attendanceDate,
      this.leaveType,
      this.shift,
      this.startTime,
      this.endTime});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    employee = json['employee'];
    employeeName = json['employee_name'];
    workingHours = json['working_hours'].toString();
    status = json['status'];
    attendanceDate = json['attendance_date'];
    leaveType = json['leave_type'];
    shift = json['shift'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }
}
