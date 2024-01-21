import 'package:flutter/material.dart';

class VisitQuestions {
  Message? message;

  VisitQuestions({this.message});

  VisitQuestions.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  List<QuestionLogData> questionLogData = [];

  Message({required this.questionLogData});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['question_log_data'] != null) {
      questionLogData = <QuestionLogData>[];
      json['question_log_data'].forEach((v) {
        questionLogData.add(QuestionLogData.fromJson(v));
      });
    }
  }
}

class QuestionLogData {
  String? opportunityName;
  String? templateName;
  String? question;
  String? questionValue;
  String? attachFile;
  TextEditingController answer = TextEditingController();

  QuestionLogData(
      {this.templateName,
      this.question,
      required this.questionValue,
      required this.opportunityName,
      required this.attachFile,
      required this.answer});

  QuestionLogData.fromJson(Map<String, dynamic> json) {
    templateName = json['template_name'];
    question = json['question'];
    questionValue = json['question_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['opportunity_name'] = opportunityName;
    data['question'] = questionValue;
    data['attach_files'] = attachFile;
    data['answer'] = answer.text.trim();
    return data;
  }
}
