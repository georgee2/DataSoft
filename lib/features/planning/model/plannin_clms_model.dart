class PlanningClms {
  List<Message>? message;

  PlanningClms({this.message});

  PlanningClms.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }
}

class Message {
  String? name;
  String? image;
  bool isSelected = false;

  Message({this.name, this.image, this.isSelected = false});

  Message.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'] == null
        ? "https://medlineplus.gov/images/Medicines.jpg"
        : "http://154.38.165.213:1212${json['image']}";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
