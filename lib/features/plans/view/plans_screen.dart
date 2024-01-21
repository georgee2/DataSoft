import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/features/plans/view/plans_of_doctors.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import '../../../core/constants.dart';
import '../view_model/cubit/plans_of_days_cubit.dart';
import 'package:data_soft/core/app_switches.dart';

class PlansScreen extends StatelessWidget {
  PlansScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const DrawerScreen(
        screenName: "Plan Status",
      ),
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => PlansOfDaysCubit()..getPlans(),
        child: BlocBuilder<PlansOfDaysCubit, PlansOfDaysStates>(
          builder: (context, state) {
            var cubit = PlansOfDaysCubit.get(context);
            return Column(
              children: [
                CustAppBar(
                  title: "planStatusTitle".i18n(),
                  scaffoldKey: scaffoldKey,
                  imageSrc: 'plans_icon',
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          imageSvg(
                              src: "calendar_icon",
                              color: const Color(0xff2699FB),
                              size: 20),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "dates".i18n(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: FontFamilyStrings.ROBOTO_REGULAR,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff2699FB)),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FromAndToDateTimeContainer(
                          onTap: () {
                            cubit.changeDate(context);
                          },
                          time: cubit.fullDate == null
                              ? DateFormat('dd - MMMM ,yyyy')
                                  .format(DateTime.now())
                                  .toString()
                              : cubit.fullDate!),
                    ],
                  ),
                ),
                Expanded(
                    child: ConditionalBuilder(
                  condition: cubit.plansOfDaysModel != null,
                  builder: (context) => cubit.plansData.isEmpty
                      ? noDataFound(context, type: "Plans")
                      : ListView.builder(
                          itemCount: cubit.plansData.length,
                          itemBuilder: (cubitContext, index) {
                            return ContentWidget(
                              buttonTitle: "viewPlan".i18n(),
                              centerTitleType: "visitsTitle".i18n(),
                              centerText: cubit.plansData[index]['data'].length
                                  .toString(),
                              bottomTextColor: colorStatus(cubit
                                  .plansData[index]['status_plan'])['color'],
                              bottomText: textStatus(
                                  cubit.plansData[index]['status_plan']),
                              buttonColor: primaryColor,
                              widget: DateWidgets(
                                  year: DateTimeFormating.formatCustomDate(
                                      date: cubit.plansData[index]
                                          ['transaction_date'],
                                      formatType: "yyyy"),
                                  month: DateTimeFormating.formatCustomDate(
                                      date: cubit.plansData[index]
                                          ['transaction_date'],
                                      formatType: "MMM"),
                                  day: DateTimeFormating.formatCustomDate(
                                      date: cubit.plansData[index]
                                          ['transaction_date'],
                                      formatType: "dd")),
                              onTap: () {
                                cubit.dayStatus = null;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlansOfDoctors(
                                        data: cubit.plansData[index]['data'],
                                        cubitContext: cubitContext,
                                        status: textStatus(cubit
                                            .plansData[index]['status_plan']),
                                      ),
                                    ));
                              },
                            );
                          },
                        ),
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator()),
                ))
              ],
            );
          },
        ),
      ),
    );
  }
}
