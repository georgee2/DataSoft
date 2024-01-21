import '../../../core/app_datetime.dart';

class StatusPercentagesModel {
  Message? message;

  StatusPercentagesModel({this.message});

  StatusPercentagesModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  Date? date;

  Message({this.date});

  Message.fromJson(Map<String, dynamic> json) {
    final thisMonth = DateTimeFormating.formatCustomDate(
        date: DateTime.now(), formatType: "yyyy-MM");
    date = json[thisMonth] != null ? Date.fromJson(json[thisMonth]) : null;
  }
}

class Date {
  double? completedPercentage;
  double? inProgressPercentage;
  double? incompletePercentage;

  Date(
      {this.completedPercentage,
      this.inProgressPercentage,
      this.incompletePercentage});

  Date.fromJson(Map<String, dynamic> json) {
    completedPercentage =
        double.parse(json['completed_percentage'].toStringAsFixed(1));
    inProgressPercentage =
        double.parse(json['in_progress_percentage'].toStringAsFixed(1));
    incompletePercentage =
        double.parse(json['incomplete_percentage'].toStringAsFixed(1));
  }
}
