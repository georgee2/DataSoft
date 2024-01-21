import 'package:localization/localization.dart';

import '../../../core/app_enums.dart';
import '../../../core/app_switches.dart';
import 'package:data_soft/core/media_query_values.dart';
import 'package:data_soft/features/home/view_model/cubit/home_cubit.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/features/reports/view/reports_screen.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../drawer/drawer_sceen.dart';
import '../../requests/view/all_requests.dart';
import '../widgets/components.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(
        screenName: "Home",
      ),
      body: Column(
        children: [
          CustAppBar(
              title: "homeTitle".i18n(), scaffoldKey: scaffoldKey, imageSrc: "home_icon"),
          Expanded(
            child: BlocProvider.value(
              value: BlocProvider.of<HomeCubit>(context)..checkHubData(),
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  var cubit = HomeCubit.get(context);
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        if (managerData?.isManager == true)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 20, 20, 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllRequests(),
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      height: context.width / 4,
                                      width: context.width / 4,
                                      margin: const EdgeInsetsDirectional.only(
                                          start: 25),
                                      decoration: BoxDecoration(
                                          borderRadius: borderRadius),
                                      clipBehavior: Clip.antiAlias,
                                      // alignment: Alignment.center,
                                      child: imageSvg(
                                          src: 'requests_icon',
                                          color: primaryColor)),
                                  Expanded(
                                    child: Container(
                                        height: context.width / 4,
                                        width: context.width / 4 * 2,
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                start: 20),
                                        decoration: BoxDecoration(
                                            borderRadius: borderRadius),
                                        clipBehavior: Clip.antiAlias,
                                        // alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/requests_image.png',
                                          fit: BoxFit.fill,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: HomeCycles(
                              cyclesList: cubit.homeCyblesList, cubit: cubit),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Divider(),
                              if (hubData?.customerName == "Onco")
                                if (cubit.reportsCount != null)
                                  Column(
                                    children: [
                                      HomeVisitsStatus(
                                        image: 'uncovered_icon',
                                        title: "uncoveredDoctor".i18n(),
                                        count: cubit
                                            .reportsCount!
                                            .unconveredVisit
                                            .cancelledVisitsCount,
                                        totalPercent: cubit.reportsCount!
                                                .unconveredVisitsPercent ??
                                            "0 %",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReportsScreen(
                                                        title:
                                                            "Uncovered doctors",
                                                        count: cubit
                                                            .reportsCount!
                                                            .unconveredVisit
                                                            .cancelledVisitsCount,
                                                        color: selectColor(
                                                            SelectColor
                                                                .DEFAULT)),
                                              ));
                                        },
                                      ),
                                      HomeVisitsStatus(
                                        image: 'unplanned_icon',
                                        title: "unplannedVisits".i18n(),
                                        count: cubit
                                            .reportsCount!
                                            .unPlannedVisit
                                            .unPlannedVisitsCount,
                                        totalPercent: cubit.reportsCount!
                                                .unPlannedVisitsPercent ??
                                            "0 %",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReportsScreen(
                                                        title:
                                                            "Unplanned visits",
                                                        count: cubit
                                                            .reportsCount!
                                                            .unPlannedVisit
                                                            .unPlannedVisitsCount,
                                                        color: selectColor(
                                                            SelectColor
                                                                .PENDING)),
                                              ));
                                        },
                                      ),
                                      HomeVisitsStatus(
                                        image: 'canceled_icon',
                                        title: "cancelledVisits".i18n(),
                                        count: cubit
                                            .reportsCount!
                                            .cancelledVisit
                                            .cancelledVisitsCount,
                                        totalPercent: cubit.reportsCount!
                                                .cancelledVisitsPercent ??
                                            "0 %",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReportsScreen(
                                                        title:
                                                            "Cancelled visits",
                                                        count: cubit
                                                            .reportsCount!
                                                            .cancelledVisit
                                                            .cancelledVisitsCount,
                                                        color: selectColor(
                                                            SelectColor
                                                                .REJECTED)),
                                              ));
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 10),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerStart,
                                                  child: Text(
                                                    "yearVisits".i18n(),
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 30),
                                                child: Row(children: [
                                                  const Text(
                                                    "1.8%",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    child: Icon(
                                                        Icons.arrow_upward,
                                                        color: Colors.green),
                                                  ),
                                                  Text(
                                                    "thanLastYear".i18n(),
                                                  ),
                                                ]),
                                              ),
                                              SizedBox(
                                                  height: 212,
                                                  width: double.infinity,
                                                  child: lineChart()),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              const Divider(),
                              if (cubit.statusPercentagesModel != null)
                                Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text("visitsReport".i18n(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff515C6F))),
                                          ],
                                        ),
                                        SizedBox(
                                            height: 200,
                                            width: double.infinity,
                                            child: donutChart(
                                                red: cubit
                                                    .statusPercentagesModel
                                                    ?.message
                                                    ?.date
                                                    ?.incompletePercentage,
                                                green: cubit
                                                    .statusPercentagesModel
                                                    ?.message
                                                    ?.date
                                                    ?.completedPercentage,
                                                blue: cubit
                                                    .statusPercentagesModel
                                                    ?.message
                                                    ?.date
                                                    ?.inProgressPercentage)),
                                        Row(
                                          children: [
                                            Container(
                                              height: 12.5,
                                              width: 12.5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: const Color(0xff21D59B),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child:
                                                    Text("completedVisits".i18n())),
                                            Text(
                                                "${cubit.statusPercentagesModel?.message?.date?.completedPercentage}%",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 12.5,
                                                width: 12.5,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    color: primaryColor),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Text("inProgress".i18n())),
                                              Text(
                                                  "${cubit.statusPercentagesModel?.message?.date?.inProgressPercentage}%",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 12.5,
                                              width: 12.5,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: Colors.red,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child:
                                                    Text("visitsIncomplete".i18n())),
                                            Text(
                                                "${cubit.statusPercentagesModel?.message?.date?.incompletePercentage}%",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        const Divider(
                                          height: 50,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
