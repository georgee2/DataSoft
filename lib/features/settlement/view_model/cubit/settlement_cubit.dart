import 'package:data_soft/app.dart';
import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/features/notifications/view_model/notification_helper.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/features/settlement/model/settlement_type.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networks/attach_file.dart';
import '../../../notifications/model/notification_model.dart';
import '../../model/settlement_model.dart';
part 'settlement_state.dart';

class SettlementCubit extends Cubit<SettlementStates> {
  SettlementCubit() : super(SettlementInitialState());
  static SettlementCubit get(BuildContext context) => BlocProvider.of(context);

  SettlementModel? settlementModel;
  SettlementTypeModel? settlementTypeModel;
  String screenType = "All";

  String settlementType = "Expense";
  String settlementFor = "Choose settlement...";

  String? taskName;
  String? employeeAdvance;
  TextEditingController amount = TextEditingController();
  TextEditingController comment = TextEditingController();

  changeScreenType(type) {
    screenType = type;
    switch (type.trim()) {
      case "Approved":
        getSettlement(status: "paid");
        break;
      case "Rejected":
        getSettlement(status: "Cancelled");
        break;
      case "Pending":
        getSettlement(status: "Draft");
        break;
      default:
        getSettlement();
    }
    emit(ChangeScreenTypeState());
  }
  getSettlement({status}) async {
    try {
      emit(GetSettlementLoadingState());
      Map<String, dynamic> data = {
        "employee": hubData!.userData!.employeeId,
        "status": status
      };
      Response response = await DioHelper.getData(
          url: EndPoints.GET_SETTLEMENT, queryParameters: data);
      settlementModel = SettlementModel.fromJson(response.data);
      if (settlementModel!.message!.success == true) {
        emit(GetSettlementSuccessState());
      } else {
        emit(GetSettlementErrorState());
      }
    } catch (e) {
      emit(GetSettlementErrorState());
    }
  }


  changeTypeSelection(value) {
    settlementType = value;
    settlementFor = "Choose settlement...";
    taskName = null;
    getSettlementsFor();
    emit(ChangeSettlementTypeState());
  }

  getSettlementsFor() async {
    try {
      emit(GetSettlementForLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_SETTLEMENT_FOR,
          queryParameters: {
            "employee": hubData?.userData?.employeeId,
            "type_expense": settlementType,
          });
      settlementTypeModel = SettlementTypeModel.fromJson(response.data);
      emit(GetSettlementForSuccessState());
    } catch (e) {
      emit(GetSettlementForErrorState());
    }
  }

  changeSettlementFor(SettlementType value) {
    settlementFor = value.expenseType!;
    employeeAdvance = value.name!;
    taskName = value.taskName;
    amount.text = value.unClaimedAmount.toString();
    emit(ChangeSettlementForState());
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

  addNewSettlement() async {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
    try {
      emit(AddSettlementLoadingState());
      Map<String, dynamic> data = {
        "employee": hubData!.userData!.employeeId,
        "posting_date": DateTime.now().toString(),
        "expense_approver": hubData?.userData?.expenseApprover,
        "payable_account": "Creditors - Onco",
        "expense_type": settlementFor,
        "comment": comment.text.trim(),
        "mode_of_payment": null,
        "type_expense": settlementType,
        "amount": double.parse(amount.text.trim()),
        "sanctioned_amount": double.parse(amount.text.trim()),
        "attach_files": attachFile,
        "task_name": taskName,
        "expense_date": DateTime.now().toString(),
        "employee_advance": employeeAdvance,
      };
      Response response = await DioHelper.postData(
          url: EndPoints.ADD_NEW_SETTLEMENT, query: data);
      if (response.data['message']['success'] == true) {
        showToast("Added", color: approvedColor);
        sendNotificationAction();
        emit(AddSettlementSuccessState());
        Navigator.pop(navigatorKey.currentContext!);
        Navigator.pop(navigatorKey.currentContext!);
        screenType = "All";
        getSettlement();
      } else {
        Navigator.pop(navigatorKey.currentContext!);
        showToast(response.data['message']['message']);
        emit(AddSettlementErrorState());
      }
    } catch (e) {
      Navigator.pop(navigatorKey.currentContext!);
      showToast(e);
      emit(AddSettlementErrorState());
    }
  }

  sendNotificationAction() {
    final data = NotificationModel(
        notification: NotificationHeader(body: "Need a new settlement"),
        data: Data(type: "Settlement", screenCode: "000"));
    sendNotification(data: data);
  }
}
