import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_datetime.dart';
import '../../../../core/end_points.dart';
import '../../../../core/toast_message.dart';
import '../../../../core/constants.dart';
import '../../../../core/networks/dio_helper.dart';
import '../../../plans/model/plans_of_days_model.dart';
import '../../model/today_plan_model.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
part 'today_plan_state.dart';

class TodayPlanCubit extends Cubit<TodayPlanStates> {
  TodayPlanCubit() : super(TodayPlanInitialState());
  static TodayPlanCubit get(BuildContext context) => BlocProvider.of(context);

  TextEditingController clientName = TextEditingController();
  TextEditingController medicalSpecialty = TextEditingController();
  String? screenType = 'All';
  DoctorData? unplannedDoctorData;

  changeScreenType(type) {
    screenType = type;
    emit(ChangeScreenTypeState());
    switch (type.toString().trim()) {
      case "Completed":
        getVisits(status: "Closed");
        break;
      case "In-Progress":
        getVisits(status: "Converted");
        break;
      case "Pland":
        getVisits(status: "Open");
        break;
      default:
        getVisits();
    }
  }

  TodayPlanModel? todayPlanModel;

  getVisits({status}) async {
    Map<String, dynamic> data = {
      "status": status,
      "status_plan": "Approved",
      "opportunity_owner": hubData!.userData!.email,
      "transaction_date": DateTimeFormating.sendFormatDate(DateTime.now()),
    };
    try {
      emit(GetTodayPlansLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_TODAY_VISITS, queryParameters: data);
      todayPlanModel = TodayPlanModel.fromJson(response.data);
      if (todayPlanModel!.message?.success == true) {
        emit(GetTodayPlansSuccessState());
      } else {
        emit(GetTodayPlansErorState());
      }
    } catch (e) {
      emit(GetTodayPlansErorState());
    }
  }

  PlansOfDaysModel? plansOfDaysModel;
  getAllPlansToUnplanndVisit(context) async {
    if (clientName.text.trim().isEmpty ||
        medicalSpecialty.text.trim().isEmpty) {
      emit(GetAllPlansLoadingState());
      try {
        Response response = await DioHelper.getData(
            url: EndPoints.GET_VISITS,
            queryParameters: {
              "opportunity_owner": hubData!.userData!.email,
              "status_plan": "Approved",
              "status": "Open"
            });
        plansOfDaysModel =
            PlansOfDaysModel.fromJson(response.data, isUniqueDoctor: true);
      } catch (e) {
        emit(GetAllPlansErorState());
      }
    }
  }

  changeUnplannedDoctorData(DoctorData doctorData) {
    unplannedDoctorData = doctorData;
    getUnplannedVisitsData();
    emit(ChangeDoctorDataState());
  }

  List<DoctorData> unplannedVisits = [];
  getUnplannedVisitsData() {
    unplannedVisits = [];
    for (var i = 0; i < plansOfDaysModel!.message!.data.length; i++) {
      if (plansOfDaysModel!.message!.data[i].partyName ==
          unplannedDoctorData?.partyName) {
        unplannedVisits.add(plansOfDaysModel!.message!.data[i]);
        emit(AddUnplanndDoctorDataState());
      }
    }
  }

  postPoneVisit(context) async {
    Map<String, dynamic> data = {
      "opportunity_name": unplannedDoctorData?.visitId,
      "contact_date": DateTimeFormating.sendFormatDate(DateTime.now()),
      "to_discuss": 'Unplanned Visit'
    };
    emit(UnplanVisitLoadingState());
    try {
      Response response =
          await DioHelper.putData(url: EndPoints.POSTPONED_VISIT, query: data);
      if (response.data['message']['success'] == true) {
        showToast("Visit Updated", color: approvedColor);
        unplannedDoctorData?.transactionDate =
            DateTimeFormating.sendFormatDate(DateTime.now());
        todayPlanModel?.message?.data.insert(0, unplannedDoctorData!);
        emit(UnplanVisitSuccessState());
        Navigator.pop(context);
      } else {
        showToast("Visit not update");
        emit(UnplanVisitErorState());
      }
    } catch (e) {
      showToast("Error");
      emit(UnplanVisitErorState());
    }
  }

  changeVisitStatus(context, DoctorData doctorData) async {
    Map<String, dynamic> data = {
      "doc_name": doctorData.visitId,
      "status": "Closed",
      "status_plan": "Approved"
    };
    try {
      await DioHelper.putData(url: EndPoints.UPDATE_VISIT_STATUS, query: data);
      showSnackBar(context, text: "Done", color: approvedColor);
      emit(ChangeVisitStatus());
    } catch (e) {
      emit(ChangeVisitStatus());
      showSnackBar(context, text: "Visit Updating Error", color: rejectedColor);
    }
  }
}
