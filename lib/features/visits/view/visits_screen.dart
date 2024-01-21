// ignore_for_file: must_be_immutable

import 'package:data_soft/features/clients/view/client_details.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import '../../../core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import '../../today_plan/model/today_plan_model.dart';
import '../model/visit_count_model.dart';
import '../view_model/cubit/visits_cubit.dart';
import '../widgets/visit_widgets.dart';

class VisitsScreen extends StatelessWidget {
  VisitsScreen(
      {super.key,
      required this.tag,
      this.doctorData,
      this.visitCountModel,
      this.fromLocal = false});
  final bool fromLocal;
  final String tag;
  DoctorData? doctorData;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final VisitCountModel? visitCountModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(
        screenName: "Visits",
      ),
      body: BlocProvider(
        create: (context) => VisitsCubit()
          ..navigateFromLocal(visitCountModel, doctorData!,
              fromLocal: fromLocal)
          ..getClientDetails(
              doctorData?.customerName ?? visitCountModel!.doctorName!)
          ..getOldFeedback(doctorData?.partyName ?? visitCountModel?.doctorID),
        child: BlocBuilder<VisitsCubit, VisitsStates>(
          builder: (context, state) {
            var cubit = VisitsCubit.get(context);
            return Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CustAppBarWithClip(
                            scaffoldKey: scaffoldKey,
                            title: "visitsTitle".i18n(),
                            imageSrc: "visits_icon",
                            widget: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: PopupMenuButton(
                                            padding: const EdgeInsetsDirectional
                                                .only(bottom: 40, start: 10),
                                            iconSize: 30,
                                            color: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            icon: imageSvg(
                                                src: !cubit.isDownNow
                                                    ? 'arrow_down'
                                                    : 'arrow_up_circle_enabled_icon'),
                                            onCanceled: () {
                                              cubit.onCancel();
                                            },
                                            onOpened: () {
                                              cubit.onOpen();
                                            },
                                            itemBuilder: (context) => [
                                              {
                                                'title': "Info",
                                                'icon': "doctor_info_icon",
                                              },
                                              {
                                                'title': "Feedback",
                                                'icon': "feedback_icon",
                                              },
                                            ]
                                                .map((e) => PopupMenuItem(
                                                    onTap: () {
                                                      if (e['title'] ==
                                                          "Info") {
                                                        Future.delayed(
                                                                const Duration(
                                                                    milliseconds:
                                                                        500))
                                                            .then((value) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ViewClient(
                                                                    leadName: cubit
                                                                            .doctorData2
                                                                            ?.customerName ??
                                                                        visitCountModel!
                                                                            .doctorName!),
                                                              ));
                                                        });
                                                      } else {
                                                        Future.delayed(
                                                                const Duration(
                                                                    seconds: 1))
                                                            .then((value) => cubit.feedbackDialog(
                                                                context,
                                                                cubit.doctorData2
                                                                        ?.visitId ??
                                                                    visitCountModel
                                                                        ?.opportunityName));
                                                      }
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .centerStart,
                                                      children: [
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin:
                                                              const EdgeInsetsDirectional
                                                                      .only(
                                                                  start: 8),
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  5, 5, 0, 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              color: const Color(
                                                                  0xffD2E8F3)),
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          child: Text(
                                                            e['title']
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                          ),
                                                        ),
                                                        imageSvg(src: e['icon'])
                                                      ],
                                                    )))
                                                .toList(),
                                          )),
                                      Hero(
                                          tag: "$tag-doctorr",
                                          child: custProviderNetWorkImage(
                                              image: cubit.doctorData2?.images,
                                              radius: 45)),
                                      const SizedBox(
                                        width: 50,
                                      )
                                    ]))),
                      ],
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    DoctorDetails(
                        visitState: cubit.visitState,
                        doctorData: cubit.doctorData2!),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45),
                      child: Divider(),
                    ),
                    Expanded(
                        child: cubit.visitState == "General"
                            ? GeneralWidget(
                                doctorData: cubit.doctorData2!,
                              )
                            : cubit.visitState == "StartingCLM"
                                ? const StartingClmWidget()
                                : cubit.visitState == "CLMPages"
                                    ? const ClmPagesWidget()
                                    : cubit.visitState == "ViewPage"
                                        ? const ViewPageWidget()
                                        : const NormalVisitWidget())
                  ],
                )),
              ],
            );
          },
        ),
      ),
    );
  }
}
