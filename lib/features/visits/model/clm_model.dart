class ClmModel {
  Message? message;

  ClmModel({this.message});

  ClmModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  bool? success;
  List<Data> data = [];

  Message({this.success, required this.data});

  Message.fromJson(Map<String, dynamic> json) {
    data = [];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  String? clmName;
  String? image;

  Data({this.clmName, this.image});

  Data.fromJson(Map<String, dynamic> json) {
    clmName = json['clm_name'];
    image = json['image'] == null
        ? "https://medlineplus.gov/images/Medicines.jpg"
        : "http://154.38.165.213:1212${json['image']}";
  }
}
