class TodoTypeModel {
  bool? success;
  List<String> data = [];

  TodoTypeModel({this.success, required this.data});

  TodoTypeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'].cast<String>();
  }
}
