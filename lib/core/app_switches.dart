import 'package:data_soft/features/permissions/view/permissions_screen.dart';
import 'package:data_soft/features/vacation/view/vacation_screen.dart';
import 'package:data_soft/features/clients/view/clients_screen.dart';
import 'package:data_soft/features/home/view/home_screen.dart';
import 'package:data_soft/features/plans/view/plans_screen.dart';
import 'package:data_soft/features/today_plan/view/today_plan.dart';
import 'package:data_soft/features/profile/view/profile.dart';
import 'package:data_soft/features/settlement/view/settlement_screen.dart';
import 'package:data_soft/features/tasks/view/tasks_screen.dart';
import 'package:data_soft/features/visits/view/visits_screen.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:data_soft/features/activities/view/activities_screen.dart';
import 'package:data_soft/features/poc/view/poc_screen.dart';
import '../features/attendance/view/attendance_screen.dart';
import '../features/check_in/view/check_in_screen.dart';
import '../features/expenses/view/expenses_screen.dart';
import '../features/salaries/view/salary_screen.dart';
import '../features/sales/view/sales_screen.dart';
import 'app_enums.dart';
import 'constants.dart';

Color selectColor(SelectColor selectColor) {
  switch (selectColor) {
    case SelectColor.APPROVED:
      return approvedColor;
    case SelectColor.PENDING:
      return pendingColor;
    case SelectColor.REJECTED:
      return rejectedColor;
    default:
      return primaryColor;
  }
}

colorStatus(status) {
  switch (status) {
    case "Open" || "Draft" || "Pending" || "In Review":
      return {
        "color": selectColor(SelectColor.PENDING),
        "colors": selectGradientColor(SelectColor.PENDING)
      };
    case "Approved" || "Paid" || "Submitted" || "Unpaid":
      return {
        "color": selectColor(SelectColor.APPROVED),
        "colors": selectGradientColor(SelectColor.APPROVED)
      };
    case "Rejected" || "Closed" || "Cancelled":
      return {
        "color": selectColor(SelectColor.REJECTED),
        "colors": selectGradientColor(SelectColor.REJECTED)
      };
    default:
      return {
        "color": selectColor(SelectColor.DEFAULT),
        "colors": selectGradientColor(SelectColor.DEFAULT)
      };
  }
}

String textStatus(status) {
  switch (status) {
    case "Open" || "Draft" || "Pending":
      return "Pending";
    case "Approved" || "Paid" || "Submitted" || "Unpaid":
      return "Approved";
    case "Rejected" || "Closed" || "Cancelled":
      return "Rejected";
    default:
      return status.toString();
  }
}

selectGradientColor(SelectColor selectColor) {
  switch (selectColor) {
    case SelectColor.APPROVED:
      return [
        approvedColor,
        const Color(0xff42C6F3),
      ];
    case SelectColor.PENDING:
      return [pendingColor, const Color(0xffB89102)];
    case SelectColor.REJECTED:
      return [
        rejectedColor,
        const Color(0xffA51720),
      ];
    case SelectColor.DEFAULT:
      return [const Color(0xff0487CF), const Color(0xff3EC2FD)];
  }
}

selectImage(state) {
  switch (state) {
    case "Approved" || "Paid" || "Submitted" || "Unpaid":
      return imageSvg(src: "done", size: 60);
    case "Draft":
      return imageSvg(src: "pinding", size: 60);
    case "Rejected" || "Closed" || "Cancelled":
      return imageSvg(src: "canceled", size: 60);
    case SelectColor.DEFAULT:
      return const Icon(
        Icons.subscript_sharp,
        color: Color(0xffF80102),
        size: 50,
      );
    default:
      return const Icon(
        Icons.subscript_sharp,
        color: Color(0xffF80102),
        size: 50,
      );
  }
}

selectDollar(state) {
  switch (state) {
    case "Approved" || "Paid" || "Submitted" || "Unpaid":
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: imageSvg(src: "activities_icon", size: 60, color: approvedColor),
      );
    case "Open" || "Draft" || "Pending":
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: imageSvg(src: "activities_icon", size: 60, color: pendingColor),
      );
    case "Rejected" || "Closed" || "Cancelled":
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: imageSvg(src: "activities_icon", size: 60, color: rejectedColor),
      );
    default:
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: imageSvg(src: "activities_icon", size: 60, color: primaryColor),
      );
  }
}

navigateAndKill(
    {required BuildContext context, required NavigateAndKill navigateAndKill}) {
  switch (navigateAndKill) {
    case NavigateAndKill.Home:
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
      break;
    case NavigateAndKill.Profile:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ));
      break;
    case NavigateAndKill.Clients:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientScreen(),
          ));
      break;
    case NavigateAndKill.Visits:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisitsScreen(
              tag: '',
            ),
          ));
      break;
    case NavigateAndKill.Plans:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlansScreen(),
          ));
      break;
    case NavigateAndKill.TodayPlans:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodayPlans(),
          ));
      break;
    case NavigateAndKill.Expenses:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpensesScreen(),
          ));
      break;
    case NavigateAndKill.Activities:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivitiesScreen(),
          ));
      break;
    case NavigateAndKill.Vacation:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VacationScreen(),
          ));
      break;
    case NavigateAndKill.Settlement:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettlementScreen(),
          ));
      break;
    case NavigateAndKill.POC:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PocScreen(),
          ));
      break;
    case NavigateAndKill.Sales:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SalesScreen(),
          ));
      break;
    case NavigateAndKill.Tasks:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TasksScreen(),
          ));
      break;
    case NavigateAndKill.Attendance:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceScreen(),
          ));
      break;
    case NavigateAndKill.PERMISSIONS:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PermissionsScreen(),
          ));
      break;
    case NavigateAndKill.CHECK_IN:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckInScreen(),
          ));
      break;
    case NavigateAndKill.SALARIES:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SalaryScreen(),
          ));
      break;
  }
}
