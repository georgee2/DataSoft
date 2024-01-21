import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/activities/model/activities_model.dart';
import 'package:data_soft/features/activities/model/advance_types.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/networks/attach_file.dart';
import '../../notifications/view_model/notification_helper.dart';
import '../../notifications/model/notification_model.dart';
part 'activities_state.dart';

class ActivitiesCubit extends Cubit<ActivitiesStates> {
  ActivitiesCubit() : super(ActivitiesInitialState());
  static ActivitiesCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  ActivitiesModel? activitiesModel;
  AdvanceTypesModel? advanceTypesModel;
  String? activitySelected;
  String screenType = "All";
  TextEditingController amount = TextEditingController();
  TextEditingController client = TextEditingController();
  TextEditingController activityName = TextEditingController();
  TextEditingController comment = TextEditingController();

  changeScreenType(type) {
    screenType = type;
    switch (type.trim()) {
      case "All":
        getActivities();
        break;
      case "Approved":
        getActivities(status: "paid");
        break;
      case "Rejected":
        getActivities(status: "Cancelled");
        break;
      case "Pending":
        getActivities(status: "Draft");
        break;
    }
    activitiesModel = null;
    emit(ChangeScreenTypeState());
  }

  getActivities({status}) async {
    try {
      emit(GetActivitiesLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_ACTIVITIES,
          queryParameters: {
            "employee": hubData!.userData!.employeeId,
            "type_expense": "Activity",
            "status": status
          });
      activitiesModel = ActivitiesModel.fromJson(response.data);
      emit(GetActivitiesSuccessState());
    } catch (e) {
      emit(GetActivitiesErrorState());
    }
  }

  getActivitiesTypes() async {
    try {
      emit(GetActivityTypesLoadingState());
      Response response =
          await DioHelper.getData(url: EndPoints.GET_EXPENSES_TYPE);
      advanceTypesModel = AdvanceTypesModel.fromJson(response.data);
      emit(GetActivityTypesSuccessState());
    } catch (e) {
      emit(GetActivityTypesErrorState());
    }
  }

  changeActivitySelection(value) {
    activitySelected = value;
    emit(ChangeSelectionTypeState());
  }

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

  addNewActivity(context) async {
    try {
      ActivitiesData data = ActivitiesData(
          typeExpense: "Activity",
          advanceAmount: double.parse(amount.text.trim()),
          lead: client.text.trim(),
          purpose: comment.text.trim(),
          employee: hubData!.userData!.employeeId,
          exchangeRate: 1.0,
          activityName: activityName.text.trim(),
          expenseType:
              activitySelected ?? advanceTypesModel!.message[0].name.toString(),
          attachFiles: attachFile,
          postingDate: DateTimeFormating.sendFormatDate(DateTime.now()));
      Response response = await DioHelper.postData(
          url: EndPoints.ADD_NEW_ACTIVITIES, query: data.toJson());
      Navigator.pop(context);
      if (response.data['message'] == "failed to create new activity") {
        showToast(response.data['message'].toString());
      } else {
        changeScreenType(screenType);
        showToast(response.data['message'].toString(), color: approvedColor);
        sendNotificationAction();
      }
    } catch (e) {
      showToast(e);
    }
  }

  sendNotificationAction() {
    final data = NotificationModel(
        notification: NotificationHeader(body: "Need a new activity"),
        data: Data(type: "Activity", screenCode: "000"));
    sendNotification(data: data);
  }
}
