import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networks/attach_file.dart';
import '../../../notifications/view_model/notification_helper.dart';
import '../../../notifications/model/notification_model.dart';
import '../../model/permission_model.dart';
import '../../model/permissions_types_model.dart';
part 'permissions_state.dart';

class PermissionsCubit extends Cubit<PermissionsStates> {
  PermissionsCubit() : super(PermissionsInitialState());
  static PermissionsCubit get(BuildContext context) => BlocProvider.of(context);
  PermissionsModel? permissionsModel;
  PermissionsTypes? permissionsTypes;
  TextEditingController comment = TextEditingController();
  String permissionsSelected = "";
  String fromTime = "";
  String? sendFromTime;
  String? sendToTime;
  String toTime = "";

  initTime(context) {
    fromTime = TimeOfDay.now().format(context);
    toTime = TimeOfDay.now().format(context);
    sendFromTime = format(context, TimeOfDay.now());
    sendToTime = format(context, TimeOfDay.now());
    emit(ChangePermissioninitTimeState());
  }

  String format(BuildContext context, value) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(
      value,
      alwaysUse24HourFormat: true,
    );
  }

  setFromTime(context) {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      if (value != null) {
        fromTime = value.format(context);
        MaterialLocalizations.of(context)
            .timeOfDayFormat(alwaysUse24HourFormat: true);
        sendFromTime = format(context, value);
        emit(ChangePermissionFromTimeState());
      }
    });
  }

  setToTime(context) {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      if (value != null) {
        toTime = value.format(context);
        sendToTime = format(context, value);
        emit(ChangePermissionToTimeState());
      }
    });
  }

  getPermissions() async {
    try {
      permissionsModel = null;
      emit(GetPermissionsLoadingState());
      Map<String, dynamic> data = {
        "employee": hubData!.userData!.employeeId,
        "display_mode": "u_permissions"
      };
      Response response = await DioHelper.getData(
          url: EndPoints.GET_PERMISSIONS, queryParameters: data);
      if (response.data['message']['u_permissions'] != null) {
        permissionsModel = PermissionsModel.fromJson(response.data);
        emit(GetPermissionsSuccessState());
      } else {
        emit(GetPermissionsErrorState());
      }
    } catch (e) {
      emit(GetPermissionsErrorState());
    }
  }

  getPermissionsTypes() async {
    try {
      emit(GetPermissionsTypesLoadingState());
      Response response =
          await DioHelper.getData(url: EndPoints.GET_PERMISSIONS_TYPES);
      if (response.data['message'] != null) {
        permissionsTypes = PermissionsTypes.fromJson(response.data);
        if (permissionsTypes!.message.isNotEmpty) {
          emit(GetPermissionsTypesSuccessState());
          permissionsSelected = permissionsTypes!.message[0].name ?? "";
        } else {
          emit(GetPermissionsTypesErrorState());
        }
      } else {
        emit(GetPermissionsTypesErrorState());
      }
    } catch (e) {
      emit(GetPermissionsTypesErrorState());
    }
  }

  selectPermissionType(type) {
    permissionsSelected = type;
    emit(SelectPermissionsTypeLoadingState());
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

  addPermission(context) async {
    try {
      final year = DateTime.now().year;
      final month = DateTime.now().month;
      final day = DateTime.now().day;
      emit(AddPermissionsLoadingState());
      UPermissions data = UPermissions(
          employee: hubData!.userData!.employeeId,
          permissionType: permissionsSelected,
          fromTime: "$year-$month-$day $sendFromTime",
          toTime: "$year-$month-$day $sendToTime",
          date: DateTimeFormating.sendFormatDate(DateTime.now()),
          reason: comment.text.trim(),
          attachFile: attachFile,
          status: "Draft");
      Response response = await DioHelper.postData(
          url: EndPoints.ADD_PERMISSION, query: data.toJson());
      if (response.data['message']['success'] == true) {
        emit(AddPermissionsSuccessState());
        getPermissions();
        Navigator.pop(context);
        showSnackBar(context,
            text: "Permission Add Successfully", color: approvedColor);
      } else {
        emit(AddPermissionsErrorState());
      }
    } catch (e) {
      emit(AddPermissionsErrorState());
    }
  }

  sendNotificationAction() {
    final data = NotificationModel(
        notification: NotificationHeader(body: "Need a new permission"),
        data: Data(type: "Permission", screenCode: "000"));
    sendNotification(data: data);
  }
}
