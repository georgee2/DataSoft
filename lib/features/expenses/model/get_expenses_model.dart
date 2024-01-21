import 'package:data_soft/features/registration/model/registration_model.dart';

class ExpensesModel {
  List<ExpensesData> message = [];

  ExpensesModel({required this.message});

  ExpensesModel.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <ExpensesData>[];
      json['message'].forEach((v) {
        message.add(ExpensesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message.isNotEmpty) {
      data['message'] = message.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpensesData {
  String? employee;
  String? expenseType;
  String? typeExpense;
  String? employeeName;
  String? status;
  double? advanceAmount;
  String? postingDate;
  String? activityName;
  String? lead;
  String? purpose;
  String? company;
  double? exchangeRate;
  String? attachFiles;
  String? advanceAccount;

  ExpensesData({
    this.status,
    this.postingDate,
    this.employeeName,
    this.activityName,
    required this.expenseType,
    required this.advanceAmount,
    required this.lead,
    required this.purpose,
    required this.employee,
    required this.exchangeRate,
    required this.typeExpense,
    required this.attachFiles,
  });

  ExpensesData.fromJson(Map<String, dynamic> json) {
    employee = json['employee'];
    expenseType = json['type_expense'];
    typeExpense = json['expense_type'];
    employeeName = json['employee_name'];
    status = json['status'];
    advanceAmount = json['advance_amount'];
    postingDate = json['posting_date'];
    lead = json['lead'];
    purpose = json['purpose'];
    attachFiles = json['attach_files'];
    exchangeRate = json['exchange_rate'];
    advanceAccount = json['advance_account'];
    activityName = json['task_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['posting_date'] = postingDate;
    data['type_expense'] = expenseType;
    data['advance_amount'] = advanceAmount;
    data['lead'] = lead;
    data['purpose'] = purpose;
    data['task_name'] = activityName;
    data['employee'] = employee;
    data['exchange_rate'] = exchangeRate;
    data['company'] = hubData!.company;
    data['expense_type'] = typeExpense;
    data['attach_files'] = attachFiles;
    data['mode_of_payment'] = "Cash-EGP";
    return data;
  }
}
