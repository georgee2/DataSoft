class TodoPriorityModel {
  bool? success;
  List<String> data = [];

  TodoPriorityModel({this.success, required this.data});

  TodoPriorityModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'].cast<String>();
  }
}
