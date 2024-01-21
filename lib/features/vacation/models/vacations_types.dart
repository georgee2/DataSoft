class VacationsTypeModel {
  List<VacationsMessage> message = [];

  VacationsTypeModel({required this.message});

  VacationsTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <VacationsMessage>[];
      json['message'].forEach((v) {
        message.add(VacationsMessage.fromJson(v));
      });
    }
  }
}

class VacationsMessage {
  String? name;

  VacationsMessage({this.name});

  VacationsMessage.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}
