import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/local/cache_helper.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/app_dialogs.dart';
import '../../../../core/app_validations.dart';
import '../../model/check_in_model.dart';
import 'package:geolocator/geolocator.dart';
part 'check_in_state.dart';

class CheckInCubit extends Cubit<CheckInStates> {
  CheckInCubit() : super(CheckInInitialState());
  static CheckInCubit get(BuildContext context) => BlocProvider.of(context);
  CheckInModel? checkInModel;
  List<CheckInDataModel> checkInData = [];
  String? isCheckingToday;
  String dateChecking = DateTimeFormating.sendFormatDate(DateTime.now());
  LocalCheckInData? localCheckInData;
  getLocalCheckingDataState() async {
    final localData = await CacheHelper.getData("checking_data", Map);
    if (localData != null) {
      localCheckInData = LocalCheckInData.fromJson(localData);
      if (DateTimeFormating.sendFormatDate(DateTime.now()) !=
          localCheckInData?.checkinDate) {
        localCheckInData = null;
      }
      emit(GetLocalCheckingDataState());
    }
  }

  changeCheckingData(context) async {
    if (localCheckInData == null) {
      localCheckInData = LocalCheckInData(
          isCheckIn: true,
          isCheckOut: false,
          checkinDate: DateTimeFormating.sendFormatDate(DateTime.now()));
      await CacheHelper.setData("checking_data", localCheckInData!.toJson());
      checkingsRequest(context, "IN");
    } else {
      localCheckInData = LocalCheckInData(
          isCheckIn: true,
          isCheckOut: true,
          checkinDate: DateTimeFormating.sendFormatDate(DateTime.now()));
      await CacheHelper.setData("checking_data", localCheckInData!.toJson());
      checkingsRequest(context, "OUT");
    }
  }

  checkIsChecking() async {
    Map<String, dynamic> data = {
      "employee": hubData?.userData?.employeeId,
      "checkin_date": DateTimeFormating.formatCustomDate(
          date: DateTime.now(), formatType: "yyyy-MM-dd")
    };
    Response response = await DioHelper.getData(
        url: EndPoints.GET_CHECK_IN, queryParameters: data);
    if (response.data['message']['data'].length == 1) {
      isCheckingToday = "IN";
    } else if (response.data['message']['data'].length == 2) {
      isCheckingToday = "IN";
    }
  }

  changeItemState(CheckInDataModel e) {
    e.isShow = !e.isShow!;
    emit(ChangeItemState());
  }

  fiterCheckInData() {
    for (var a = 0; a < checkInModel!.message!.data.length; a++) {
      if (checkInData.isEmpty) {
        checkInData.add(CheckInDataModel(
          isShow: true,
          checkIn: checkInModel!.message!.data[a].logType == "IN"
              ? checkInModel!.message!.data[a].time
              : null,
          checkOut: checkInModel!.message!.data[a].logType == "OUT"
              ? checkInModel!.message!.data[a].time
              : null,
          date: checkInModel!.message!.data[a].checkinDate,
        ));
        emit(FitlerAddedFirstTimeState());
      } else {
        for (var b = 0; b < checkInData.length; b++) {
          if (checkInData[b].date ==
              checkInModel!.message!.data[a].checkinDate) {
            checkInData[b] = CheckInDataModel(
              isShow: checkInData[b].date ==
                  checkInModel!.message!.data[0].checkinDate,
              checkIn: checkInModel!.message!.data[a].logType == "IN"
                  ? checkInModel!.message!.data[a].time
                  : checkInData[b].checkIn,
              checkOut: checkInModel!.message!.data[a].logType == "OUT"
                  ? checkInModel!.message!.data[a].time
                  : checkInData[b].checkOut,
              date: checkInModel!.message!.data[a].checkinDate,
            );
            emit(FitlerUpdatignState());
            break;
          } else if (b == checkInData.length - 1) {
            checkInData.add(CheckInDataModel(
              checkIn: checkInModel!.message!.data[a].logType == "IN"
                  ? checkInModel!.message!.data[a].time
                  : null,
              checkOut: checkInModel!.message!.data[a].logType == "OUT"
                  ? checkInModel!.message!.data[a].time
                  : null,
              date: checkInModel!.message!.data[a].checkinDate,
            ));
            emit(FitlerAddedState());
          }
        }
      }
    }
  }

  getAllItems() async {
    try {
      emit(GetCheckInLoadingState());
      Map<String, dynamic> data = {
        "employee": hubData?.userData?.employeeId,
      };
      Response response = await DioHelper.getData(
          url: EndPoints.GET_CHECK_IN, queryParameters: data);
      checkInModel = CheckInModel.fromJson(response.data);
      if (checkInModel?.message?.success == true) {
        emit(GetCheckInSuccessState());
        fiterCheckInData();
      } else {
        emit(GetCheckInErrorState());
      }
    } catch (e) {
      emit(GetCheckInErrorState());
    }
  }

  checkingsRequest(context, String type) async {
    try {
      emit(AddCheckingLoadingState());
      Map<String, dynamic> data = {
        "employee": hubData!.userData!.employeeId,
        "log_type": type.toUpperCase(),
        "time": DateTime.now().toString(),
        "employee_name": userData!.fullName,
        "checkin_date": DateTimeFormating.sendFormatDate(DateTime.now()),
      };
      Response response =
          await DioHelper.postData(url: EndPoints.ADD_CHECK_IN, query: data);
      if (response.data['message'].toString().trim() == "checkin Created") {
        isCheckingToday = type;
        showSnackBar(context,
            text: "You have successfully checked ${type.toLowerCase()}",
            color: approvedColor);
        emit(AddCheckingSuccessState());
      } else {
        showSnackBar(context, text: "Error");
        emit(AddCheckingErrorState());
      }
    } on DioError catch (e) {
      showSnackBar(context, text: e.message.toString());
      emit(AddCheckingErrorState());
    }
  }

  locationFunction(context) async {
    try {
      Map<Permission, PermissionStatus> status = await [
        Permission.location,
        Permission.locationWhenInUse,
        Permission.locationAlways,
      ].request();
      if (status[Permission.locationWhenInUse] == PermissionStatus.granted) {
        await Geolocator.checkPermission().then((value) async {
          if (value.name != "deniedForever" && value.name != "denied") {
            try {
              await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.best)
                  .then((value) async {
                final locationValidation = AppValidations.calculateDistance(
                    value.latitude,
                    value.longitude,
                    hubData!.lat,
                    hubData!.long);
                if (locationValidation <= hubData!.allowedDistance!) {
                  var info = NetworkInfo();
                  final wifiBSSID = await info.getWifiBSSID();
                  if (hubData?.macAddress?.toUpperCase() ==
                      wifiBSSID.toString().toUpperCase()) {
                    changeCheckingData(context);
                  } else {
                    showSnackBar(context,
                        text: "Please stay close to the Wi-Fi network");
                  }
                } else {
                  showSnackBar(context,
                      text: "You are outside the permitted range");
                }
              });
              // ignore: empty_catches
            } catch (e) {}
          } else {
            locationDialog(context);
          }
        });
      } else {
        locationDialog(context);
      }
    } catch (e) {
      showSnackBar(context, text: "An error occurred");
    }
  }
}
