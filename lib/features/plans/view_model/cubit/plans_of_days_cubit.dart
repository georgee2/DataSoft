import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/app_datetime.dart';
import '../../../today_plan/model/today_plan_model.dart';
import '../../model/plans_of_days_model.dart';
part 'plans_of_days_state.dart';

class PlansOfDaysCubit extends Cubit<PlansOfDaysStates> {
  PlansOfDaysCubit() : super(PlansOfDaysInitialStates());
  static PlansOfDaysCubit get(BuildContext context) => BlocProvider.of(context);

  String? fullDate;
  String? custDateTime;
  String? dayStatus;

  PlansOfDaysModel? plansOfDaysModel;
  List plansData = [];
  setDataToPlansModel(List<DoctorData> data) {
    plansOfDaysModel?.message?.data = data;
    custDateTime = DateTimeFormating.formatCustomDate(
            date: plansOfDaysModel?.message?.data[0].transactionDate,
            formatType: "dd MMM yyyy")
        .toString()
        .toUpperCase();
    emit(SetDataToPlansModelStates());
  }

  changeDate(context) {
    showDialog(
      context: context,
      builder: (context) {
        dynamic start, end, year;
        return Dialog(
          child: SizedBox(
            height: 370,
            width: 350,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SfDateRangePicker(
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      start = args.value.startDate;
                      end = args.value.endDate;
                      year = DateTimeFormating.formatYearDate(
                          args.value.endDate ?? args.value.startDate);
                    },
                    selectionMode: DateRangePickerSelectionMode.extendableRange,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        if (start != null && end != null && year != null) {
                          fullDate =
                              "${DateTimeFormating.formatMonthDate(start)} - ${DateTimeFormating.formatMonthDate(end)} ,${DateTimeFormating.formatYearDate(end ?? start)}";
                          getCustomDateOfPlans(
                              DateTimeFormating.sendFormatDate(start),
                              DateTimeFormating.sendFormatDate(end));
                          Navigator.pop(context);
                        }
                      },
                    ),
                    TextButton(
                      child: const Text("CANCEL"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  getPlans() async {
    emit(PlansOfDaysLoadingStates());
    try {
      Response response = await DioHelper.getData(
          url: EndPoints.GET_VISITS,
          queryParameters: {"opportunity_owner": hubData!.userData!.email});
      if (response.statusCode == 200 &&
          response.data["message"]['success'] == true) {
        plansOfDaysModel = PlansOfDaysModel.fromJson(response.data);
        emit(PlansOfDaysSuccessStates());
        for (var a = 0; a < plansOfDaysModel!.message!.data.length; a++) {
          if (plansOfDaysModel!.message!.data[a].transactionDate == null) {
            plansOfDaysModel!.message!.data[a].transactionDate = "2000-08-16";
          }
          if (plansData.isEmpty) {
            plansData.add({
              "status_plan": plansOfDaysModel!.message!.data[a].statusPlan,
              "transaction_date":
                  plansOfDaysModel!.message!.data[a].transactionDate,
              "data": <DoctorData>[plansOfDaysModel!.message!.data[a]],
            });
            emit(FilterAddNewplanStates());
          } else {
            for (var b = 0; b < plansData.length; b++) {
              if (plansData[b]['transaction_date'] ==
                  plansOfDaysModel!.message!.data[a].transactionDate) {
                plansData[b]['data'].add(plansOfDaysModel!.message!.data[a]);
                if (plansOfDaysModel!.message!.data[a].statusPlan !=
                    plansData[b]['status_plan']) {
                  plansData[b]['status_plan'] = "Partially Approved";
                }
                emit(FilterAddToPlanStates());
                break;
              } else if (b == plansData.length - 1) {
                plansData.add({
                  "status_plan": plansOfDaysModel!.message!.data[a].statusPlan,
                  "transaction_date":
                      plansOfDaysModel!.message!.data[a].transactionDate,
                  "data": <DoctorData>[plansOfDaysModel!.message!.data[a]],
                });
                emit(FilterAddNewplanStates());
              }
            }
          }
        }
      } else {
        emit(PlansOfDaysErrorStates());
      }
    } catch (e) {
      emit(PlansOfDaysErrorStates());
    }
  }

  getCustomDateOfPlans(from, to) async {
    try {
      plansOfDaysModel!.message!.data = [];
      plansData = [];
      emit(PlansfromAndToDateLoadingStates());
      Response response =
          await DioHelper.getData(url: EndPoints.GET_VISITS, queryParameters: {
        "opportunity_owner": hubData!.userData!.email,
        "from_date": from,
        "to_date": to,
      });
      if (response.statusCode == 200 &&
          response.data["message"]['success'] == true) {
        plansOfDaysModel = PlansOfDaysModel.fromJson(response.data);
        emit(PlansfromAndToDateSuccessStates());
        for (var a = 0; a < plansOfDaysModel!.message!.data.length; a++) {
          if (plansOfDaysModel!.message!.data[a].transactionDate == null) {
            plansOfDaysModel!.message!.data[a].transactionDate = "2000-08-16";
          }
          if (plansData.isEmpty) {
            plansData.add({
              "status_plan": plansOfDaysModel!.message!.data[a].statusPlan,
              "transaction_date":
                  plansOfDaysModel!.message!.data[a].transactionDate,
              "data": <DoctorData>[plansOfDaysModel!.message!.data[a]]
            });
            emit(FilterAddNewplanStates());
          } else {
            for (var b = 0; b < plansData.length; b++) {
              if (plansData[b]['transaction_date'] ==
                  plansOfDaysModel!.message!.data[a].transactionDate) {
                plansData[b]['data'].add(plansOfDaysModel!.message!.data[a]);
                emit(FilterAddToPlanStates());
                break;
              } else if (b == plansData.length - 1) {
                plansData.add({
                  "status_plan": plansOfDaysModel!.message!.data[a].statusPlan,
                  "transaction_date":
                      plansOfDaysModel!.message!.data[a].transactionDate,
                  "data": <DoctorData>[plansOfDaysModel!.message!.data[a]]
                });
                emit(FilterAddNewplanStates());
              }
            }
          }
        }
      } else {
        emit(PlansfromAndToDateErrorStates());
      }
    } catch (e) {
      emit(PlansfromAndToDateErrorStates());
    }
  }

  changeDateTime(value) {
    custDateTime = DateTimeFormating.formatCustomDate(
            date: value, formatType: "dd MMM yyyy")
        .toString()
        .toUpperCase();
    emit(ChangeDateTimeState());
    getCustomDateVisits(value);
  }

  getCustomDateVisits(date) async {
    plansOfDaysModel = null;
    Map<String, dynamic> data = {
      "opportunity_owner": hubData!.userData!.email,
      "transaction_date": DateTimeFormating.sendFormatDate(date),
    };
    try {
      emit(GetCustomDateVisitsLoadingStates());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_TODAY_VISITS, queryParameters: data);
      plansOfDaysModel = PlansOfDaysModel.fromJson(response.data);
      getLastVisit();
      if (plansOfDaysModel!.message?.success == true) {
        emit(GetCustomDateVisitsSuccessStates());
        dayStatus = plansOfDaysModel?.message?.status;
      } else {
        emit(GetCustomDateVisitsErrorStates());
      }
    } catch (e) {
      emit(GetCustomDateVisitsErrorStates());
    }
  }

  deleteVisit(index, visitId) async {
    final date = plansOfDaysModel!.message!.data[index].transactionDate;
    try {
      emit(DeleteVisitLoadingStates());
      plansOfDaysModel!.message!.data.removeAt(index);
      await DioHelper.delData(
          url: EndPoints.DELETE_VISIT,
          queryParameters: {"opportunity_name": visitId});
      if (plansOfDaysModel!.message!.data.isEmpty) {
        for (var i = 0; i < plansData.length; i++) {
          if (plansData[i]['transaction_date'] == date) {
            plansData.removeAt(i);
          }
        }
      }
      emit(DeleteVisitSuccessStates());
    } catch (e) {
      emit(DeleteVisitErrorStates());
    }
  }

  getLastVisit() async {
    try {
      emit(GetLastVisitLoadingStates());
      for (var i = 0; i < plansOfDaysModel!.message!.data.length; i++) {
        Map<String, dynamic> data = {
          "opportunity_owner": hubData?.userData?.email,
          "party_name": plansOfDaysModel!.message!.data[i].partyName
        };
        Response response = await DioHelper.getData(
            url: EndPoints.GET_LAST_VISIT, queryParameters: data);
        if (response.data['message']['data'][0]['last_transaction_date'] !=
            null) {
          plansOfDaysModel!.message!.data[i].lastVisit =
              "Last visit: ${DateTimeFormating.formatCustomDate(date: response.data['message']['data'][0]['last_transaction_date'], formatType: "dd MMM yyyy")}";
          emit(GetLastVisitSuccessStates());
        } else {
          emit(GetLastVisitErrorStates());
        }
      }
    } catch (e) {
      emit(GetLastVisitErrorStates());
    }
  }
}
