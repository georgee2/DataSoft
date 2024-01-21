import 'package:data_soft/core/app_switches.dart';
import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/features/vacation/models/vacation_model.dart';
import 'package:data_soft/features/vacation/models/vacations_types.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/app_datetime.dart';
import '../../../../core/app_dialogs.dart';
import '../../../../core/external_sharing.dart';
import '../../../../core/networks/attach_file.dart';
import '../../../notifications/view_model/notification_helper.dart';
import '../../../notifications/model/notification_model.dart';
part 'vacation_state.dart';

String? start;
String? end;

class VacationCubit extends Cubit<VacationStates> {
  VacationCubit() : super(VacationInitial());
  static VacationCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  VacationModel? vacationModel;
  VacationsTypeModel? vacationsTypeModel;
  String? vacationTypeSelected;
  String? addVacationTypeSelected;
  String viewType = "All";
  String fullDate = DateFormat('dd MMMM').format(DateTime.now()) +
      DateFormat(' ,yyyy').format(DateTime.now());
  String? year;
  String vacationDays = '0';
  String? balance;
  String? totalBalance;
  TextEditingController commentController = TextEditingController();

  changeViewType(type) {
    viewType = type;
    emit(ChangeViewTypeState());
    switch (type.trim()) {
      case "All":
        getVacation();
        break;
      case "Approved":
        getVacation(status: "Approved");
        break;
      case "Rejected":
        getVacation(status: "Rejected");
        break;
      case "Pending":
        getVacation(status: "Open");
        break;
    }
  }

  getVacation({status, totalVacationDays}) async {
    vacationModel = null;
    emit(GetVacationLoadingState());
    try {
      Response response = await DioHelper.getData(
          url: EndPoints.GET_VACATIONS,
          queryParameters: {
            "employee": hubData!.userData!.employeeId,
            "status": status,
            "leave_type": vacationTypeSelected
          });
      vacationModel = VacationModel.fromJson(
          response.data, balance == null ? null : double.tryParse(balance!));
      if (status == null) {
        totalBalance = vacationModel?.totalVacationDays?.toInt().toString();
      }
      emit(GetVacationSuccessState());
    } catch (e) {
      emit(GetVacationErrorState());
    }
  }

  getVacationsTypes() async {
    try {
      emit(GetVacationsTypesLoadingState());
      Response response =
          await DioHelper.getData(url: EndPoints.GET_VACATIONS_TYPES);
      vacationsTypeModel = VacationsTypeModel.fromJson(response.data);
      emit(GetVacationsTypesSuccessState());
      if (vacationsTypeModel!.message.isNotEmpty) {
        getBalance(vacationsTypeModel!.message[0].name);
      } else {
        showToast("Error");
      }
    } catch (e) {
      emit(GetVacationsTypesErrorState());
    }
  }

  getBalance(type) async {
    try {
      viewType = "All";
      vacationTypeSelected = type;
      addVacationTypeSelected = type;
      balance = null;
      vacationModel = null;
      emit(GetBalanceLoadingState());
      Map<String, dynamic> data = {
        "employee": hubData?.userData?.employeeId,
        "leave_type": vacationTypeSelected,
      };
      Response response = await DioHelper.getData(
          url: EndPoints.GET_VACATIONS_BALANCE, queryParameters: data);
      if (response.data['message'] != null &&
          response.data['message'].isNotEmpty) {
        balance = response.data['message'][0]['total_leaves_allocated']
            .toInt()
            .toString();
        emit(GetBalanceSuccessState());
      } else {
        balance = "0";
        emit(GetBalanceErrorState());
      }
      getVacation(
          totalVacationDays:
              response.data['message'][0]['total_leaves_allocated'] ?? 0);
    } catch (e) {
      getVacation(totalVacationDays: 0);
      emit(GetBalanceErrorState());
    }
  }

  vacationDetails(context, index) {
    dialogFrameSingleButton(
        context: context,
        buttonColor: colorStatus(vacationModel!.message[index].status)['color'],
        onTap: () {
          Navigator.pop(context);
        },
        title: "vacationDetails".i18n(),
        buttonTitle: 'close'.i18n(),
        colors: colorStatus(vacationModel!.message[index].status)['colors'],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: colorStatus(
                      vacationModel!.message[index].status)['color'],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    vacationModel!.message[index].status == "Open"
                        ? "Pending"
                        : vacationModel!.message[index].status,
                    style: TextStyle(
                        fontSize: 18,
                        color: colorStatus(
                            vacationModel!.message[index].status)['color']),
                  ),
                )),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.edit_calendar_outlined),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "vacationType".i18n(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  vacationModel!.message[index].leaveType,
                  style:
                      const TextStyle(fontSize: 16, color: Color(0xffA8ACAF)),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "date".i18n(),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                        height: 40,
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            border: Border.all(color: Colors.grey, width: 0.5)),
                        child: Row(children: [
                          imageSvg(src: 'calendar_event', size: 24),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      "${DateTimeFormating.formatMonthDate(vacationModel!.message[index].fromDate)} - ${DateTimeFormating.formatMonthDate(vacationModel!.message[index].toDate)}${DateTimeFormating.formatYearDate(vacationModel!.message[index].fromDate)}")))
                        ]))),
                const SizedBox(width: 5),
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  child: Text(
                      "${vacationModel!.message[index].totalLeaveDays} DAYS"),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CustCommentTextField(
              onTap: () {
                openAttachFile(vacationModel!.message[index].attachFile);
              },
              showAttachFile: vacationModel!.message[index].attachFile != null,
              isClickable: false,
              controller: TextEditingController(
                  text: vacationModel!.message[index].description),
            )
          ],
        ));
  }

  chooseDate(context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 370,
            width: 350,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SfDateRangePicker(
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      start = args.value.startDate.toString();
                      end = (args.value.endDate ?? args.value.startDate)
                          .toString();
                      year = DateTimeFormating.formatYearDate(
                          args.value.endDate ?? args.value.startDate);
                      if (args.value.endDate != null &&
                          args.value.startDate != null) {
                        vacationDays = DateTimeFormating.daysBetween(
                                args.value.startDate, args.value.endDate)
                            .toString();
                      } else if (start == end) {
                        vacationDays = '1';
                      } else {
                        vacationDays = '0';
                      }
                      emit(ChangePickerDateTimeState());
                    },
                    selectionMode: DateRangePickerSelectionMode.extendableRange,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        if (start != null && end != null && year != null) {
                          fullDate =
                              "${DateTimeFormating.formatMonthDate(start)} - ${DateTimeFormating.formatMonthDate(end)}$year";
                          emit(SubmitDateTimeState());
                          Navigator.pop(context);
                        }
                      },
                    ),
                    TextButton(
                      child: const Text("CANCEL"),
                      onPressed: () {
                        if (start == null && end == null && year == null) {
                          vacationDays = "0";
                          emit(CloseDateTimeState());
                          Navigator.pop(context);
                        } else {
                          emit(CloseDateTimeState());
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  changeAddNewVacationType(value) {
    addVacationTypeSelected = value;
    emit(ChangeAddNewVacationState());
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

  postNewVacation(context) async {
    emit(AddNewVacationLoadingState());
    Message data = Message(
        employee: hubData!.userData!.employeeId!,
        employeeName: userData!.fullName!,
        leaveType: addVacationTypeSelected ??
            vacationsTypeModel!.message[0].name.toString(),
        fromDate: DateTimeFormating.sendFormatDate(start),
        toDate: DateTimeFormating.sendFormatDate(end ?? start),
        status: "Open",
        description: commentController.text.trim(),
        leaveApprover: hubData!.userData?.leaveApprover,
        totalLeaveDays: vacationDays,
        attachFile: attachFile,
        postingDate: DateTimeFormating.sendFormatDate(DateTime.now()));

    if (double.parse(vacationDays) <= vacationModel!.totalVacationDays!) {
      try {
        await DioHelper.postData(
            url: EndPoints.ADD_NEW_VACATION, query: data.toJson());

        Navigator.pop(context);
        sendNotificationAction();
        showToast("Vacation Created", color: approvedColor);
        getBalance(vacationTypeSelected);
        emit(AddNewVacationLSuccessState());
      } catch (e) {
        emit(AddNewVacationErrorState());
      }
    } else {
      showToast("Outside the scope of vacations");
    }
  }

  sendNotificationAction() {
    final data = NotificationModel(
        notification: NotificationHeader(body: "Need a new vacation"),
        data: Data(type: "Vacation", screenCode: "000"));
    sendNotification(data: data);
  }
}
