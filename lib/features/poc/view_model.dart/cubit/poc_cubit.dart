import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/poc_model.dart';
part 'poc_state.dart';

class PocCubit extends Cubit<PocStates> {
  PocCubit() : super(PocInitialState());
  static PocCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  PocModel? pocModel;
  List pocData = [];
  getPoc() async {
    try {
      emit(PocLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_POC,
          queryParameters: {"lead_owner": hubData!.userData!.email});
      emit(PocSuccessState());
      pocModel = PocModel.fromJson(response.data);
      bool fiteringSwitch = false;
      if (pocModel != null) {
        for (var element in pocModel!.data) {
          if (pocData.isNotEmpty) {
            for (var i = 0; i != pocData.length; i++) {
              if (pocData[i]['address'].toString() ==
                  element.address.toString()) {
                pocData[i]['data'].add(element);
                emit(PocAddWhenContainsDataState());
                break;
              } else if (fiteringSwitch == false && i != pocData.length) {
                pocData.add({
                  "isShow": pocData.isEmpty,
                  "address": element.address,
                  "data": <POCDataModel>[element]
                });
                fiteringSwitch = true;
                emit(PocAddWhenNotFoundDataState());
                break;
              }
            }
          } else {
            pocData.add({
              "isShow": pocData.isEmpty,
              "address": element.address,
              "data": <POCDataModel>[element]
            });
            emit(PocAddFirstTimeState());
          }
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  changeItemState(index) {
    pocData[index]['isShow'] = !pocData[index]['isShow'];
    emit(ChangeShowingItems());
  }
}
