import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../notifications/view_model/notification_helper.dart';
import '../../../notifications/model/notification_model.dart';
import '../../../registration/model/registration_model.dart';
import '../../model/reps_model.dart';
import '../../model/request_details_model.dart';
part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(RequestsInitial());
  static RequestsCubit get(BuildContext context) => BlocProvider.of(context);
  String screenType = "Pending";
  List<RequestsDetailsModel> requestsData = [];
  List<RepsModel> repsData = [];
  List<RequestsDetailsModel> visitsItem = [];
  List<RequestsDetailsModel> visitsItemSelected = [];
  List plansData = [];
  bool isEmpty = false;
  bool isSelectAll = false;
  bool selectionMode = false;
  String? expenseType;
  String? fullDate;
  dynamic start, end, year;
  changeStatus(docTypeName, val, String? expenseType) {
    screenType = val;
    this.expenseType = expenseType;
    emit(ChangeScreenStatusState());
    switch (docTypeName) {
      case "Employee Advance":
        if (val == "Rejected") {
          getAllRequests(
              docType: docTypeName,
              expenseType: expenseType,
              status: "Cancelled");
        } else if (val == "Approved") {
          getAllRequests(
              docType: docTypeName, expenseType: expenseType, status: 'Paid');
        } else {
          getAllRequests(
              docType: docTypeName, expenseType: expenseType, status: 'Draft');
        }
        break;
      case "Permission":
        if (val == "Rejected") {
          getAllRequests(
              docType: docTypeName,
              expenseType: expenseType,
              status: "Cancelled");
        } else if (val == "Approved") {
          getAllRequests(
              docType: docTypeName,
              expenseType: expenseType,
              status: 'Submitted');
        } else {
          getAllRequests(
              docType: docTypeName, expenseType: expenseType, status: 'Draft');
        }
        break;
      case "ToDo":
        if (val == "Rejected") {
          getAllRequests(
              docType: docTypeName,
              expenseType: expenseType,
              status: "Cancelled");
        } else if (val == "Approved") {
          getAllRequests(
              docType: docTypeName, expenseType: expenseType, status: 'Closed');
        } else {
          getAllRequests(
              docType: docTypeName, expenseType: expenseType, status: '');
        }
        break;
      case "Leave Application":
        if (val == "Rejected") {
          getAllRequests(
              docType: docTypeName,
              expenseType: expenseType,
              status: "Rejected");
        } else if (val == "Approved") {
          getAllRequests(
              docType: docTypeName,
              expenseType: expenseType,
              status: 'Approved');
        } else {
          getAllRequests(
              docType: docTypeName, expenseType: expenseType, status: 'Open');
        }
        break;
      case "Expense Claim":
        if (val == "Rejected") {
          getAllRequests(
              docType: docTypeName,
              expenseType: expenseType,
              status: "Cancelled",
              approvalStatus: "Rejected");
        } else if (val == "Approved") {
          getAllRequests(
              docType: docTypeName,
              expenseType: expenseType,
              status: 'Submitted',
              approvalStatus: "Approved");
        } else {
          getAllRequests(
              docType: docTypeName,
              expenseType: expenseType,
              status: 'Draft',
              approvalStatus: "Draft");
        }
        break;
      case "Opportunity":
        if (val == "Rejected") {
          getAllRequests(docType: docTypeName, statusPlan: "Rejected");
        } else if (val == "Approved") {
          getAllRequests(docType: docTypeName, statusPlan: "Approved");
        } else {
          getAllRequests(docType: docTypeName, statusPlan: "In Review");
        }
        break;
      default:
        break;
    }
  }

  String requestName(val, expenseType) {
    switch (val) {
      case "Employee Advance":
        if (expenseType == "Expense") {
          expenseType = "Expense";
          return "Expenses";
        } else {
          expenseType = "Activity";
          return "Activities";
        }
      case "Permission":
        return "Permission";
      case "ToDo":
        return "Tasks";
      case "Opportunity":
        return "Visits";
      case "Leave Application":
        return "Vacations";
      case "Expense Claim":
        return "Settlement";
      default:
        return val;
    }
  }

  getAllRequests(
      {required String docType,
      String? expenseType,
      status,
      approvalStatus,
      statusPlan,
      fromDate,
      toDate}) async {
    try {
      requestsData = [];
      plansData = [];
      repsData = [];
      visitsItem = [];
      visitsItemSelected = [];
      isEmpty = false;
      emit(GetAllRequestsLoadingState());
      Map<String, dynamic> data = {
        "user": hubData!.userData!.email,
        "doc_doctype": docType,
        "type_expense": expenseType,
        "status": status,
        "approval_status": approvalStatus,
        "status_plan": statusPlan,
        "from_date":
            start == null ? null : DateTimeFormating.sendFormatDate(start),
        "to_date": end == null ? null : DateTimeFormating.sendFormatDate(end),
      };
      Response response = await DioHelper.getData(
          url: EndPoints.GET_REQUESTS_DETAILS, queryParameters: data);
      setResponseData(docType, response.data);
      emit(GetAllRequestsSuccessState());
    } catch (e) {
      emit(GetAllRequestsErrorState());
    }
  }

  setResponseData(docType, data) {
    switch (docType) {
      case "Employee Advance":
        data['message'].forEach((element) {
          requestsData.add(RequestsDetailsModel(
            employeeId: element['employee'],
            requestId: element['name'],
            repName: element['employee_name'],
            postingDate: DateTimeFormating.formatCustomDate(
                date: element['posting_date'], formatType: "dd MMM yyyy"),
            type: element['expense_type'],
            amount: element['advance_amount'].toString(),
            clientName: null,
            comment: element['purpose'],
          ));
        });
        break;
      case "Permission":
        data['message'].forEach((element) {
          final from = DateFormat('h:mm a').format(
              DateFormat('yyyy-mmmm-dd HH:mm')
                  .parse(element['from_time'] ?? "2023-09-20 11:00:24"));
          final to = DateFormat('h:mm a').format(
              DateFormat('yyyy-mmmm-dd HH:mm')
                  .parse(element['to_time'] ?? "2023-09-20 11:00:24"));

          requestsData.add(RequestsDetailsModel(
              employeeId: element['employee'],
              requestId: element['name'],
              repName: element['employee_name'],
              postingDate: "$from-$to",
              type: element['permission_type'],
              comment: element['reason'],
              amount: null,
              clientName: null));
        });
        break;
      case "ToDo":
        data['message'].forEach((element) {
          // requestsData.add(RequestsDetailsModel(repName: repName, postingDate: postingDate, type: type, amount: amount, clientName: clientName, comment: comment))
        });
        break;
      case "Opportunity":
        if (data['message'].isEmpty) {
          isEmpty = true;
        }
        data['message'].forEach((element) {
          requestsData.add(RequestsDetailsModel(
              employeeId: element['employee'],
              requestId: element['name'],
              repName: element['opportunity_owner_full_name'],
              postingDate: element['transaction_date'],
              type: "Opportunity",
              amount: null,
              clientName: element['customer_name'],
              statusPlan: element['status_plan'],
              email: element['opportunity_owner'],
              image: element['opportunity_owner_banner_image'] == null
                  ? null
                  : "http://154.38.165.213:1212${element['opportunity_owner_banner_image']}",
              comment: null));
        });

        repsFiltering();
        break;

      case "Leave Application":
        data['message'].forEach((element) {
          requestsData.add(RequestsDetailsModel(
              employeeId: element['employee'],
              requestId: element['name'],
              repName: element['employee_name'],
              postingDate:
                  "${DateTimeFormating.formatCustomDate(date: element['from_date'], formatType: "dd MMM")} - ${DateTimeFormating.formatCustomDate(date: element['to_date'], formatType: "dd MMM")}",
              type: element['leave_type'],
              amount: null,
              clientName: element['customer_name'],
              comment: null));
        });
        break;
      case "Expense Claim":
        data['message'].forEach((element) {
          requestsData.add(RequestsDetailsModel(
              employeeId: element['employee'],
              requestId: element['name'],
              repName: element['employee_name'],
              postingDate: DateTimeFormating.formatCustomDate(
                  date: element['posting_date'], formatType: 'dd MMM yyyy'),
              type: element['expenses'][0]['expense_type'],
              amount: element['expenses'][0]['amount'].toString(),
              clientName: null,
              comment: element['comment']));
        });
        break;
      default:
        break;
    }
  }

  repsFiltering() {
    for (var i = 0; i < requestsData.length; i++) {
      if (repsData.isEmpty) {
        repsData.add(RepsModel(
            email: requestsData[i].email,
            name: requestsData[i].repName,
            image: requestsData[i].image,
            data: [requestsData[i]]));
      } else {
        for (var b = 0; b < repsData.length; b++) {
          if (repsData[b].email == requestsData[i].email) {
            repsData[b].data.add(requestsData[i]);
            break;
          } else if (b == repsData.length - 1) {
            repsData.add(RepsModel(
                email: requestsData[i].email,
                name: requestsData[i].repName,
                image: requestsData[i].image,
                data: [requestsData[i]]));
          }
        }
      }
    }
  }

  changeDate(context, statusPlan) {
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
                      start = args.value.startDate;
                      end = args.value.endDate;
                      year = DateTimeFormating.formatYearDate(
                          args.value.endDate ?? args.value.startDate);
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
                              "${DateTimeFormating.formatMonthDate(start)} - ${DateTimeFormating.formatMonthDate(end)} ,${DateTimeFormating.formatYearDate(end ?? start)}";
                          getAllRequests(
                            docType: "Opportunity",
                            statusPlan: statusPlan,
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                    TextButton(
                      child: const Text("CANCEL"),
                      onPressed: () {
                        Navigator.pop(context);
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

  plansFiltering(List<RequestsDetailsModel> data) {
    try {
      plansData = [];
      plansData.clear();
      for (var a = 0; a < data.length; a++) {
        if (data[a].postingDate == null) {
          data[a].postingDate = "2000-08-16";
        }
        if (plansData.isEmpty) {
          plansData.add({
            "status_plan": data[a].statusPlan,
            "transaction_date": data[a].postingDate,
            "data": <RequestsDetailsModel>[data[a]],
          });
          emit(FilterAddNewplanStates());
        } else {
          for (var b = 0; b < plansData.length; b++) {
            if (plansData[b]['transaction_date'] == data[a].postingDate) {
              for (var i = 0; i < plansData[b]['data'].length; i++) {
                if (plansData[b]['data'][i].requestId == data[a].requestId) {
                  break;
                } else if (i == plansData[b]['data'].length - 1) {
                  plansData[b]['data'].add(data[a]);
                }
              }
              if (data[a].statusPlan != plansData[b]['status_plan']) {
                plansData[b]['status_plan'] = "Partially Approved";
              }
              emit(FilterAddToPlanStates());
              break;
            } else if (b == plansData.length - 1) {
              plansData.add({
                "status_plan": data[a].statusPlan,
                "transaction_date": data[a].postingDate,
                "data": <RequestsDetailsModel>[data[a]],
              });
              emit(FilterAddNewplanStates());
            }
          }
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  initVisitsData(data) {
    visitsItem = [];
    visitsItem.addAll(data);
    emit(InitVisitsDataState());
  }

  changeSelectionItems() {
    isSelectAll = !isSelectAll;
    for (var i = 0; i < visitsItem.length; i++) {
      visitsItem[i].isSelected = isSelectAll;
    }
    if (!isSelectAll) {
      selectionMode = false;
      visitsItemSelected = [];
    } else {
      selectionMode = true;
      visitsItemSelected.addAll(visitsItem);
    }
    emit(ChangeSelectionState());
  }

  singleItemSelection(index, bool value) {
    if (value) {
      selectionMode = true;
      visitsItemSelected.add(visitsItem[index]);
      visitsItem[index].isSelected = true;
    } else {
      visitsItemSelected.remove(visitsItem[index]);
      visitsItem[index].isSelected = false;
      for (var i = 0; i < visitsItem.length; i++) {
        if (visitsItem[i].isSelected) {
          break;
        } else if (!visitsItem[i].isSelected && i == visitsItem.length - 1) {
          selectionMode = false;
        }
      }
    }
    emit(SingleItemSelectionState());
  }

  updateAllItems(repIndex, context, bool actionState, index) {
    for (var i = 0; i < visitsItemSelected.length; i++) {
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      updateRequests(context,
          docTypeName: "Opportunity",
          requestsDetailsModel: visitsItemSelected[i],
          status: actionState,
          repIndex: repIndex,
          index: index);
      if (i == visitsItemSelected.length - 1) {
        isSelectAll = false;
        emit(ChangeSelectionState());
      }
    }
  }

  updateRequests(context,
      {required String docTypeName,
      required RequestsDetailsModel requestsDetailsModel,
      int? index,
      int? repIndex,
      required bool status}) async {
    try {
      selectionMode = false;
      emit(UpdateRequestsLoadingState());
      if (docTypeName == "Opportunity") {
        Map<String, dynamic> data = {
          "doc_name": requestsDetailsModel.requestId,
          "status": "Open",
          "status_plan": status ? "Approved" : "Rejected"
        };
        await DioHelper.putData(url: EndPoints.UPDATE_VISITS, query: data);
        sendNotificationAction(
            requestsDetailsModel.employeeId,
            status
                ? "The visit you created has been approved"
                : "The visit you created has been Rejected",
            docTypeName);
        visitsItem.remove(requestsDetailsModel);
        removeVisitItem(repIndex, index, requestsDetailsModel);
      } else {
        Map<String, dynamic> data = {
          "doc_doctype": docTypeName,
          "doc_name": requestsDetailsModel.requestId,
          "status": getRequestStatus(status, docTypeName)['status'], // paid
          "docstatus": status ? 1 : 2,
          "approval_status":
              getRequestStatus(status, docTypeName)['approval_status'],
        };
        if (docTypeName == "Expense Claim" && status) {
          data["is_paid"] = 1;
          await DioHelper.putData(
              url: EndPoints.UPDATE_STTELEMNT_REQUEST, query: data);
        } else {
          await DioHelper.putData(url: EndPoints.UPDATE_REQUESTS, query: data);
        }
        sendNotificationAction(
            requestsDetailsModel.employeeId,
            status
                ? "The ${requestName(docTypeName, expenseType)} you created has been approved"
                : "The ${requestName(docTypeName, expenseType)} you created has been Rejected",
            "$docTypeName${expenseType ?? ""}");
      }
      showSnackBar(context,
          text: "Updated successfully with status", color: approvedColor);
      requestsData.remove(requestsDetailsModel);
      Navigator.pop(context);
      emit(UpdateRequestsSuccessState());
    } catch (e) {
      emit(UpdateRequestsErrorState());
    }
  }

  removeVisitItem(repIndex, index, RequestsDetailsModel requestsDetailsModel) {
    try {
      final List item = plansData[index]['data'];
      if (item.isEmpty) {
        plansData.removeAt(index);
        if (plansData.isEmpty) {
          repsData.removeAt(repIndex);
        }
      } else {
        plansData[index]['data'].remove(requestsDetailsModel);
        if (item.isEmpty) {
          plansData.removeAt(index);
          if (plansData.isEmpty) {
            repsData.removeAt(repIndex);
          }
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  getRequestStatus(bool status, docTypeName) {
    if (status) {
      switch (docTypeName) {
        case "Employee Advance":
          return {"status": "Unpaid", "approval_status": null};
        case "Permission":
          return {"status": "Submitted", "approval_status": null};
        case "ToDo":
          return {"status": "Closed", "approval_status": null};
        case "Leave Application":
          return {"status": "Approved", "approval_status": null};
        case "Expense Claim":
          return {"status": "Paid", "approval_status": "Approved"};
      }
    } else {
      switch (docTypeName) {
        case "Employee Advance" || "ToDo" || "Permission":
          return {"status": "Cancelled", "approval_status": null};
        case "Leave Application":
          return {"status": "Rejected", "approval_status": null};
        case "Expense Claim":
          return {"status": "Cancelled", "approval_status": "Rejected"};
      }
    }
  }

  sendNotificationAction(id, status, type) {
    final data = NotificationModel(
        to: id,
        notification: NotificationHeader(body: status),
        data: Data(type: type, screenCode: "000"));
    sendNotification(data: data);
  }
}
