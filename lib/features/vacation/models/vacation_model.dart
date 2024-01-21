class VacationModel {
  List<Message> message = [];
  double? totalVacationDays;

  VacationModel({required this.message});

  VacationModel.fromJson(Map<String, dynamic> json, double? totalVacations) {
    if (json['message'] != null) {
      message = <Message>[];
      if (totalVacations != null) {
        totalVacationDays = totalVacations;
      }
      json['message'].forEach((value) {
        message.add(Message.fromJson(value));
        if (totalVacations != null && value['total_leave_days'] != 0.0) {
          totalVacationDays = totalVacationDays! - value['total_leave_days'];
        }
      });
    }
  }
}

class Message {
  late String employee;
  late String employeeName;
  late String leaveType;
  late String fromDate;
  late String toDate;
  late String totalLeaveDays;
  late String status;
  late String description;
  String? leaveApprover;
  double? leaveBalance;
  String? postingDate;
  String? attachFile;

  Message(
      {required this.employee,
      required this.employeeName,
      required this.leaveType,
      required this.fromDate,
      required this.toDate,
      required this.totalLeaveDays,
      required this.status,
      required this.attachFile,
      required this.description,
      this.leaveApprover,
      this.postingDate});

  Message.fromJson(Map<String, dynamic> json) {
    employee = json['employee'] ?? "";
    employeeName = json['employee_name'] ?? "";
    leaveType = json['leave_type'] ?? "";
    fromDate = json['from_date'] ?? "";
    toDate = json['to_date'] ?? "";
    totalLeaveDays = json['total_leave_days'].toInt().toString();
    status = json['status'] ?? "";
    description = json['description'] ?? "";
    leaveApprover = json['leave_approver'] ?? "";
    attachFile = json['attach_files'];
    leaveBalance = json['leave_balance'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee'] = employee;
    data['employee_name'] = employeeName;
    data['leave_type'] = leaveType;
    data['from_date'] = fromDate;
    data['to_date'] = toDate;
    data['total_leave_days'] = double.parse(totalLeaveDays);
    data['status'] = status;
    data['description'] = description;
    data['posting_date'] = postingDate;
    data['attach_files'] = attachFile;
    data['leave_approver'] = leaveApprover;
    return data;
  }
}
