import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/models/report_details_model.dart';
import '../../../registration/model/registration_model.dart';
part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());
  static ReportsCubit get(BuildContext context) => BlocProvider.of(context);
  ReportModel? reportModel;

  String checkReportType(type) {
    switch (type) {
      case "Uncovered doctors":
        return "opportunity_uncovered";
      case "Unplanned visits":
        return "opportunity_unplanned";
      case "Cancelled visits":
        return "opportunity_cancelled";
      default:
        return "else";
    }
  }

  getReports(reportType) async {
    try {
      emit(GetReportsLoadingState());
      Map<String, dynamic> data = {"display_mode": checkReportType(reportType),"opportunity_owner":hubData?.userData?.email};
      Response response = await DioHelper.getData(
          url: EndPoints.GET_COUNTS, queryParameters: data);
      if (response.data['message']['unplanned_opportunities'] != null || response.data['message']['uncovered_opportunities'] != null) {
        reportModel = ReportModel.fromJson(response.data);
        emit(GetReportsSuccessState());
      } else {
        showToast(response.data['message']['error']);
        emit(GetReportsErrorState());
      }
    } catch (e) {
      emit(GetReportsErrorState());
    }
  }
}
