// ignore_for_file: empty_catches

import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/planning/model/planning_model.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_datetime.dart';
import '../../../notifications/view_model/notification_helper.dart';
import '../../../notifications/model/notification_model.dart';
import '../../../registration/model/registration_model.dart';
import '../../model/medical_specialty_model.dart';
import '../../model/plannin_clms_model.dart';
part 'planning_state.dart';

class PlanningCubit extends Cubit<PlanningStates> {
  PlanningCubit() : super(PlanningInitialState());
  static PlanningCubit get(BuildContext context) => BlocProvider.of(context);

  PlanningModel? planningModel;
  PlanningClms? planningClms;
  MedicalSpecialtyModel? medicalSpecialtyModel;
  List clmsSelected = [];
  List<PlanningData> searchList = [];
  List<PlanningData> clientsSelected = [];
  bool isClmplan = false;
  String? screenType;
  TextEditingController search = TextEditingController();
  String dateTime = DateTimeFormating.formatCustomDate(
      date: DateTime.now(), formatType: "dd MMM ,yyyy");
  String sendingDate = DateTimeFormating.sendFormatDate(DateTime.now());
  bool isAllSelection = false;

  String? timeSelected;
  String? medicalSpecialtySelected;
  String? citySelected;

  changeScreenTypeState(val) {
    screenType = val;
    switch (val.trim()) {
      case "Last Visit":
        getLastVisit();
        break;
      case "First Time":
        getAllClients(firstTime: 1);
        break;
      case "AM Only":
        getAllClients(leadTime: "AM");
        break;
      case "PM Only":
        getAllClients(leadTime: "PM");
        break;
      default:
    }
    emit(ChangeScreenTypeState());
  }

  searchForClients() {
    try {
      List<PlanningData> result = planningModel!.data
          .where((client) => client.customerName!
              .toLowerCase()
              .contains(search.text.trim().toLowerCase()))
          .toList();
      searchList = result;
      emit(SearchingForClientsState());
    } catch (e) {}
  }

  changeClientTimeFiltering(val) {
    timeSelected = null;
    if (val == "AM Only") {
      timeSelected = "AM";
    } else if (val == "PM Only") {
      timeSelected = "PM";
    }
    emit(ChangeClientTimeFilteringState());
  }

  changeClientMedicalSpecialtyFiltering(val) {
    medicalSpecialtySelected = val == "All" ? null : val;
    emit(ChangeClientMedicalSpecialtyFilteringState());
  }

  changeClientLocationSelectedFiltering(val) {
    citySelected = val == "All" ? null : val;
    emit(ChangeClientLocationSelectedFilteringState());
  }

  getPlanningClms() async {
    try {
      emit(GetPlanningClmsLoadingState());
      Response response =
          await DioHelper.getData(url: EndPoints.GET_PLANNING_CLMS);
      planningClms = PlanningClms.fromJson(response.data);
      emit(GetPlanningClmsSuccessState());
    } catch (e) {
      emit(GetPlanningClmsErrorState());
    }
  }

  changeIncludingClm() {
    isClmplan = !isClmplan;
    emit(ChangeIncludingClmState());
  }

  changeClmSelection(val) {
    if (clmsSelected.contains(val)) {
      clmsSelected.remove(val);
    } else {
      clmsSelected.add(val);
    }
    emit(ChangeIncludingClmDataState());
  }

  getAllClients({leadTime, leadName, firstTime, medicalSpecialty, city}) async {
    timeSelected = leadTime;
    medicalSpecialtySelected = medicalSpecialty;
    planningModel = null;
    Map<String, dynamic> data = {
      "lead_owner": hubData?.userData?.email,
      "lead_time": leadTime,
      "lead_name": leadName,
      "first_time": firstTime,
      "medical_specialty": medicalSpecialty,
      "city": city
    };
    try {
      emit(GetPlanningLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_ALL_CLIENTS, queryParameters: data);
      planningModel = PlanningModel.fromJson(response.data);
      emit(GetPlanningSuccessState());
    } catch (e) {
      emit(GetPlanningErrorState());
    }
  }

  getLastVisit() async {
    planningModel = null;
    try {
      emit(GetPlanningLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_LAST_VISIT,
          queryParameters: {
            "opportunity_owner": hubData?.userData?.email,
          });
      if (response.data['message']['success'] == true) {
        final data = {"message": response.data['message']['data']};
        planningModel = PlanningModel.fromJson(data);
        emit(GetPlanningSuccessState());
      }
    } catch (e) {
      emit(GetPlanningErrorState());
    }
  }

  getMedicalSpecialties() async {
    try {
      Response response =
          await DioHelper.getData(url: EndPoints.GET_MEDICAL_SPECIALTY);
      medicalSpecialtyModel = MedicalSpecialtyModel.fromJson(response.data);
    } catch (e) {}
  }

  changeClientSelection(val, index) {
    planningModel!.data[index].isSelected = val;
    if (isAllSelection && !val) {
      isAllSelection = false;
      emit(ChangeClientsSelectionState());
    } else {
      emit(ChangeClientsSelectionState());
    }
  }

  changeAllClientSelectionState({type}) {
    isAllSelection = !isAllSelection;
    if (!type) {
      isAllSelection = type;
    }
    if (planningModel != null) {
      for (var i = 0; i < planningModel!.data.length; i++) {
        planningModel!.data[i].isSelected = isAllSelection;
        if (isAllSelection && i == planningModel!.data.length - 1) {
          clientsSelected = planningModel!.data;
        } else if (!isAllSelection && i == planningModel!.data.length - 1) {
          clientsSelected = [];
        }
        emit(ChangeAllClientsSelectionState());
      }
    }
  }

  changeDateTime(value) {
    dateTime = DateTimeFormating.formatCustomDate(
        date: value, formatType: "dd MMM ,yyyy");
    sendingDate = DateTimeFormating.sendFormatDate(value);
    emit(ChangeDateTimeState());
  }

  updateVisitClms(visitId) async {
    for (var i = 0; i < clmsSelected.length; i++) {
      try {
        Map<String, dynamic> data = {
          "opportunity_name": visitId,
          "clm_name": clmsSelected[i]
        };

        await DioHelper.putData(url: EndPoints.END_VISIT, query: data);
      } catch (e) {}
    }
  }

  addNewPlan() async {
    try {
      emit(AddNewPlanLoadingState());
      for (var i = 0; i < planningModel!.data.length; i++) {
        if (planningModel!.data[i].isSelected) {
          Map<String, dynamic> data = {
            "title": planningModel!.data[i].customerName,
            "party_name": planningModel!.data[i].partyName,
            "status": "Open",
            "contact_date": '',
            "opportunity_from": "Lead",
            "opportunity_owner": hubData!.userData!.email,
            "status_plan": "In Review",
            "transaction_date": sendingDate,
            "planning_status": "Planned",
            "include_clm": isClmplan ? 1 : 0,
          };
          Response response =
              await DioHelper.postData(url: EndPoints.ADD_PLANNED, query: data);
          planningModel!.data[i].isSelected = false;
          emit(AddNewPlanSuccessState());
          if (isClmplan) {
            updateVisitClms(response.data['message']);
          }
          showToast("Created", color: approvedColor);
        }
        if (i == planningModel!.data.length - 1) {
          final data = NotificationModel(
              notification: NotificationHeader(body: "Created new plan"),
              data: Data(type: "Plan", screenCode: "000"));
          sendNotification(data: data);
          showToast("Plan creation has been completed", color: approvedColor);
        }
      }
    } catch (e) {
      emit(AddNewPlanErrorState());
    }
  }
}
