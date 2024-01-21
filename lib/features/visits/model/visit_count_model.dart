class VisitCountModel {
  String? opportunityName;
  String? doctorName;
  String? image;
  String? medicalSpecialty;
  String? visitStatus;
  String? countFrom;
  String? countTo;
  String? doctorID;
  bool? isClm;
  int? timerDuration;
  String? linkQuestions;
  List? clmData = [];

  VisitCountModel(
      {required this.opportunityName,
      required this.countFrom,
      required this.countTo,
      required this.isClm,
      required this.doctorName,
      required this.medicalSpecialty,
      required this.image,
      this.timerDuration,
      this.doctorID,
      required this.clmData});
  VisitCountModel.fromJson(Map<String, dynamic> json) {
    opportunityName = json['opportunity_name'];
    doctorID = json['party_name'];
    countFrom = json['count_from'];
    countTo = json['count_to'];
    clmData = json['clm_data'];
    isClm = json['isClm'];
    medicalSpecialty = json['medical_specialty'];
    image = json['image'];
    doctorName = json['lead_name'];
    visitStatus = json['status'];
    timerDuration = json['timer_duration'];
    linkQuestions = json['link_questions'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['opportunity_name'] = opportunityName;
    data['party_name'] = doctorID;
    data['count_from'] = countFrom;
    data['count_to'] = countTo;
    data['clm_data'] = clmData;
    data['isClm'] = isClm;
    data['medical_specialty'] = medicalSpecialty;
    data['image'] = image;
    data['lead_name'] = doctorName;
    data['status'] = visitStatus;
    data['timer_duration'] = timerDuration;
    data['link_questions'] = linkQuestions;
    return data;
  }
}
