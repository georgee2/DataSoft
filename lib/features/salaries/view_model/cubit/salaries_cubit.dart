import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/salaries_model.dart';
part 'salaries_state.dart';

class SalariesCubit extends Cubit<SalariesStates> {
  SalariesCubit() : super(SalariesInitialState());
  static SalariesCubit get(BuildContext context) => BlocProvider.of(context);
  SalariesModel? salariesModel;
  SalaryData? salaryData;
  
  changeSalaryItem(SalaryData item){
    salaryData = item;
    emit(ChangeSalaryItem());
  }

  getSalaries() async {
    try {
      emit(SalariesLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_SALARIES,
          queryParameters: {"employee": hubData!.userData!.employeeId});
      salariesModel = SalariesModel.fromJson(response.data);
      if (salariesModel?.message?.success == true) {
        salaryData = salariesModel!.message!.data[0];
        emit(SalariesSuccessState());
      } else {
        emit(SalariesErrorState());
      }
    } catch (e) {
      emit(SalariesErrorState());
    }
  }
}
