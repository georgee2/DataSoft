import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/activities/model/advance_types.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_datetime.dart';
import '../../../../core/networks/attach_file.dart';
import '../../../notifications/view_model/notification_helper.dart';
import '../../../../core/constants.dart';
import '../../../notifications/model/notification_model.dart';
import '../../model/get_expenses_model.dart';
part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesStates> {
  ExpensesCubit() : super(ExpensesInitialState());
  static ExpensesCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  String screenType = "All";
  ExpensesModel? expensesModel;
  AdvanceTypesModel? advanceTypesModel;
  String? expenseSelected;
  TextEditingController amount = TextEditingController();
  TextEditingController client = TextEditingController();
  TextEditingController expenseName = TextEditingController();
  TextEditingController comment = TextEditingController();
  changeScreenType(type) {
    screenType = type;
    switch (type) {
      case "All":
        getExpenses();
        break;
      case "Approved":
        getExpenses(status: "paid");
        break;
      case "Rejected":
        getExpenses(status: "Cancelled");
        break;
      case "Pending":
        getExpenses(status: "Draft");
        break;
    }
    expensesModel = null;
    emit(ChangeScreenTypeState());
  }

  getExpenses({status}) async {
    try {
      emit(GetExpensesLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_EXPENSES,
          queryParameters: {
            "employee": hubData!.userData!.employeeId,
            "type_expense": "Expense",
            "status": status
          });
      expensesModel = ExpensesModel.fromJson(response.data);
      emit(GetExpensesSuccessState());
    } catch (e) {
      emit(GetExpensesErrorState());
    }
  }

  getExpensesTypes() async {
    try {
      emit(GetExpensesTypesLoadingState());
      Response response =
          await DioHelper.getData(url: EndPoints.GET_EXPENSES_TYPE);
      advanceTypesModel = AdvanceTypesModel.fromJson(response.data);
      emit(GetExpensesTypesSuccessState());
    } catch (e) {
      emit(GetExpensesTypesErrorState());
    }
  }

  changeSelection(value) {
    expenseSelected = value;
    emit(ChangeSelectionState());
  }

  String? attachFile;
  getAttachFile() async {
    emit(GetAttachFileLoadingState());
    try {
      final response = await getAttachUrl();
      if (response != null) {
        attachFile = response;
        emit(GetAttachFileSuccessState());
        showToast("Done");
      } else {
        showToast("field to get attach file");
        emit(GetAttachFileErrorState());
      }
    } catch (e) {
      emit(GetAttachFileErrorState());
      showToast("field to get attach file");
    }
  }

  addNewExpense(context) async {
    try {
      emit(AddNewExpenseLoadingState());
      ExpensesData data = ExpensesData(
          status: "Draft",
          expenseType: "Expense",
          advanceAmount: double.parse(amount.text.trim()),
          activityName: expenseName.text.trim(),
          lead: client.text.trim(),
          purpose: comment.text.trim(),
          employee: hubData!.userData!.employeeId,
          exchangeRate: 1.0,
          postingDate: DateTimeFormating.sendFormatDate(DateTime.now()),
          typeExpense:
              expenseSelected ?? advanceTypesModel?.message[0].name.toString(),
          attachFiles: attachFile);
      Response response = await DioHelper.postData(
          url: EndPoints.ADD_NEW_EXPENSES, query: data.toJson());
      if (response.data['message'].toString().trim() == "Activity created") {
        changeScreenType("All");
      } else {
        emit(AddNewExpenseErrorState());
      }
      Navigator.pop(context);
      if (response.data['message'] == "failed to create new activity") {
        showToast(response.data['message'].toString());
      } else {
        showToast(response.data['message'].toString(), color: approvedColor);
        sendNotificationAction();
      }
    } catch (e) {
      emit(AddNewExpenseErrorState());
    }
  }

  sendNotificationAction() {
    final data = NotificationModel(
        notification: NotificationHeader(body: "Need a new expense"),
        data: Data(type: "Expense", screenCode: "000"));
    sendNotification(data: data);
  }
}
