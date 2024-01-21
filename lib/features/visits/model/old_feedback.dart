import 'package:data_soft/core/app_datetime.dart';

class OldFeedbackModel {
  Message? message;

  OldFeedbackModel({this.message});

  OldFeedbackModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  String? toDiscuss;
  String? opportunityOwner;
  String? partyName;
  String? transactionDate;

  Message(
      {this.toDiscuss,
      this.opportunityOwner,
      this.partyName,
      this.transactionDate});

  Message.fromJson(Map<String, dynamic> json) {
    toDiscuss = json['to_discuss'];
    opportunityOwner = json['opportunity_owner'];
    partyName = json['party_name'];
    transactionDate = DateTimeFormating.formatCustomDate(
        date: json['transaction_date'], formatType: 'dd MMMM yyyy');
  }
}
