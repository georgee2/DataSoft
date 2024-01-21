class SettlementModel {
  Message? message;

  SettlementModel({this.message});

  SettlementModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  bool? success;
  List<SettlementDataModel> data = [];

  Message({this.success, required this.data});

  Message.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <SettlementDataModel>[];
      json['data'].forEach((v) {
        data.add(SettlementDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class SettlementDataModel {
  String? name;
  String? employee;
  String? employeeName;
  String? taskName;
  String? typeExpense;
  String? status;
  String? approvalStatus;
  String? comment;
  String? postingDate;
  String? attachFile;
  List<Expenses>? expenses;
  List<Advances>? advances;

  SettlementDataModel(
      {required this.name,
      required this.employee,
      required this.employeeName,
      required this.taskName,
      required this.typeExpense,
      required this.status,
      required this.approvalStatus,
      required this.comment,
      required this.postingDate,
      required this.expenses,
      required this.attachFile,
      required this.advances});

  SettlementDataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    employee = json['employee'].toString();
    employeeName = json['employee_name'].toString();
    taskName = json['task_name'];
    typeExpense = json['type_expense'].toString();
    status = json['status'].toString();
    approvalStatus = json['approval_status'].toString();
    comment = json['comment'].toString();
    postingDate = json['posting_date'].toString();
    attachFile = json['attach_files'];
    if (json['expenses'] != null) {
      expenses = <Expenses>[];
      json['expenses'].forEach((v) {
        expenses!.add(Expenses.fromJson(v));
      });
    }
    if (json['advances'] != null) {
      advances = <Advances>[];
      json['advances'].forEach((v) {
        advances!.add(Advances.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['employee'] = employee;
    data['employee_name'] = employeeName;
    data['type_expense'] = typeExpense;
    data['task_name'] = taskName;
    data['status'] = status;
    data['approval_status'] = approvalStatus;
    data['comment'] = comment;
    data['posting_date'] = postingDate;
    if (expenses != null) {
      data['expenses'] = expenses!.map((v) => v.toJson()).toList();
    }
    if (advances != null) {
      data['advances'] = advances!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Expenses {
  String? expenseDate;
  String? expenseType;
  double? amount;
  double? sanctionedAmount;

  Expenses(
      {required this.expenseDate,
      required this.expenseType,
      required this.amount,
      required this.sanctionedAmount});

  Expenses.fromJson(Map<String, dynamic> json) {
    expenseDate = json['expense_date'];
    expenseType = json['expense_type'];
    amount = json['amount'];
    sanctionedAmount = json['sanctioned_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expense_date'] = expenseDate.toString();
    data['expense_type'] = expenseType.toString();
    data['amount'] = amount ?? 0.0;
    data['sanctioned_amount'] = sanctionedAmount ?? 0.0;
    return data;
  }
}

class Advances {
  String? employeeAdvance;
  double? advancePaid;
  double? unclaimedAmount;

  Advances(
      {required this.employeeAdvance,
      required this.advancePaid,
      required this.unclaimedAmount});

  Advances.fromJson(Map<String, dynamic> json) {
    employeeAdvance = json['employee_advance'];
    advancePaid = json['advance_paid'];
    unclaimedAmount = json['unclaimed_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_advance'] = employeeAdvance.toString();
    data['advance_paid'] = advancePaid ?? 0.0;
    data['unclaimed_amount'] = unclaimedAmount ?? 0.0;
    return data;
  }
}
