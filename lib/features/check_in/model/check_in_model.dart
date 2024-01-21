class CheckInModel {
  Message? message;

  CheckInModel({this.message});

  CheckInModel.fromJson(Map<String, dynamic> json) {
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
  String? time;
  String? logType;
  String? checkinDate;

  Data({this.name, this.employee, this.time, this.logType, this.checkinDate});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    employee = json['employee'];
    time = json['time'];
    logType = json['log_type'];
    checkinDate = json['checkin_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['employee'] = employee;
    data['time'] = time;
    data['log_type'] = logType;
    data['checkin_date'] = checkinDate;
    return data;
  }
}

class CheckInDataModel {
  String? date;
  String? checkIn;
  String? checkOut;
  bool? isShow;

  CheckInDataModel(
      {this.date, this.checkIn, this.checkOut, this.isShow = false});
}

class LocalCheckInData {
  bool? isCheckIn;
  bool? isCheckOut;
  String? checkinDate;
  LocalCheckInData(
      {required this.isCheckIn,
      required this.isCheckOut,
      required this.checkinDate});
  LocalCheckInData.fromJson(Map<String, dynamic> json) {
    isCheckIn = json['is_check_in'];
    isCheckOut = json['is_check_out'];
    checkinDate = json['cheching_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_check_in'] = isCheckIn;
    data['is_check_out'] = isCheckOut;
    data['cheching_date'] = checkinDate;
    return data;
  }
}
