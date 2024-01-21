import 'dart:async';
import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/clients/model/client_details_model.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/features/visits/widgets/visit_widgets.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../app.dart';
import '../../../../core/app_dialogs.dart';
import '../../../../core/app_fonts.dart';
import '../../../../core/app_validations.dart';
import '../../../../core/local/cache_helper.dart';
import '../../../../core/networks/attach_file.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../planning/model/plannin_clms_model.dart';
import '../../../today_plan/model/today_plan_model.dart';
import '../../model/clm_model.dart';
import '../../model/clm_pages_model.dart';
import '../../model/old_feedback.dart';
import '../../model/visit_count_model.dart';
import '../../model/visit_questions.dart';
part 'visits_state.dart';

class VisitsCubit extends Cubit<VisitsStates> {
  VisitsCubit() : super(VisitsInitialState());
  static VisitsCubit get(BuildContext context) => BlocProvider.of(context);

  ClmModel? clmModel;
  ClmPagesModel? clmPagesModel;
  ClmPageData? pageView;
  OldFeedbackModel? oldFeedback;
  VisitCountModel? visitCountModel;
  PlanningClms? planningClms;
  VisitQuestions? visitQuestions;
  ClientDetailsModel? clientDetailsModel;
  DoctorData? doctorData2;
  List clmsSelected = [];
  bool isClmplan = false;
  Duration duration = const Duration();
  Timer? timer;
  TextEditingController postPoneComment = TextEditingController();
  TextEditingController feedbackComment = TextEditingController();
  String postPoneDateTime = "Chose date....";

  // Visit State
  String timerString = "00:00:00";
  String visitState = "General";
  bool isDownNow = false;
  int seconds = 0;
  
  // details icon more more info(Doctor details, Feedback)
  onCancel() {
    isDownNow = false;
    emit(OnCancelState());
  }

  // details icon more more info(Doctor details, Feedback)
  onOpen() {
    isDownNow = true;
    emit(OnOpenState());
  }

  changeVisitStatus({required String visitId, required String status}) async {
    Map<String, dynamic> data = {
      "doc_name": visitId,
      "status": status,
      "status_plan": "Approved"
    };
    try {
      await DioHelper.putData(url: EndPoints.UPDATE_VISIT_STATUS, query: data);
      doctorData2?.status = status;
      // ignore: empty_catches
    } catch (e) {}
  }

  getClientDetails(name) async {
    try {
      emit(GetDoctorDetailsLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_CLIENT_DETAILS,
          queryParameters: {"lead_name": name});
      if (response.data['message'][0] != null) {
        clientDetailsModel = ClientDetailsModel.fromJson(response.data);
        emit(GetDoctorDetailsSuccessState());
      } else {
        emit(GetDoctorDetailsErrorState());
      }
    } catch (e) {
      emit(GetDoctorDetailsErrorState());
    }
  }

  navigateFromLocal(VisitCountModel? visitCountModel2, DoctorData doctorData,
      {fromLocal}) async {
    doctorData2 = doctorData;
    if (fromLocal) {
      timer = Timer.periodic(duration, (timer) {});
      visitCountModel = visitCountModel2;
      if (visitCountModel != null) {
        if (visitCountModel!.isClm!) {
          doctorData.visitId = visitCountModel?.opportunityName;
          doctorData.partyName = visitCountModel?.doctorID;
          doctorData2?.images = doctorData2?.images ?? visitCountModel?.image;
          getCLMItems(doctorData);
        } else {
          startVisitState("NormalVisit", visitData: doctorData, isClm: false);
        }
      }
    }
  }

  visitValidation(
      {required DoctorData doctorData, context, required bool fromClm}) async {
    try {
      Map<Permission, PermissionStatus> status = await [
        Permission.location,
        Permission.locationWhenInUse,
        Permission.locationAlways,
      ].request();
      if (status[Permission.locationWhenInUse] == PermissionStatus.granted) {
        await Geolocator.checkPermission().then((value) async {
          if (value.name != "deniedForever" && value.name != "denied") {
            try {
              await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.best)
                  .then((value) async {
                if (clientDetailsModel?.lat == null &&
                    clientDetailsModel?.lng == null) {
                  clientDetailsModel?.lat = value.latitude;
                  clientDetailsModel?.lng = value.longitude;
                  clientDetailsModel?.location =
                      'https://www.google.com/maps/search/?api=1&query=${value.latitude},${value.longitude}';
                  updateLocation(clientDetailsModel?.name, value.latitude,
                      value.longitude);
                } else {
                  final locationValidation = AppValidations.calculateDistance(
                      value.latitude,
                      value.longitude,
                      clientDetailsModel?.lat,
                      clientDetailsModel?.lng);
                  if (locationValidation <= hubData!.allowedDistance!) {
                    if (fromClm) {
                      getCLMItems(doctorData);
                    } else {
                      startVisitState("NormalVisit",
                          visitData: doctorData, isClm: false);
                    }
                  } else {
                    showSnackBar(context,
                        text: "You are outside the permitted range");
                  }
                }
              });
              // ignore: empty_catches
            } catch (e) {}
          } else {
            locationDialog(context);
          }
        });
      } else {
        locationDialog(context);
      }
    } catch (e) {
      showSnackBar(context, text: "An error occurred");
    }
  }

  updateLocation(clientId, lat, long) async {
    try {
      emit(UpdateLocationLoadingState());
      final location = {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "properties": {},
            "geometry": {
              "type": "Point",
              "coordinates": [lat, long]
            }
          }
        ]
      };
      Map<String, dynamic> data = {
        "doc_name": clientId,
        "lead_owner": hubData!.userData!.email,
        "location": location,
      };
      Response response =
          await DioHelper.putData(url: EndPoints.UPDATE_LOCATION, query: data);
      showToast(response.data['message']['message'],
          color: response.data['message']['message'] ==
                  "Location updated successfully"
              ? approvedColor
              : rejectedColor);
      emit(UpdateLocationSuccessState());
    } catch (e) {
      emit(UpdateLocationErrorState());
    }
  }

  startVisitState(state, {DoctorData? visitData, bool? isClm}) async {
    if (visitData != null) {
      getQuestions(
          linkId: visitData.linkQuestions ?? visitCountModel?.linkQuestions);
      changeVisitStatus(
          visitId: visitData.visitId ?? visitCountModel!.opportunityName!,
          status: "Converted");
      if (visitCountModel?.opportunityName.toString() != visitData.visitId) {
        visitCountModel = VisitCountModel(
            opportunityName: visitData.visitId,
            countFrom: visitCountModel?.countFrom ?? DateTime.now().toString(),
            doctorName: visitData.customerName,
            medicalSpecialty: visitData.medicalSpecialty,
            image: visitCountModel?.image ?? doctorData2?.images,
            isClm: visitCountModel?.isClm ?? isClm,
            countTo: null,
            doctorID: visitData.partyName,
            clmData: visitCountModel?.clmData ?? []);
        await CacheHelper.setData("VisitData", visitCountModel?.toJson());
      }
      startTimer();
    }
    visitState = state;
    emit(StartVisitState());
  }

  startTimer() async {
    VisitCountModel? visitCountModel = VisitCountModel.fromJson(
        await CacheHelper.getData("VisitData", Map) ?? {});
    if (visitCountModel.countFrom != null) {
      final count = DateTime.parse(DateTime.now().toString())
          .difference(DateTime.parse(visitCountModel.countFrom!))
          .inSeconds;
      duration = Duration(seconds: count);
      timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    }
  }

  addTime() {
    seconds = duration.inSeconds + 1;
    duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secondsString = twoDigits(duration.inSeconds.remainder(60));
    timerString = "$hours:$minutes:$secondsString";
    emit(CountingTimerState());
  }

  Future<void> stopTimer() async {
    timer?.cancel();
    visitCountModel?.countTo = DateTime.now().toString();
    emit(StopedTimerState());
  }

  openClm(clmName) async {
    visitCountModel!.clmData?.add({
      "clm_name": clmName,
      "clm_count_from": DateTime.now().toString(),
      "clm_count_to": null,
    });
    await CacheHelper.setData("VisitData", visitCountModel?.toJson());
  }

  closeClm(clmName) {
    visitCountModel?.clmData?.forEach((element) async {
      if (element['clm_name'] == clmName) {
        element["clm_count_to"] = DateTime.now().toString();
        await CacheHelper.setData("VisitData", visitCountModel?.toJson());
      }
    });
  }

  getCLMItems(DoctorData doctorData) async {
    try {
      emit(GetCLMItemsLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_PRODUCT_BUNDLES_WITH_CLM,
          queryParameters: {"opportunity_name": doctorData.visitId});
      clmModel = ClmModel.fromJson(response.data);
      if (clmModel?.message?.success == true) {
        emit(GetCLMItemsSuccessState());
        startVisitState("StartingCLM", visitData: doctorData, isClm: true);
      } else {
        showToast('include clm is not active for this opportunity.');
        emit(GetCLMItemsErrorState());
      }
    } catch (e) {
      emit(GetCLMItemsErrorState());
    }
  }

  getCLMPages(id) async {
    try {
      emit(GetCLMPagesLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.PRODUCT_BUNDLE_NAME,
          queryParameters: {"product_bundle_name": id});
      clmPagesModel = ClmPagesModel.fromJson(response.data);
      clmPagesModel?.clmName = id;
      if (clmPagesModel?.message?.success == true) {
        emit(GetCLMPagesSuccessState());
        startVisitState("CLMPages");
      } else {
        emit(GetCLMPagesErrorState());
      }
    } catch (e) {
      emit(GetCLMPagesErrorState());
    }
  }

  changePageCount(item) {
    if (item == "Previous Page" &&
        clmPagesModel?.message?.data.indexOf(pageView!) != 0) {
      pageView = clmPagesModel
          ?.message?.data[clmPagesModel!.message!.data.indexOf(pageView!) - 1];
    } else if (item == "Next Page" &&
        clmPagesModel?.message?.data.indexOf(pageView!) !=
            clmPagesModel!.message!.data.length - 1) {
      pageView = clmPagesModel
          ?.message?.data[clmPagesModel!.message!.data.indexOf(pageView!) + 1];
    }
    emit(ChangePageCountState());
  }

  changeDateTime(value) {
    postPoneDateTime = DateTimeFormating.formatCustomDate(
        date: value, formatType: "dd MMMM ,yyyy");
    if (DateTimeFormating.formatCustomDate(
            date: DateTime.now(), formatType: "dd MMMM ,yyyy") ==
        postPoneDateTime) {
      postPoneDateTime = "Chose date....";
    }
    emit(ChangeDateTimeState());
  }

  postPoneVisit(context, id) async {
    Map<String, dynamic> data = {
      "opportunity_name": id,
      "contact_date": DateTimeFormating.sendFormatDate(
          DateFormat("dd MMMM ,yyyy").parse(postPoneDateTime)),
      "to_discuss": postPoneComment.text.trim()
    };
    emit(PostponeLoadingState());
    try {
      Response response =
          await DioHelper.putData(url: EndPoints.POSTPONED_VISIT, query: data);
      if (response.data['message']['success'] == true) {
        showToast("Postponed", color: approvedColor);
        emit(PostponeSuccessState());
        Navigator.pop(context);
      } else {
        showToast(
          "Not Postponed",
        );
        emit(PostponeErrorState());
      }
    } catch (e) {
      showToast(
        "Not Pcvbostponed",
      );
      emit(PostponeErrorState());
    }
  }

  endVisit(context, {clmName}) async {
    await DioHelper.getInit();
    await stopTimer();
    // ignore: await_only_futures
    visitCountModel = await VisitCountModel.fromJson(
        await CacheHelper.getData("VisitData", Map) ??
            visitCountModel?.toJson());
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(child: CupertinoActivityIndicator()),
    );
    emit(EndVisitLoadingState());
    visitCountModel?.countTo ??= DateTime.now().toString();
    if (visitCountModel?.isClm == true &&
        visitCountModel!.clmData!.isNotEmpty) {
      for (var i = 0; i < visitCountModel!.clmData!.length; i++) {
        try {
          if (visitCountModel!.clmData?[i]['clm_count_to'] == null) {
            visitCountModel!.clmData?[i]['clm_count_to'] =
                DateTime.now().toString();
          }
          visitCountModel?.visitStatus = "Closed";
          Map<String, dynamic> data = {
            "opportunity_name": visitCountModel!.opportunityName,
            "count_from": visitCountModel!.countFrom,
            "count_to": visitCountModel!.countTo,
            "clm_name": visitCountModel!.clmData?[i]['clm_name'],
            "clm_count_from": visitCountModel!.clmData?[i]['clm_count_from'],
            "clm_count_to": visitCountModel!.clmData?[i]['clm_count_to'],
          };
          Response response =
              await DioHelper.putData(url: EndPoints.END_VISIT, query: data);
          visitState = "General";

          Navigator.pop(context);
          showToast(response.data['message']['message'].toString(),
              color: approvedColor);
          changeVisitStatus(
              visitId: visitCountModel!.opportunityName ??
                  visitCountModel!.opportunityName!,
              status: "Closed");
          emit(EndVisitSuccessState());
          if (visitQuestions?.message != null &&
              visitQuestions!.message!.questionLogData.isNotEmpty) {
            visitIsDoneDialod(context, visitCountModel!.opportunityName);
          }
          await CacheHelper.removeData("VisitData");
        } catch (e) {
          showToast(e.toString());
          Navigator.pop(context);
          emit(EndVisitErrorState());
        }
      }
    } else {
      try {
        visitCountModel?.visitStatus = "Closed";
        Response response = await DioHelper.putData(
            url: EndPoints.END_VISIT, query: visitCountModel!.toJson());
        duration = const Duration();
        timer = null;
        timerString = "00:00:00";
        visitState = "General";
        emit(EndVisitSuccessState());
        Navigator.pop(context);
        showToast(response.data['message']['message'].toString(),
            color: approvedColor);
        changeVisitStatus(
            visitId: visitCountModel!.opportunityName ??
                visitCountModel!.opportunityName!,
            status: "Closed");
        if (visitQuestions?.message != null &&
            visitQuestions!.message!.questionLogData.isNotEmpty) {
          visitIsDoneDialod(context, visitCountModel!.opportunityName);
        }
        await CacheHelper.removeData("VisitData");
      } catch (e) {
        showToast(e.toString());
        Navigator.pop(context);
        emit(EndVisitErrorState());
      }
    }
  }

  getQuestions({required linkId}) async {
    try {
      emit(GetQuestionsLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_QUESTIONS,
          queryParameters: {"link_questions_name": linkId});
      visitQuestions = VisitQuestions.fromJson(response.data);
      if (visitQuestions?.message?.questionLogData.isNotEmpty == true) {
        emit(GetQuestionsSuccessState());
      } else {
        emit(GetQuestionsErrorState());
      }
    } catch (e) {
      emit(GetQuestionsErrorState());
    }
  }

  updateQuestions(contextt, visitId) async {
    try {
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) =>
              const Center(child: CupertinoActivityIndicator()));
      for (var i = 0;
          i < visitQuestions!.message!.questionLogData.length;
          i++) {
        emit(UpdateQuestionsLoadingState());
        visitQuestions?.message?.questionLogData[i].opportunityName = visitId;
        visitQuestions?.message?.questionLogData[i].attachFile = attachedFile;
        Response response = await DioHelper.putData(
            url: EndPoints.UPDATE_ANSWER,
            query: visitQuestions?.message?.questionLogData[i].toJson());
        if (response.data['message']['success'] == true) {
          emit(UpdateQuestionsSuccessState());
        } else {
          emit(UpdateQuestionsErrorState());
        }
        if (i == visitQuestions!.message!.questionLogData.length - 1) {
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.pop(navigatorKey.currentContext!);
        }
      }
    } catch (e) {
      emit(UpdateQuestionsErrorState());
    }
  }

  getOldFeedback(visitId) async {
    try {
      emit(GetOldFeedbackLoadingState());
      Map<String, dynamic> data = {
        "opportunity_owner": hubData?.userData?.email,
        "party_name": "CRM-LEAD-2023-00001",
        "transaction_date": "2023-08-14"
      };
      Response response = await DioHelper.getData(
          url: EndPoints.GET_FEEDBACK, queryParameters: data);
      if (response.data['message']['to_discuss'] != null) {
        oldFeedback = OldFeedbackModel.fromJson(response.data);
        emit(GetOldFeedbackSuccessState());
      } else {
        emit(GetOldFeedbackErrorState());
      }
    } catch (e) {
      emit(GetOldFeedbackErrorState());
    }
  }

  updateFeedback(context, id) async {
    try {
      emit(UpdateFeedbackLoadingState());
      Map<String, dynamic> data = {
        "opportunity_name": id,
        "to_discuss": feedbackComment.text.trim()
      };
      Response response =
          await DioHelper.putData(url: EndPoints.UPDATE_FEEDBACK, query: data);
      if (response.data['message']['message'] ==
          "Fields updated successfully") {
        Navigator.pop(navigatorKey.currentContext!);
        emit(UpdateFeedbackSuccessState());
        showToast("Feedback updated successfully", color: approvedColor);
      } else {
        emit(UpdateFeedbackErrorState());
        showToast(response.data['message']['message']);
      }
    } catch (e) {
      emit(UpdateFeedbackErrorState());
      showToast(e);
    }
  }

  feedbackDialog(context, id) {
    visitDialog(
      context: context,
      title: "FEEDBACK",
      buttonTitle: "SUBMIT",
      onTap: () {
        updateFeedback(context, id);
      },
      child: BlocProvider.value(
        value: BlocProvider.of<VisitsCubit>(context),
        child: BlocBuilder<VisitsCubit, VisitsStates>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (oldFeedback?.message?.toDiscuss != null)
                  const Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: approvedColor,
                        size: 20,
                      ),
                      Text(
                        "24 May 2023",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                if (oldFeedback?.message?.toDiscuss != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CupertinoTextField(
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: decorationOfTextFeild,
                      controller: TextEditingController(
                          text: oldFeedback?.message?.toDiscuss.toString()),
                      enabled: false,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: approvedColor,
                      size: 20,
                    ),
                    Text(
                      DateTimeFormating.formatCustomDate(
                          date: DateTime.now(), formatType: 'dd MMMM yyyy'),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: CupertinoTextField(
                    placeholder: "Write your feedback here..",
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: decorationOfTextFeild,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: feedbackComment,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  visitIsDoneDialod(context, visitId) {
    visitDialog(
      context: context,
      title: "IT'S DONE",
      buttonTitle: "SUBMIT",
      onTap: () {
        updateQuestions(context, visitId);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            itemCount: visitQuestions?.message?.questionLogData.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visitQuestions!.message!.questionLogData[index].question!,
                    style: const TextStyle(
                        fontFamily: FontFamilyStrings.ARIAL_REGULAR,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff515C6F)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: CupertinoTextField(
                      decoration: decorationOfTextFeild,
                      style: const TextStyle(
                          fontFamily: FontFamilyStrings.ARIAL_LIGHT,
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                      padding: const EdgeInsets.all(10),
                      controller: visitQuestions!
                          .message!.questionLogData[index].answer,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocProvider.value(
            value: BlocProvider.of<VisitsCubit>(context),
            child: BlocBuilder<VisitsCubit, VisitsStates>(
                builder: (context, state) {
              return attachFile(
                  onTap: () {
                    getAttachFile();
                  },
                  attachedFile: attachedFile);
            }),
          ),
        ],
      ),
    );
  }

  String? attachedFile;
  getAttachFile() async {
    emit(GetAttachFileLoadingState());
    try {
      final response = await getAttachUrl();
      if (response != null) {
        attachedFile = response;
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

  getVisitClms(contextt, visitId) async {
    try {
      Response response =
          await DioHelper.getData(url: EndPoints.GET_PLANNING_CLMS);
      planningClms = PlanningClms.fromJson(response.data);
      addPlanAction(contextt, visitId);
    } catch (e) {
      // emit(GetPlanningClmsErrorState());
    }
  }

  changeIncludingClm() {
    isClmplan = !isClmplan;
    emit(ChangeIncludingClmState());
  }

  changeClmSelection(val) {
    if (clmsSelected.contains(val)) {
      clmsSelected.remove(val);
    } else {
      clmsSelected.add(val);
    }
    emit(ChangeIncludingClmDataState());
  }

  updateIncludeClm(visitId) async {
    try {
      Map<String, dynamic> data = {
        "opportunity_name": visitId,
        "include_clm": isClmplan ? 1 : 0
      };
      await DioHelper.putData(url: EndPoints.UPDATE_INCLUDE_CLM, query: data);
      // ignore: empty_catches
    } catch (e) {}
  }

  updateClmStatus(visitId) async {
    updateIncludeClm(visitId);
    for (var i = 0; i < clmsSelected.length; i++) {
      try {
        Map<String, dynamic> data = {
          "opportunity_name": visitId,
          "clm_name": clmsSelected[i],
          "include_clm": isClmplan ? 1 : 0
        };
        await DioHelper.putData(url: EndPoints.END_VISIT, query: data);
        // ignore: empty_catches
      } catch (e) {}
      if (i == clmsSelected.length - 1) {
        showToast("Updated", color: approvedColor);
      }
      doctorData2?.includeClm = 1;
    }
  }
}
