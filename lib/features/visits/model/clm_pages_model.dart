class ClmPagesModel {
  Message? message;
  String? clmName;

  ClmPagesModel({this.message});

  ClmPagesModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  bool? success;
  List<ClmPageData> data = [];

  Message({this.success, required this.data});

  Message.fromJson(Map<String, dynamic> json) {
    data = [];
    success = json['success'];
    if (json['data'] != null) {
      data = <ClmPageData>[];
      json['data'].forEach((v) {
        data.add(ClmPageData.fromJson(v));
      });
    }
  }
}

class ClmPageData {
  String? itemCode;
  String? imageOfPage;

  ClmPageData({this.itemCode, this.imageOfPage});

  ClmPageData.fromJson(Map<String, dynamic> json) {
    itemCode = json['item_code'];
    imageOfPage = json['image_of_page'] == null
        ? "https://medlineplus.gov/images/Medicines.jpg"
        : "http://154.38.165.213:1212/${json['image_of_page']}";
  }
}
