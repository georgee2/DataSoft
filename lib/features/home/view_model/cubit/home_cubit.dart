import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';
import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/firebase_helper.dart';
import 'package:data_soft/features/home/models/reports_count_model.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../planning/view/planning_screen.dart';
import '../../models/status_percentages_model.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> with WidgetsBindingObserver {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(BuildContext context) => BlocProvider.of(context);
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    try {
      await FirebaseHelper.employees.doc(hubData?.userData?.employeeId).update({
        "userStatus": state == AppLifecycleState.resumed,
        "lastSeen": DateTime.now().toString()
      });
    // ignore: empty_catches
  } catch (e) {}
  }

  ReportsCount? reportsCount;
  StatusPercentagesModel? statusPercentagesModel;
  List homeCyblesList = [];

  setHomeCycles() {
    homeCyblesList.clear();
    if (hubData != null) {
      homeCyblesList = [];
      for (var i = 0; i < hubData!.servicesData.length; i++) {
      if (hubData!.servicesData[i].serviceCode == "0001" &&
          hubData!.servicesData[i].isActive == 1 && homeCyblesList.isEmpty) {
        homeCyblesList.add("000001");
        homeCyblesList.add("00001");
        homeCyblesList.add("0001");
      }
      if (i == hubData!.servicesData.length - 1) {
        for (var a = 0; a < hubData!.servicesData.length; a++) {
          if (homeCyblesList.length <= 9 &&
              hubData!.servicesData[a].isActive == 1) {
            switch (hubData!.servicesData[a].serviceCode) {
              case "0010" || "0004" || "0003" || "0007" || "0002" || "0005":
                homeCyblesList.add(hubData!.servicesData[a].serviceCode);
                emit(SetHomeCyclesState());
                break;
            }
          }
        }
      }
    }
    }
  }

  homeImages(index) {
    switch (index) {
      case 0 || 3 || 6:
        return "assets/images/home_image_1.png";
      case 1 || 4 || 7:
        return "assets/images/home_image_2.png";
      case 2 || 5 || 8:
        return "assets/images/home_image_3.png";
    }
  }

  homeCyclesColors(index) {
    switch (index) {
      case 0 || 3 || 6:
        return const Color(0xff00B1FF).withOpacity(0.6);
      case 1 || 4 || 7:
        return const Color(0xff6A65E3).withOpacity(0.6);
      case 2 || 5 || 8:
        return const Color(0xffFF5D00).withOpacity(0.6);
    }
  }

  cyclesIconsAndName(context,code) {
    switch (code) {
      case "0001":
        return ["visitsTitle".i18n(), "visits_icon",(){navigateAndKill(context: context,navigateAndKill: NavigateAndKill.TodayPlans);}];
      case "00001":
        return ["planStatus".i18n(), "plans_icon",(){navigateAndKill(context: context,navigateAndKill: NavigateAndKill.Plans);}];
      case "000001":
        return ["createPlanIcon".i18n(), "create_plan",(){Navigator.push(context, MaterialPageRoute(builder: (context) => PlanningScreen()));}];
      case "0010":
        return ["clientsTitle".i18n(), "client_icon",(){navigateAndKill(context: context,navigateAndKill: NavigateAndKill.Clients);}];
      case "0004":
        return ["expensesTitle".i18n(), "expenses_icon",(){navigateAndKill(context: context,navigateAndKill: NavigateAndKill.Expenses);}];
      case "0003":
        return ["activitiesTitle".i18n(), "activities_icon",(){navigateAndKill(context: context,navigateAndKill: NavigateAndKill.Activities);}];
      case "0007":
        return ["vacationTitle".i18n(), "vacation_icon",(){navigateAndKill(context: context,navigateAndKill: NavigateAndKill.Vacation);}];
      case "0002":
        return ["settlementTitle".i18n(), "settlement_icon",(){navigateAndKill(context: context,navigateAndKill: NavigateAndKill.Settlement);}];
      case "0005":
        return ["salesTitle".i18n(), "sales_icon",(){navigateAndKill(context: context,navigateAndKill: NavigateAndKill.Sales);}];
    }
  }

  initUserState() async {
    if (statusPercentagesModel == null && hubData != null) {
      await DioHelper.getInit();
      getCounts();
      getStatusPercentages();
      WidgetsBinding.instance.addObserver(this);
      try {
        await FirebaseHelper.employees
            .doc(hubData?.userData?.employeeId)
            .update(
                {"userStatus": true, "lastSeen": DateTime.now().toString()});
      // ignore: empty_catches
  } catch (e) {}
    setHomeCycles();
    }
  }

  getCounts() async {
    emit(GetCountsLoadingState());
    try {
      Response response = await DioHelper.getData(
          url: EndPoints.GET_COUNTS,
          queryParameters: {"display_mode": "count","opportunity_owner":hubData?.userData?.email});
      emit(GetCountsSuccessState());
      reportsCount = ReportsCount.fromJson(response.data);
    } catch (e) {
      emit(GetCountsErrorState());
    }
  }

  getStatusPercentages() async {
    try {
      Map<String, dynamic> data = {
        "opportunity_owner": hubData?.userData?.email
      };
      emit(GetStatusPercentagesLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_STATUS_PERCENTAGES, queryParameters: data);
      statusPercentagesModel = StatusPercentagesModel.fromJson(response.data);
      if (statusPercentagesModel?.message?.date == null) {
        statusPercentagesModel = null;
      }
    // ignore: empty_catches
  } catch (e) {}
  }
  checkHubData() async {
    try {
      var hub  = await CacheHelper.getData("hubData", String);
      print("hooooooooooooome::: $hub");
      final password = await CacheHelper.getData("password", String);
      emit(CheckHubDataLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_HUB_DATA,
          queryParameters: {
            "email": hubData!.userData!.email,
            "password": password
          });
      hubData = HubDataModel.fromJson(response.data['message']);
      CacheHelper.setData("hubData", response.data['message']);
      setHomeCycles();
      emit(CheckHubDataSuccessState());
    } catch (e) {
      emit(CheckHubDataErrorState());
    }
  }
}
