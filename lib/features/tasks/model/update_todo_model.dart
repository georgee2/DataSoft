class UpdateTodoModel {
  late String name;
  late String status;
  UpdateTodoModel({required this.name, required this.status});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['status'] = status;
    return data;
  }
}
