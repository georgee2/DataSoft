class TodayPlanModel {
  TodayPlanmessageDataModel? message;

  TodayPlanModel({this.message});

  TodayPlanModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] != null
        ? TodayPlanmessageDataModel.fromJson(json['message'])
        : null;
  }
}

class TodayPlanmessageDataModel {
  bool? success;
  List<DoctorData> data = [];

  TodayPlanmessageDataModel({this.success, required this.data});

  TodayPlanmessageDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DoctorData>[];
      json['data'].forEach((v) {
        data.add(DoctorData.fromJson(v));
      });
    }
  }
}

class DoctorData {
  String? visitId;
  String? partyName;
  String? customerName;
  String? medicalSpecialty;
  String? status;
  String? transactionDate;
  String? statusPlan;
  String? linkQuestions;
  String? lastVisit;
  String? images;
  int? includeClm;

  DoctorData(
      {this.visitId,
      this.partyName,
      this.customerName,
      this.medicalSpecialty,
      this.status,
      this.transactionDate,
      this.statusPlan});

  DoctorData.fromJson(Map<String, dynamic> json) {
    visitId = json['name'] ?? "";
    partyName = json['party_name'] ?? "";
    customerName = json['customer_name'] ?? json['lead_name'] ?? "";
    medicalSpecialty = json['medical_specialty'] ?? "";
    status = json['status'] ?? "";
    transactionDate = json['transaction_date'] ?? "";
    statusPlan = json['status_plan'] ?? "";
    linkQuestions = json['link_questions'];
    includeClm = json['include_clm'] ?? 0;
    images = json['images'] == null
        ? null
        : "http://154.38.165.213:1212${json['images']}";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = visitId;
    data['party_name'] = partyName;
    data['customer_name'] = customerName;
    data['medical_specialty'] = medicalSpecialty;
    data['status'] = status;
    data['transaction_date'] = transactionDate;
    data['status_plan'] = statusPlan;
    data['images'] = "http://154.38.165.213:1212$images";
    return data;
  }
}
