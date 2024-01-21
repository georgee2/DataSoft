class PocModel {
  List<POCDataModel> data = [];
  PocModel.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      data = <POCDataModel>[];
      json['message'].forEach((v) {
        data.add(POCDataModel.fromJson(v));
      });
    }
  }
}

class POCDataModel{
  String? address;
  String? clientName;
  String? poc;
  String? frequency;
  String? medicalSpecialty;
  bool isShow = false;
  POCDataModel.fromJson(Map<String, dynamic> json) {
    address = json['address'].toString();
    clientName = json['full_name'].toString();
    poc = json['poc'].toString();
    frequency = json['frequency'].toString();
    medicalSpecialty = json['medical_specialty1'].toString();
  }
}
