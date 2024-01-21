class PermissionsTypes {
  List<Message> message = [];

  PermissionsTypes({required this.message});

  PermissionsTypes.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message.add(Message.fromJson(v));
      });
    }
  }
}

class Message {
  String? name;
  String? salaryComponent;

  Message({this.name, this.salaryComponent});

  Message.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    salaryComponent = json['salary_component'];
  }
}
