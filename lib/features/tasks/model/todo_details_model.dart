class TodoDetailsModel {
  String? name;
  String? date;
  String? dueTime;
  String? allocatedTo;
  String? referenceType;
  String? priority;
  String? status;
  String? todoType;
  String? todoName;
  String? description;
  String? assignedby;
  String? attachFile;

  TodoDetailsModel(
      {required this.name,
      required this.date,
      required this.dueTime,
      required this.allocatedTo,
      required this.referenceType,
      required this.priority,
      required this.status,
      required this.description,
      required this.attachFile,
      required this.todoName,
      required this.assignedby,
      required this.todoType});

  TodoDetailsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    date = json['date'] ?? "";
    dueTime = json['due_time'] ?? "";
    allocatedTo = json['allocated_to'] ?? "";
    referenceType = json['reference_type'] ?? "";
    priority = json['priority'] ?? "";
    status = json['status'] ?? "";
    todoType = json['todo_type'] ?? "";
    todoName = json['todo_name'] ?? "";
    assignedby = json['assigned_by'] ?? "";
    attachFile = json['attach_files'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allocated_to'] = allocatedTo;
    data['status'] = status;
    data['priority'] = priority;
    data['date'] = date;
    data['reference_type'] = referenceType;
    data['description'] = description;
    data['todo_name'] = todoName;
    data['assigned_by'] = assignedby;
    data['todo_type'] = todoType;
    data['name'] = name;
    data['due_time'] = dueTime;
    data['attach_files'] = attachFile;
    return data;
  }
}
