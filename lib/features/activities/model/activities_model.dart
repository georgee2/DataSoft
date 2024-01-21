import '../../registration/model/registration_model.dart';

class ActivitiesModel {
  List<ActivitiesData> message = [];

  ActivitiesModel({required this.message});

  ActivitiesModel.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <ActivitiesData>[];
      json['message'].forEach((v) {
        message.add(ActivitiesData.fromJson(v));
      });
    }
  }
}

class ActivitiesData {
  String? employee;
  String? expenseType;
  String? typeExpense;
  String? employeeName;
  String? status;
  double? advanceAmount;
  double? exchangeRate;
  String? advanceAccount;
  String? postingDate;
  String? lead;
  String? purpose;
  String? attachFiles;
  String? activityName;

  ActivitiesData({
    this.employee,
    this.expenseType,
    this.typeExpense,
    this.employeeName,
    this.activityName,
    this.status,
    this.advanceAmount,
    this.postingDate,
    this.lead,
    this.purpose,
    this.attachFiles,
    this.advanceAccount,
    this.exchangeRate,
  });

  ActivitiesData.fromJson(Map<String, dynamic> json) {
    employee = json['employee'] ?? "";
    expenseType = json['type_expense'] ?? "";
    typeExpense = json['expense_type'] ?? "Marketing Activity";
    employeeName = json['employee_name'] ?? "";
    status = json['status'] ?? "";
    advanceAmount = json['advance_amount'];
    postingDate = json['posting_date'] ?? "";
    lead = json['lead'] ?? "";
    purpose = json['purpose'] ?? "";
    attachFiles = json['attach_files'];
    activityName = json['task_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['posting_date'] = postingDate;
    data['expense_type'] = expenseType;
    data['advance_amount'] = advanceAmount;
    data['lead'] = lead;
    data['purpose'] = purpose;
    data['employee'] = employee;
    data['exchange_rate'] = exchangeRate;
    data['type_expense'] = typeExpense;
    data['attach_files'] = attachFiles;
    data['task_name'] = activityName;
    data['company'] = hubData!.company;
    data['mode_of_payment'] = "Cash-EGP";
    return data;
  }
}
