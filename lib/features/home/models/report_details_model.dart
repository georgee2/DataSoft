class ReportModel {
  ReportMessage? message;

  ReportModel({this.message});

  ReportModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] != null
        ? ReportMessage.fromJson(json['message'])
        : null;
  }
}

class ReportMessage {
  List<ReportData> reportData = [];

  ReportMessage({required this.reportData});

  ReportMessage.fromJson(Map<String, dynamic> json) {
    if (json['unplanned_opportunities'] != null) {
      reportData = <ReportData>[];
      json['unplanned_opportunities'].forEach((v) {
        reportData.add(ReportData.fromJson(v));
      });
    }
    if (json['uncovered_opportunities'] != null) {
      reportData = <ReportData>[];
      json['uncovered_opportunities'].forEach((v) {
        reportData.add(ReportData.fromJson(v));
      });
    }
  }
}

class ReportData {
  String? opportunityName;
  String? partyName;
  String? customerName;
  String? medicalSpecialty;

  ReportData(
      {this.opportunityName,
      this.partyName,
      this.customerName,
      this.medicalSpecialty});

  ReportData.fromJson(Map<String, dynamic> json) {
    opportunityName = json['opportunity_name'].toString();
    partyName = json['party_name'].toString();
    customerName = json['customer_name'].toString();
    medicalSpecialty = json['medical_specialty'].toString();
  }
}
