import 'package:data_soft/features/settlement/model/settlement_model.dart';

class SettlementTypeModel {
  List<SettlementType> message = [];

  SettlementTypeModel({required this.message});

  SettlementTypeModel.fromJson(Map<String, dynamic> json,
      {SettlementModel? settlementModel}) {
    if (json['message'] != null) {
      message = <SettlementType>[];
      json['message'].forEach((v) {
        final item = SettlementType.fromJson(v);
        if (item.status.toString() == "Submitted" ||
            item.status.toString() == "Paid" && item.unClaimedAmount > 0.0) {
          message.add(item);
        }
      });
    }
  }
}

class SettlementType {
  String? name;
  String? employee;
  String? employeeName;
  String? typeExpense;
  String? expenseType;
  String? status;
  double? advanceAmount;
  String? postingDate;
  String? lead;
  String? purpose;
  String? attachFiles;
  String? taskName;
  double unClaimedAmount = 0.0;

  SettlementType(
      {this.name,
      this.employee,
      this.taskName,
      this.employeeName,
      this.typeExpense,
      this.expenseType,
      this.status,
      this.advanceAmount,
      this.postingDate,
      this.lead,
      this.purpose,
      this.attachFiles});

  SettlementType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    employee = json['employee'];
    employeeName = json['employee_name'];
    typeExpense = json['type_expense'];
    expenseType = json['expense_type'];
    status = json['status'];
    taskName = json['task_name'];
    advanceAmount = json['advance_amount'];
    postingDate = json['posting_date'];
    lead = json['lead'];
    purpose = json['purpose'];
    attachFiles = json['attach_files'];
    unClaimedAmount = json['paid_amount'] - (json['claimed_amount'] ?? 0.0);
  }
}
