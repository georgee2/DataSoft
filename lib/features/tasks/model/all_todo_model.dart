import 'package:data_soft/features/tasks/model/todo_details_model.dart';

class TodoModel {
  List<TodoDetailsModel> message = [];
  int completedCount = 0;

  TodoModel({required this.message});

  TodoModel.fromJson(Map<String, dynamic> json,{isFirstTime}) {
    if (json['message'] != null) {
      message = <TodoDetailsModel>[];
      json['message'].forEach((v) {
        message.add(TodoDetailsModel.fromJson(v));
        if(v['status'] == "Closed" && isFirstTime){
          completedCount++;
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message.map((v) => v.toJson()).toList();
    return data;
  }
}
