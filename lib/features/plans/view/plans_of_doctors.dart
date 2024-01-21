import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/core/app_switches.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:data_soft/features/plans/widgets/plans_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import '../../drawer/drawer_sceen.dart';
import '../../today_plan/model/today_plan_model.dart';
import '../view_model/cubit/plans_of_days_cubit.dart';

class PlansOfDoctors extends StatelessWidget {
  PlansOfDoctors(
      {super.key,
      required this.data,
      required this.cubitContext,
      required this.status});
  final List<DoctorData> data;
  final dynamic cubitContext;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String status;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<PlansOfDaysCubit>(cubitContext)
        ..getLastVisit()
        ..setDataToPlansModel(data),
      child: BlocBuilder<PlansOfDaysCubit, PlansOfDaysStates>(
        builder: (context, state) {
          var cubit = PlansOfDaysCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            endDrawer: const DrawerScreen(
              screenName: "Plan Status",
            ),
            appBar: AppBar(),
            body: Column(
              children: [
                CustAppBar(
                  title: "planStatusTitle".i18n(),
                  scaffoldKey: scaffoldKey,
                  imageSrc: 'plans_icon',
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: imageSvg(
                                    src: "calendar_icon",
                                    color: const Color(0xff2699FB)),
                              ),
                              Expanded(
                                child: FittedBox(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: PlanSelectDateTime(
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
                                    time: cubit.custDateTime.toString(),
                                    title: null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      imageSvg(src: "edit_icon", size: 20),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: colorStatus(
                          cubit.dayStatus ?? status,
                        )['color'],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        cubit.dayStatus ?? status,
                        style: TextStyle(
                            fontFamily: FontFamilyStrings.ARIAL_REGULAR,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: colorStatus(
                              cubit.dayStatus ?? status,
                            )['color']),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: ConditionalBuilder(
                  condition: cubit.plansOfDaysModel != null,
                  builder: (context) {
                    return cubit.plansOfDaysModel!.message!.data.isEmpty
                        ? noDataFound(context, type: "Visits")
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: ListView.separated(
                              itemCount:
                                  cubit.plansOfDaysModel!.message!.data.length,
                              itemBuilder: (context, index) {
                                final isPartially =
                                    cubit.dayStatus == "Partially Approved" ||
                                        status == "Partially Approved";
                                return Dismissible(
                                  key: UniqueKey(),
                                  confirmDismiss: (direction) async {
                                    if (cubit.plansOfDaysModel!.message!
                                                .data[index].status ==
                                            "Open" &&
                                        cubit.plansOfDaysModel!.message!
                                                .data[index].statusPlan ==
                                            "In Review") {
                                      cubit.deleteVisit(
                                          index,
                                          cubit.plansOfDaysModel!.message!
                                              .data[index].visitId);
                                    } else {
                                      showSnackBar(context,
                                          text: "You cannot delete this visit");
                                    }
                                    return false;
                                  },
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: isPartially ? 7.5 : 0,
                                            right: isPartially ? 7.5 : 0),
                                        child: DoctorsContent(
                                          index: index,
                                          doctorData: cubit.plansOfDaysModel!
                                              .message!.data[index],
                                          lastVisit: cubit.plansOfDaysModel!
                                              .message!.data[index].lastVisit,
                                        ),
                                      ),
                                      if (isPartially)
                                        Icon(
                                          Icons.circle,
                                          size: 20,
                                          color: colorStatus(
                                            cubit.plansOfDaysModel!.message!
                                                .data[index].statusPlan,
                                          )['color'],
                                        ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 20,
                              ),
                            ),
                          );
                  },
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator()),
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
