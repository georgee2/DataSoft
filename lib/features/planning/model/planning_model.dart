class PlanningModel {
  List<PlanningData> data = [];
  List medicalSpecialty = [];
  List city = [];
  PlanningModel({required this.data});

  PlanningModel.fromJson(Map<String, dynamic> json) {
    data = <PlanningData>[];
    json['message'].forEach((v) {
      data.add(PlanningData.fromJson(v));
      if (!medicalSpecialty.contains(v['medical_specialty'])) {
        medicalSpecialty.add(v['medical_specialty']);
      }
      if (!city.contains(v['city'])) {
        city.add(v['city']);
      }
    });
  }
}

class PlanningData {
  String? customerName;
  String? medicalSpecialty;
  String? partyName;
  String? title;
  bool isSelected = false;

  PlanningData({this.customerName, this.medicalSpecialty});

  PlanningData.fromJson(Map<String, dynamic> json) {
    customerName = json['lead_name']??json['customer_name']??"";
    medicalSpecialty = json['medical_specialty']??"";
    partyName = json['name']??"";
    title = json['title']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = customerName;
    data['medical_specialty'] = medicalSpecialty;
    data['name'] = partyName;
    data['title'] = title;
    return data;
  }
}
