class ClientsModel {
  List<Clients> clients = [];
  List city = [];

  ClientsModel.fromJson(Map<String, dynamic> json, isFirstTime) {
    clients = <Clients>[];
    if (json['message'].isNotEmpty) {
      json['message'].forEach((value) {
        clients.add(Clients.fromJson(value));
        if (!city.contains(value['city']) && value['city'] != null) {
          city.add(value['city']);
        }
      });
    }
  }
}

class Clients {
  String? name;
  late String leadName;
  late String medicalSpecialty;
  late String? image;
  Clients.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    leadName = json['lead_name'];
    medicalSpecialty = json['medical_specialty'].toString();
    image = json['images'] != null
        ? "http://154.38.165.213:1212${json['images']}"
        : null;
  }
}
