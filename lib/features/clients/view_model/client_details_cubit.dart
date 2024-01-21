import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/features/clients/model/client_details_model.dart';
import 'package:data_soft/features/clients/view_model/clients_cubit.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientDetailsCubit extends Cubit<ClientDetailsEvents> {
  ClientDetailsCubit() : super(ClientDetailsInitial());
  static ClientDetailsCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  ClientDetailsModel? clientDetailsModel;
  getClientDetails(leadName) async {
    emit(GetClientsDetailsLoadingState());
    try {
      Response response = await DioHelper.getData(
          url: EndPoints.GET_CLIENT_DETAILS,
          queryParameters: {"lead_name": leadName});
      clientDetailsModel = ClientDetailsModel.fromJson(response.data);
      emit(GetClientsDetailsSuccessState());
    } catch (e) {
      emit(GetClientsDetailsErrorState());
    }
  }
}
