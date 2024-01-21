class SalariesModel {
  Message? message;

  SalariesModel({this.message});

  SalariesModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  bool? success;
  List<SalaryData> data = [];

  Message({this.success, required this.data});

  Message.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <SalaryData>[];
      json['data'].forEach((v) {
        data.add(SalaryData.fromJson(v));
      });
    }
  }
}

class SalaryData {
  String? name;
  String? employee;
  String? employeeName;
  String? status;
  String? postingDate;
  String? startDate;
  String? endDate;
  double? totalWorkingDays;
  double? leaveWithoutPay;
  double? absentDays;
  double? paymentDays;
  double? grossPay;
  double? totalDeduction;
  List<Earnings> earnings = [];
  List<Deductions> deductions = [];
  double? netPay;

  SalaryData(
      {this.name,
      this.employee,
      this.employeeName,
      this.status,
      this.postingDate,
      this.startDate,
      this.endDate,
      this.totalWorkingDays,
      this.leaveWithoutPay,
      this.absentDays,
      this.paymentDays,
      this.grossPay,
      this.totalDeduction,
      required this.earnings,
      required this.deductions,
      this.netPay});

  SalaryData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    employee = json['employee'];
    employeeName = json['employee_name'];
    status = json['status'];
    postingDate = json['posting_date'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalWorkingDays = json['total_working_days'];
    leaveWithoutPay = json['leave_without_pay'];
    absentDays = json['absent_days'];
    paymentDays = json['payment_days'];
    grossPay = json['gross_pay'];
    totalDeduction = json['total_deduction'];
    if (json['earnings'] != null) {
      earnings = <Earnings>[];
      json['earnings'].forEach((v) {
        earnings.add(Earnings.fromJson(v));
      });
    }
    if (json['deductions'] != null) {
      deductions = <Deductions>[];
      json['deductions'].forEach((v) {
        deductions.add(Deductions.fromJson(v));
      });
    }
    netPay = json['net_pay'];
  }
}

class Earnings {
  String? salaryComponent;
  double? amount;

  Earnings({this.salaryComponent, this.amount});

  Earnings.fromJson(Map<String, dynamic> json) {
    salaryComponent = json['salary_component'];
    amount = json['amount'];
  }
}

class Deductions {
  String? salaryComponent;
  double? amount;

  Deductions.fromJson(Map<String, dynamic> json) {
    salaryComponent = json['salary_component'];
    amount = json['amount'];
  }
}
