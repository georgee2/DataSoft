import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_datetime.dart';
import '../../../core/app_dialogs.dart';
import '../../../core/app_fonts.dart';
import '../../../core/external_sharing.dart';
import '../../../core/maps_widget.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../today_plan/model/today_plan_model.dart';
import '../view_model/cubit/visits_cubit.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';

// Visit Dialog frame
visitDialog(
    {required BuildContext context,
    required String title,
    required Widget child,
    required String buttonTitle,
    required Function() onTap}) {
  showDialog(
      context: context,
      builder: (context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 300,
                          margin: const EdgeInsets.only(bottom: 25),
                          padding: const EdgeInsets.only(bottom: 25),
                          decoration: BoxDecoration(
                              borderRadius: borderRadius, color: bgColor),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: selectGradientColor(
                                        SelectColor.APPROVED),
                                    begin: const FractionalOffset(0.5, 0.5),
                                    end: const FractionalOffset(0.0, 0.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            imageSvg(src: "arrow_left_circle"),
                                      ),
                                    ),
                                    Text(
                                      title,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child:
                                          imageSvg(src: 'star_icon', size: 35),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: child)
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            height: 50,
                            width: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: selectColor(SelectColor.APPROVED),
                            ),
                            child: Text(
                              buttonTitle,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
}

// Posting Visit Dialog
postponeVisitDialog({required BuildContext context, required String? id}) {
  dialogFrameSingleButton(
    context: context,
    title: "POSTPONE VISIT ",
    buttonTitle: "POSTPONE",
    buttonColor: primaryColor,
    colors: selectGradientColor(SelectColor.DEFAULT),
    onTap: () {
      if (VisitsCubit.get(context).postPoneDateTime == "Chose date....") {
        showToast("Please choose another date");
      } else {
        VisitsCubit.get(context).postPoneVisit(context, id);
      }
    },
    child: BlocProvider.value(
      value: BlocProvider.of<VisitsCubit>(context),
      child: BlocBuilder<VisitsCubit, VisitsStates>(
        builder: (context, state) {
          var cubit = VisitsCubit.get(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Postpone  For",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff515C6F)),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025))
                          .then((value) {
                        if (value != null) {
                          cubit.changeDateTime(value);
                        }
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 205,
                      alignment: AlignmentDirectional.centerStart,
                      padding: const EdgeInsetsDirectional.only(start: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xff515C6F), width: 0.5),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                          cubit.postPoneDateTime ==
                                  DateTimeFormating.formatCustomDate(
                                      date: DateTime.now(),
                                      formatType: "dd MMMM ,yyyy")
                              ? "Chose date...."
                              : cubit.postPoneDateTime,
                          style: TextStyle(
                              color: cubit.postPoneDateTime == "Chose date...."
                                  ? const Color(0xff515C6F).withOpacity(0.5)
                                  : const Color(0xff515C6F))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: imageSvg(src: 'title'),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustCommentTextField(
                onTap: null,
                showAttachFile: false,
                controller: cubit.postPoneComment,
              )
            ],
          );
        },
      ),
    ),
  );
}

// This function to create CLM
addPlanAction(contextt, visitId) {
  dialogFrameSingleButton(
    context: contextt,
    title: "CLM Creation",
    buttonTitle: "Create",
    buttonColor: primaryColor,
    colors: selectGradientColor(SelectColor.DEFAULT),
    onTap: () {
      VisitsCubit.get(contextt).updateClmStatus(visitId);
      Navigator.pop(contextt);
    },
    child: BlocProvider.value(
      value: BlocProvider.of<VisitsCubit>(contextt),
      child: BlocBuilder<VisitsCubit, VisitsStates>(
        builder: (contextt, state) {
          var cubit = VisitsCubit.get(contextt);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "This plan include CLM visits?",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Row(
                children: [
                  Checkbox(
                      value: cubit.isClmplan,
                      onChanged: (val) {
                        cubit.changeIncludingClm();
                      }),
                  const Text("Include CLM")
                ],
              ),
              if (cubit.isClmplan)
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: cubit.planningClms!.message!
                      .map((e) => GestureDetector(
                            onTap: () {
                              cubit.changeClmSelection(e.name);
                            },
                            child: Stack(children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child:
                                    custDefaultNetWorkImage(e.image.toString()),
                              ),
                              if (cubit.clmsSelected.contains(e.name))
                                Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.withOpacity(0.5)),
                                    child: const Icon(
                                      Icons.check_circle_outline,
                                      color: approvedColor,
                                      size: 50,
                                    )),
                            ]),
                          ))
                      .toList(),
                )
            ],
          );
        },
      ),
    ),
  );
}

// Doctor details (Doctor name, Medical Specialty, Last visit)
class DoctorDetails extends StatelessWidget {
  const DoctorDetails({
    super.key,
    required this.visitState,
    required this.doctorData,
  });

  final String visitState;
  final DoctorData doctorData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            doctorData.customerName.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontFamily: FontFamilyStrings.ROBOTO_MEDIUM,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            doctorData.medicalSpecialty.toString(),
            style: const TextStyle(
                fontSize: 14,
                fontFamily: FontFamilyStrings.ROBOTO_REGULAR,
                fontWeight: FontWeight.w300,
                color: Colors.black),
          ),
          const SizedBox(
            height: 7,
          ),
          if (visitState == "General")
            Text(
              doctorData.lastVisit ?? "",
              style: const TextStyle(
                  fontFamily: FontFamilyStrings.ROBOTO_LIGHT,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: Color(0xff69A3A2)),
            ),
        ],
      ),
    );
  }
}

// ...
class SocialWidget extends StatelessWidget {
  final BuildContext contextt;

  const SocialWidget({super.key, required this.contextt});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<VisitsCubit>(context),
      child: BlocBuilder<VisitsCubit, VisitsStates>(
        builder: (context, state) {
          var cubit = VisitsCubit.get(context);
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            opacity: cubit.clientDetailsModel != null ? 1.0 : 0,
            child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialContent(cubit.clientDetailsModel?.location,
                        "location_circle_icon"),
                    socialContent(cubit.clientDetailsModel?.whatsAppNumber,
                        "whatsapp_logo"),
                    socialContent(
                        cubit.clientDetailsModel?.linkedin, "linkedin_logo"),
                    socialContent(
                        cubit.clientDetailsModel?.facebook, "facebook_logo"),
                  ],
                )),
          );
        },
      ),
    );
  }

  Widget socialContent(url, imageSrc) {
    if (url != null) {
      return GestureDetector(
        onTap: () {
          if (imageSrc == 'whatsapp_logo') {
            showlaunchUrl("https://wa.me/2$url");
          } else {
          showlaunchUrl(url);
          }
        },
        child: Row(
          children: [
            imageSvg(src: imageSrc, size: 45),
            const SizedBox(width: 10)
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

// General Screen or Normal visit screen
class GeneralWidget extends StatelessWidget {
  const GeneralWidget({super.key, required this.doctorData});
  final DoctorData doctorData;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<VisitsCubit>(context),
      child: BlocBuilder<VisitsCubit, VisitsStates>(
        builder: (context, state) {
          var cubit = VisitsCubit.get(context);
          return Column(
            children: [
              SocialWidget(contextt: context),
              const SizedBox(
                height: 10,
                width: 0,
              ),
              Expanded(
                  child: MapWidget(
                lat: cubit.clientDetailsModel?.lat,
                lng: cubit.clientDetailsModel?.lng,
                location: cubit.clientDetailsModel?.location,
              )),
              if (doctorData.statusPlan == "Approved" &&
                  doctorData.transactionDate ==
                      DateTimeFormating.sendFormatDate(DateTime.now()) &&
                  doctorData.status == "Open")
                SizedBox(
                  width: 180,
                  child: SecondryButton(
                      color: const Color(0xff14C52C),
                      title: "Start CLM",
                      onTap: () {
                        if (cubit.doctorData2?.includeClm == 1) {
                          cubit.visitValidation(
                              doctorData: doctorData,
                              context: context,
                              fromClm: true);
                        } else {
                          cubit.getVisitClms(context, doctorData.visitId);
                        }
                      }),
                ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (doctorData.statusPlan == "Approved" &&
                        doctorData.transactionDate ==
                            DateTimeFormating.sendFormatDate(DateTime.now()) &&
                        doctorData.status == "Open")
                      SizedBox(
                        width: 180,
                        child: SecondryButton(
                            color: const Color(0xff2699FB),
                            title: "Start Visit",
                            onTap: () {
                              cubit.visitValidation(
                                  doctorData: doctorData,
                                  context: context,
                                  fromClm: false);
                            }),
                      ),
                    const SizedBox(width: 10),
                    if (doctorData.status == "Open")
                      SizedBox(
                        width: doctorData.statusPlan == "Approved" &&
                                doctorData.transactionDate ==
                                    DateTimeFormating.sendFormatDate(
                                        DateTime.now()) &&
                                doctorData.status == "Open"
                            ? 120
                            : 180,
                        child: SecondryButton(
                            color: const Color(0xff2699FB),
                            title: "Postpone",
                            onTap: () {
                              postponeVisitDialog(
                                  context: context, id: doctorData.visitId);
                            }),
                      ),
                    if (doctorData.status != "Open")
                      SizedBox(
                        width: doctorData.statusPlan == "Approved" &&
                                doctorData.transactionDate ==
                                    DateTimeFormating.sendFormatDate(
                                        DateTime.now()) &&
                                doctorData.status == "Open"
                            ? 120
                            : 180,
                        child: SecondryButton(
                            color: const Color(0xff2699FB),
                            title: "Back",
                            onTap: () {
                              Navigator.pop(context);
                            }),
                      ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

// Normal visit => Visits not include CLMs
class NormalVisitWidget extends StatelessWidget {
  const NormalVisitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<VisitsCubit>(context),
      child: BlocBuilder<VisitsCubit, VisitsStates>(
        builder: (context, state) {
          var cubit = VisitsCubit.get(context);
          return Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    cubit.timerString,
                    style: const TextStyle(
                        fontSize: 42, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: SecondryButton(
                    color: rejectedColor,
                    title: "End Visit",
                    onTap: () {
                      cubit.endVisit(context);
                    }),
              )
            ],
          );
        },
      ),
    );
  }
}

// Clms scren => include CLMs
class StartingClmWidget extends StatelessWidget {
  const StartingClmWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<VisitsCubit>(context),
      child: BlocBuilder<VisitsCubit, VisitsStates>(
        builder: (context, state) {
          var cubit = VisitsCubit.get(context);
          return Column(
            children: [
              const Text(
                "Choose  CLM to start!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsetsDirectional.all(10),
                child: GridView.count(
                    crossAxisCount: 3,
                    children: cubit.clmModel!.message!.data
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  cubit.openClm(e.clmName);
                                  cubit.getCLMPages(e.clmName);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "CLM ${(cubit.clmModel!.message!.data.indexOf(e) + 1).toString().padLeft(3, '0')}",
                                      style:
                                          const TextStyle(color: primaryColor),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                      width: 0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child:
                                            custDefaultNetWorkImage(e.image!),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList()),
              )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: SecondryButton(
                    color: rejectedColor,
                    title: "End Visit",
                    onTap: () {
                      cubit.endVisit(context);
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}

// View CLMs pages
class ClmPagesWidget extends StatelessWidget {
  const ClmPagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<VisitsCubit>(context),
      child: BlocBuilder<VisitsCubit, VisitsStates>(
        builder: (context, state) {
          var cubit = VisitsCubit.get(context);
          return Column(
            children: [
              Text(
                cubit.timerString,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsetsDirectional.all(10),
                child: GridView.count(
                    crossAxisCount: 3,
                    children: cubit.clmPagesModel!.message!.data
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  cubit.pageView = e;
                                  cubit.startVisitState("ViewPage");
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "PAGE ${(cubit.clmPagesModel!.message!.data.indexOf(e) + 1).toString().padLeft(3, '0')}",
                                      style:
                                          const TextStyle(color: primaryColor),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                      width: 0,
                                    ),
                                    Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: custDefaultNetWorkImage(
                                              e.imageOfPage!)),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList()),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: SecondryButton(
                        color: rejectedColor,
                        title: "End Visit",
                        onTap: () {
                          cubit.endVisit(context);
                        }),
                  ),
                  GestureDetector(
                      onTap: () {
                        cubit.closeClm(cubit.clmPagesModel!.clmName);
                        cubit.startVisitState("StartingCLM");
                      },
                      child: imageSvg(src: "visit_back_icon", size: 40))
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// View one page
class ViewPageWidget extends StatelessWidget {
  const ViewPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<VisitsCubit>(context),
      child: BlocBuilder<VisitsCubit, VisitsStates>(
        builder: (context, state) {
          var cubit = VisitsCubit.get(context);
          return Column(
            children: [
              Text(
                cubit.timerString,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20, vertical: 10),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            cubit.changePageCount("Previous Page");
                          },
                          child: imageSvg(
                              src: cubit.clmPagesModel?.message?.data
                                          .indexOf(cubit.pageView!) ==
                                      0
                                  ? "arrow_left_circle_disabled"
                                  : "arrow_left_circle_enabled")),
                      Text(
                        "PAGE ${(cubit.clmPagesModel!.message!.data.indexOf(cubit.pageView!) + 1).toString().padLeft(3, '0')}",
                        style: const TextStyle(color: primaryColor),
                      ),
                      GestureDetector(
                          onTap: () {
                            cubit.changePageCount("Next Page");
                          },
                          child: imageSvg(
                              src: cubit.clmPagesModel?.message?.data
                                          .indexOf(cubit.pageView!) ==
                                      cubit.clmPagesModel!.message!.data
                                              .length -
                                          1
                                  ? "arrow_right_circle_disabled"
                                  : "arrow_right_circle_enabled"))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                    width: 0,
                  ),
                  Expanded(
                    child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: custDefaultNetWorkImage(
                            "http://154.38.165.213:1212${cubit.clmPagesModel?.message?.data[cubit.clmPagesModel!.message!.data.indexOf(cubit.pageView!)].imageOfPage}")),
                  )
                ]),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: SecondryButton(
                        color: rejectedColor,
                        title: "End Visit",
                        onTap: () {
                          cubit.endVisit(context);
                        }),
                  ),
                  GestureDetector(
                      onTap: () {
                        cubit.startVisitState("CLMPages");
                        cubit.closeClm(cubit.clmPagesModel!.clmName);
                      },
                      child: imageSvg(src: "visit_back_icon", size: 40))
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
