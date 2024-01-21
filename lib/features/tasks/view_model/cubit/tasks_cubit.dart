// ignore_for_file: empty_catches

import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/features/tasks/model/all_todo_model.dart';
import 'package:data_soft/features/tasks/model/todo_details_model.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/networks/attach_file.dart';
import '../../../notifications/view_model/notification_helper.dart';
import '../../../../core/constants.dart';
import '../../../notifications/model/notification_model.dart';
import '../../model/todo_priority_model.dart';
import '../../model/todo_types_model.dart';
part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksStates> {
  TasksCubit() : super(TasksInitialState());
  static TasksCubit get(BuildContext context) => BlocProvider.of(context);

  TodoModel? todoModel;
  TodoTypeModel? todoTypeModel;
  TodoPriorityModel? todoPriorityModel;
  TextEditingController assignedto = TextEditingController();
  TextEditingController taskName = TextEditingController();
  TextEditingController description = TextEditingController();
  bool allocatedTo = false;

  String screenType = "All";
  String? prioritySelected;
  String? todoSelectedType;
  String transactionDate = DateTimeFormating.sendFormatDate(DateTime.now());
  String dateTime = DateTimeFormating.formatCustomDate(
      date: DateTime.now(), formatType: "dd MMMM ,yyyy");
  String timeOfDay = DateFormat.jm().format(DateTime.now()).toString();
  int taskValue = 3;

  changeScreenType(value) {
    screenType = value;
    switch (value.trim()) {
      case "Pland":
        getAllTodo(status: "", isFirstTime: false);
        break;
      case "In-Progress":
        getAllTodo(status: "Open", isFirstTime: false);
        break;
      case "Completed":
        getAllTodo(status: "Closed", isFirstTime: false);
        break;
      default:
        getAllTodo(isFirstTime: false);
        break;
    }
    emit(ChangeScreenType());
  }

  getTodoDataByDate(date) {
    transactionDate = DateTimeFormating.sendFormatDate(date);

    getAllTodo(isFirstTime: false);
  }

  getTodoTypes() async {
    try {
      Response response =
          await DioHelper.getData(url: EndPoints.GET_TODO_TYPES);
      todoTypeModel = TodoTypeModel.fromJson(response.data['message']);
      todoSelectedType = todoTypeModel?.data[0];
    } catch (e) {}
  }

  changeTodoType(value) {
    todoSelectedType = value;
    emit(ChangeTodoTypeState());
  }

  getTodoPriority() async {
    try {
      Response response =
          await DioHelper.getData(url: EndPoints.GET_TODO_PRIORITY);
      todoPriorityModel = TodoPriorityModel.fromJson(response.data['message']);
      prioritySelected = todoPriorityModel?.data[0];
    } catch (e) {}
  }

  changeTodoPriority(value) {
    prioritySelected = value;
    emit(ChangeTodoPriorityState());
  }

  getAllTodo({status, isFirstTime}) async {
    todoModel?.message = [];
    emit(GetTasksLoadingState());
    Map<String, dynamic> data = {
      "allocated_to": hubData!.userData!.email,
      "status": status,
      "date": transactionDate
    };
    try {
      Response response = await DioHelper.getData(
          url: EndPoints.GET_ALL_TODO, queryParameters: data);
      todoModel =
          TodoModel.fromJson(response.data, isFirstTime: isFirstTime ?? true);
      emit(GetTasksSuccessState());
    } catch (e) {
      emit(GetTasksErrorState());
    }
  }

  changeTaskState(val) {
    taskValue = val;
    emit(ChangeTaskState());
  }

  getTaskState(index) {
    if (todoModel!.message[index].status == "Open") {
      taskValue = 1;
      changeTaskState(1);
    } else if (todoModel!.message[index].status == "Closed") {
      changeTaskState(2);
      taskValue = 2;
    } else {
      taskValue = 0;
      changeTaskState(0);
    }
    Future.delayed(const Duration(seconds: 1)).then((value) {
      emit(ChangeTaskState());
    });
  }

  changeDateTime(value) {
    dateTime = DateTimeFormating.formatCustomDate(
        date: value, formatType: "dd MMMM ,yyyy");
    emit(ChangeDateTimeState());
  }

  changeTimeOfDay(TimeOfDay time) {
    timeOfDay = DateFormat.jm()
        .format(DateTime(2023, 1, 1, time.hour, time.minute))
        .toString();
    emit(ChangeDateTimeState());
  }

  changeAssignedTo() {
    allocatedTo = !allocatedTo;
    assignedto.text = '';
    emit(ChangeAssignedToState());
  }

  taskUpdating(context, index) async {
    try {
      emit(UpdatingTaskLoadingState());
      TodoDetailsModel todoDetailsModel = TodoDetailsModel(
          date: DateTimeFormating.sendFormatDate(
              DateFormat("dd MMMM ,yyyy").parse(dateTime)),
          dueTime: DateFormat("HH:mm")
              .format(DateFormat("hh:mm a").parse(timeOfDay)),
          referenceType: "Opportunity",
          priority: "High",
          status: taskValue == 0
              ? "Approved"
              : taskValue == 1
                  ? "Open"
                  : "Closed",
          assignedby: todoModel!.message[index].assignedby,
          description: description.text.trim(),
          allocatedTo: todoModel!.message[index].allocatedTo,
          name: todoModel!.message[index].name,
          todoName: taskName.text.trim(),
          attachFile: todoModel!.message[index].attachFile,
          todoType: "Visits");
      Response response = await DioHelper.putData(
          url: EndPoints.UPDATE_TODO, query: todoDetailsModel.toJson());
      if (response.data['message'].toString() == "Task Updated") {
        showToast(response.data['message'].toString(), color: approvedColor);
        todoModel!.message[index] = todoDetailsModel;
        emit(UpdatingTaskSuccessState());
        Navigator.pop(context);
      } else {
        showToast(response.data['message'].toString());
        emit(UpdatingTaskErrorState());
      }
    } catch (e) {
      showToast(e);
      emit(UpdatingTaskErrorState());
    }
  }

  selectRep(val, employeeSelected) {
    assignedto.text = val;
    employeeId = employeeSelected;
    if (val.toString().isNotEmpty) {
      allocatedTo = false;
    }
    emit(ChangeRepSelectionState());
  }

  String? employeeId;
  String? attachFile;
  getAttachFile() async {
    emit(GetAttachFileLoadingState());
    try {
      final response = await getAttachUrl();
      if (response != null) {
        attachFile = response;
        emit(GetAttachFileSuccessState());
        showToast("Done");
      } else {
        showToast("field to get attach file");
        emit(GetAttachFileErrorState());
      }
    } catch (e) {
      emit(GetAttachFileErrorState());
      showToast("field to get attach file");
    }
  }

  addNewTodo(context) async {
    try {
      emit(AddNewTaskLoadingState());
      TodoDetailsModel data = TodoDetailsModel(
          allocatedTo: allocatedTo
              ? hubData!.userData!.email
              : assignedto.text.toString(),
          status: "Open",
          priority: prioritySelected,
          date: DateTimeFormating.sendFormatDate(
              DateFormat("dd MMMM ,yyyy").parse(dateTime)),
          referenceType: "Opportunity",
          description: description.text.trim(),
          todoName: taskName.text.trim(),
          todoType: todoSelectedType,
          assignedby: hubData!.userData!.email,
          dueTime: DateFormat("HH:mm")
              .format(DateFormat("hh:mm a").parse(timeOfDay)),
          name: hubData!.userData!.name,
          attachFile: attachFile);
      Response response = await DioHelper.postData(
          url: EndPoints.ADD_NEW_TODO, query: data.toJson());
      if (response.data['message'].toString().trim() == "Task Created") {
        showToast(response.data['message'].toString().trim(),
            color: approvedColor);
        if (todoModel!.message.isNotEmpty) {
          List<TodoDetailsModel> oldList = [data];
          oldList.addAll(todoModel!.message);
          todoModel!.message = [];
          todoModel!.message.addAll(oldList);
        } else {
          todoModel!.message.add(data);
        }
        if (!allocatedTo) {
          sendNotificationAction(
            employeeId,
          );
        }
        emit(AddNewTaskSuccessState());
        Navigator.pop(context);
      } else {
        emit(AddNewTaskErrorState());
        showToast(response.data['message'].toString().trim());
      }
    } catch (e) {
      showToast(e);
      emit(AddNewTaskErrorState());
    }
  }

  sendNotificationAction(id) {
    final data = NotificationModel(
        to: id,
        notification: NotificationHeader(body: "You have a new task"),
        data: Data(type: "Task", screenCode: "000"));
    sendNotification(data: data);
  }
}
