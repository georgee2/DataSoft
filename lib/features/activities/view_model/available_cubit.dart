import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/available_budget.dart';
part 'available_state.dart';

class AvailableCubit extends Cubit<AvailableStates> {
  AvailableCubit() : super(AvailableInitialStates());
  static AvailableCubit get(BuildContext context) => BlocProvider.of(context);

  AvailableBudgetModel? availableBudgetModel;

  getAvailableBudget() async {
    try {
      emit(GetAvailableBudgetLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_AVAILABLE_BUDGET,
          queryParameters: {"employee": hubData?.userData?.employeeId});
      availableBudgetModel = AvailableBudgetModel.fromJson(response.data);
      if (availableBudgetModel?.message?.success == true) {
        emit(GetAvailableBudgetSuccessState());
      } else {
        emit(GetAvailableBudgetErrorState());
      }
    } catch (e) {
      emit(GetAvailableBudgetErrorState());
    }
  }
}
