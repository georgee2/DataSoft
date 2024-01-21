import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../planning/model/medical_specialty_model.dart';
import '../model/clients_model.dart';
part 'clients_state.dart';

class ClientsCubit extends Cubit<ClientsEvents> {
  ClientsCubit() : super(ClientsInitial());
  static ClientsCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  ClientsModel? clientsModel;
  MedicalSpecialtyModel? medicalSpecialtyModel;
  List<Clients> searchList = [];
  String? timeSelected;
  String? medicalSpecialtySelected;
  String? citySelected;
  bool isFirstTime = true;
  TextEditingController search = TextEditingController();

  String? clientSelected;

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

  getMedicalSpecialties() async {
    try {
      Response response =
          await DioHelper.getData(url: EndPoints.GET_MEDICAL_SPECIALTY);
      medicalSpecialtyModel = MedicalSpecialtyModel.fromJson(response.data);
    // ignore: empty_catches
    } catch (e) {}
  }

  getClients({leadTime, leadName, firstTime, medicalSpecialty, city}) async {
    timeSelected = leadTime;
    medicalSpecialtySelected = medicalSpecialty;
    clientsModel?.clients = [];
    Map<String, dynamic> data = {
      "lead_owner": hubData?.userData?.email,
      "lead_time": leadTime,
      "lead_name": leadName,
      "first_time": firstTime,
      "medical_specialty": medicalSpecialty,
      "city": city
    };
    emit(GetClientsLoadingState());
    try {
      Response response = await DioHelper.getData(
          url: EndPoints.GET_ALL_CLIENTS, queryParameters: data);
      clientsModel = ClientsModel.fromJson(response.data, isFirstTime);
      isFirstTime = false;
      emit(GetClientsSuccessState());
    } catch (e) {
      emit(GetClientsErrorState());
    }
  }

  searchForClients() {
    List<Clients> result = clientsModel!.clients
        .where((food) => food.leadName
            .toLowerCase()
            .contains(search.text.trim().toLowerCase()))
        .toList();
    searchList = result;
    emit(SearchingForClientsState());
  }

  addNewExpenseAndActivitedSelectedClient(value) {
    clientSelected = value;
    emit(ChooseClientState());
  }
}
