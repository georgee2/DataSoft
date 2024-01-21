class AdvanceTypesModel {
  List<Message> message = [];

  AdvanceTypesModel({required this.message});

  AdvanceTypesModel.fromJson(Map<String, dynamic> json) {
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

  Message({this.name});

  Message.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}
