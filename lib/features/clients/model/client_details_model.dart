import 'dart:convert';

class ClientDetailsModel {
  late String name;
  late String leadName;
  String? status;
  String? image;
  String? leadTime;
  String? whatsAppNumber;
  String? facebook;
  String? linkedin;
  late String medicalSpecialty;
  late String mobileNo;
  late String emailId;
  String? location;
  dynamic lat;
  dynamic lng;
  ClientDetailsModel.fromJson(Map<String, dynamic> json) {
    name = json['message'][0]['name'] ?? "";
    status = json['message'][0]['status'] ?? "";
    whatsAppNumber = json['message'][0]['whatsapp_no'];
    facebook = json['message'][0]['facebook'];
    linkedin = json['message'][0]['linkedin'];
    leadTime = json['message'][0]['lead_time'];
    leadName = json['message'][0]['lead_name'];
    medicalSpecialty = json['message'][0]['medical_specialty'] ?? "";
    mobileNo = json['message'][0]['mobile_no'] ?? "";
    emailId = json['message'][0]['email_id'] ?? "";
    // location = json['message'][0]['location'] ?? "";
    image = json['message'][0]['images'] != null
        ? "http://154.38.165.213:1212${json['message'][0]['images']}"
        : null;
    if (json['message'][0]['location'] != null) {
      String jsonString = json['message'][0]['location'];

      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      getLocation(jsonMap);
    }
  }
  getLocation(Map<String, dynamic> jsonMap) {
    if (jsonMap.containsKey("features") && jsonMap["features"].isNotEmpty) {
      var feature = jsonMap["features"][0];

      if (feature.containsKey("geometry") &&
          feature["geometry"].containsKey("coordinates")) {
        List<dynamic> coordinates = feature["geometry"]["coordinates"];

        if (coordinates.length == 2) {
          lat = coordinates[1];
          lng = coordinates[0];
          location =
              'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
        }
      }
    }
  }
}
