import 'package:data_soft/features/today_plan/view_model/cubit/today_plan_cubit.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';
import 'package:data_soft/core/constants.dart';
import 'package:flutter/material.dart';
import '../../../core/app_fonts.dart';
import '../../../core/local/cache_helper.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../today_plan/model/today_plan_model.dart';
import '../../visits/model/visit_count_model.dart';
import '../../visits/view/visits_screen.dart';

class PlanSelectDateTime extends StatelessWidget {
  const PlanSelectDateTime(
      {super.key,
      required this.onTap,
      required this.time,
      required this.title,
      this.icon});
  final Function() onTap;
  final String? title;
  final String time;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          Container(
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.only(top: title == null ? 0 : 15),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: const Color(0xff2699FB), width: 1.5),
              color: bgColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time,
                    style: const TextStyle(
                        fontFamily: FontFamilyStrings.ROBOTO_REGULAR,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: primaryColor)),
                Icon(
                  icon ?? Icons.keyboard_arrow_down,
                  color: primaryColor,
                )
              ],
            ),
          ),
          if (title != null)
            Container(
                margin: const EdgeInsetsDirectional.only(start: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: borderRadius, border: border, color: bgColor),
                child: Text(
                  title!,
                  style: const TextStyle(color: primaryColor),
                ))
        ],
      ),
    );
  }
}

class DoctorsContent extends StatelessWidget {
  const DoctorsContent({
    super.key,
    required this.index,
    required this.doctorData,
    this.lastVisit,
    this.cubit,
  });
  final int index;
  final String? lastVisit;
  final DoctorData doctorData;
  final TodayPlanCubit? cubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        Container(
          height: 90,
          alignment: Alignment.center,
          padding: const EdgeInsetsDirectional.fromSTEB(35, 10, 10, 10),
          margin: const EdgeInsetsDirectional.only(start: 30),
          decoration: BoxDecoration(
              border: border,
              borderRadius: borderRadius,
              color: bgColor,
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                    color: Colors.grey.withOpacity(0.5))
              ]),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorData.customerName.toString(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: FontFamilyStrings.ROBOTO_MEDIUM,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      doctorData.medicalSpecialty.toString(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: FontFamilyStrings.ROBOTO_REGULAR,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      lastVisit ?? "",
                      style: const TextStyle(
                          fontFamily: FontFamilyStrings.ROBOTO_LIGHT,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: Color(0xff69A3A2)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                color: doctorData.status == "Closed" && cubit != null
                    ? selectColor(SelectColor.APPROVED)
                    : doctorData.status == "Converted" && cubit != null
                        ? selectColor(SelectColor.REJECTED)
                        : selectColor(SelectColor.DEFAULT),
                title: cubit != null
                    ? doctorData.status == "Closed" && cubit != null
                        ? "Done"
                        : doctorData.status == "Converted" && cubit != null
                            ? "End visit"
                            : "Start visit"
                    : "View visit",
                onTap: () async {
                  if (doctorData.status == "Converted" && cubit != null) {
                    VisitCountModel? visitCountModel = VisitCountModel.fromJson(
                        await CacheHelper.getData("VisitData", Map) ?? {});
                    Future.delayed(const Duration(milliseconds: 500))
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VisitsScreen(
                                    fromLocal: true,
                                    tag: '',
                                    visitCountModel: visitCountModel,
                                    doctorData: DoctorData(
                                      customerName: visitCountModel.doctorName,
                                      medicalSpecialty:
                                          visitCountModel.medicalSpecialty,
                                      partyName: visitCountModel.doctorID,
                                      visitId: visitCountModel.opportunityName,
                                    ),
                                  )));
                    });
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisitsScreen(
                              tag: index.toString(), doctorData: doctorData),
                        ));
                  }
                },
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
                tag: "$index-doctorr",
                child: custProviderNetWorkImage(
                    image: doctorData.images, radius: 30)),
          ],
        )
      ],
    );
  }
}
