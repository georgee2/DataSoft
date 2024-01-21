class AvailableBudgetModel {
  Message? message;

  AvailableBudgetModel({this.message});

  AvailableBudgetModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  bool? success;
  List<Data> data = [];

  Message({this.success, required this.data});

  Message.fromJson(json) {
    success = json['success'];
    if (json['data'] != null || json['data'].isNotEmpty) {
      data = <Data>[];
      data.add(Data.fromJson(json['data'][0]));
    }
  }
}

class Data {
  String? employee;
  String? fromDate;
  String? toDate;
  String? value;
  String? expenditure;

  Data(
      {this.employee,
      this.fromDate,
      this.toDate,
      this.value,
      this.expenditure});

  Data.fromJson(Map<String, dynamic> json) {
    employee = json['employee'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    value = json['value'];
    expenditure = json['expenditure'];
  }
}
