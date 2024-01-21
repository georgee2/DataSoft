class DistributionModel {
  Message? message;

  DistributionModel({this.message});

  DistributionModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  bool? success;
  List<String> data = [];

  Message({this.success, required this.data});

  Message.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data.add("All");
      data.addAll(json['data'].cast<String>());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['data'] = data;
    return data;
  }
}
