import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../registration/model/registration_model.dart';
import '../../view/plan_requests/plan_requests.dart';
import '../../view/requests_screen.dart';
part 'requests_cycles_state.dart';

class RequestsCyclesCubit extends Cubit<RequestsCyclesState> {
  RequestsCyclesCubit() : super(RequestsCyclesInitial());
  static RequestsCyclesCubit get(BuildContext context) =>
      BlocProvider.of(context);
  List homeCyblesList = [];
  setHomeCycles() {
    if (hubData != null) {
      homeCyblesList = [];
      for (var i = 0; i < hubData!.servicesData.length; i++) {
        if (homeCyblesList.length != 6 &&
            hubData!.servicesData[i].isActive == 1) {
          switch (hubData!.servicesData[i].serviceCode) {
            case "0001" || "0004" || "0003" || "0007" || "0002" || "0012":
              homeCyblesList.add(hubData!.servicesData[i].serviceCode);
              emit(SetHomeCyclesState());
              break;
          }
        }
      }
    }
  }

  homeImages(index) {
    switch (index) {
      case 0 || 2 || 4:
        return "assets/images/home_image_1.png";
      case 1 || 3 || 5:
        return "assets/images/home_image_2.png";
    }
  }

  homeCyclesColors(index) {
    switch (index) {
      case 0 || 2 || 4:
        return const Color(0xff00B1FF).withOpacity(0.6);
      case 1 || 3 || 5:
        return const Color(0xff6A65E3).withOpacity(0.6);
    }
  }

  cyclesIconsAndName(context, code) {
    switch (code) {
      case "0001":
        return [
          "Visits",
          "plans_icon",
          () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RepRequests()));
          }
        ];
      case "0012":
        return [
          "Permissions",
          "settlement_icon",
          () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestsScreen(
                    docType: 'Permission',
                  ),
                ));
          }
        ];
      case "0004":
        return [
          "Expenses",
          "expenses_icon",
          () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestsScreen(
                    docType: 'Employee Advance',
                    expenseType: "Expense",
                  ),
                ));
          }
        ];
      case "0003":
        return [
          "Activities",
          "activities_icon",
          () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestsScreen(
                    docType: 'Employee Advance',
                    expenseType: "Activity",
                  ),
                ));
          }
        ];
      case "0007":
        return [
          "Vacation",
          "vacation_icon",
          () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestsScreen(
                    docType: 'Leave Application',
                  ),
                ));
          }
        ];
      case "0002":
        return [
          "Settlement",
          "settlement_icon",
          () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestsScreen(
                    docType: 'Expense Claim',
                  ),
                ));
          }
        ];
    }
  }
}
