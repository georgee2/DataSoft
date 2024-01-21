import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/features/salaries/view_model/cubit/salaries_cubit.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timelines/timelines.dart';
import '../../../core/constants.dart';

class SalaryScreen extends StatelessWidget {
  SalaryScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(screenName: "Salaries"),
      body: Column(
        children: [
          CustAppBar(
              title: "Salaries",
              scaffoldKey: scaffoldKey,
              imageSrc: "tasks_icon"),
          Expanded(
            child: BlocProvider(
              create: (context) => SalariesCubit()..getSalaries(),
              child: BlocBuilder<SalariesCubit, SalariesStates>(
                builder: (context, state) {
                  var cubit = SalariesCubit.get(context);
                  return ConditionalBuilder(
                    condition: cubit.salariesModel != null,
                    builder: (context) => cubit.salaryData?.postingDate == null
                        ? noDataFound(context)
                        : Column(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Card(
                                      margin: const EdgeInsets.all(10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Wrap(
                                                    children: [
                                                      const Text(
                                                        "Good Morning ",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                FontFamilyStrings
                                                                    .ROBOTO_LIGHT),
                                                      ),
                                                      Text(
                                                        userData!.fullName!,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                FontFamilyStrings
                                                                    .ROBOTO_BOLD),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuButton(
                                                  child: Row(
                                                    children: [
                                                      imageSvg(
                                                          src:
                                                              "calendar_event"),
                                                      Text(
                                                        DateTimeFormating.formatCustomDate(
                                                            date: cubit
                                                                    .salaryData
                                                                    ?.postingDate ??
                                                                "",
                                                            formatType:
                                                                'dd MMM, yyyy'),
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: primaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                FontFamilyStrings
                                                                    .ROBOTO_BOLD),
                                                      )
                                                    ],
                                                  ),
                                                  itemBuilder: (context) =>
                                                      cubit.salariesModel!
                                                          .message!.data
                                                          .map(
                                                              (e) =>
                                                                  PopupMenuItem(
                                                                      onTap:
                                                                          () {
                                                                        cubit.changeSalaryItem(
                                                                            e);
                                                                      },
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          DateTimeFormating.formatCustomDate(
                                                                              date: e.postingDate ?? "",
                                                                              formatType: 'dd MMM, yyyy'),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                      )))
                                                          .toList(),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Gross salary:',
                                                  style: TextStyle(
                                                      color: approvedColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${cubit.salaryData?.grossPay ?? ""} LE',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Net Salary:',
                                                  style: TextStyle(
                                                      color: approvedColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '${cubit.salaryData?.netPay ?? ""} LE',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(top: 10),
                                      color: const Color(0xffEBEEF1),
                                      child: const Text(
                                        "Salary details",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            fontFamily: FontFamilyStrings
                                                .ROBOTO_REGULAR),
                                      ),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics: const ClampingScrollPhysics(),
                                        child: Column(
                                          children: [
                                            Timeline.tileBuilder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              theme: TimelineTheme.of(context)
                                                  .copyWith(nodePosition: 0.1),
                                              builder:
                                                  TimelineTileBuilder.connected(
                                                      itemCount: cubit
                                                          .salaryData!
                                                          .earnings
                                                          .length,
                                                      contentsBuilder:
                                                          (context, index) {
                                                        return Row(
                                                          children: [
                                                            TimelineNode.simple(
                                                              drawStartConnector:
                                                                  true,
                                                              drawEndConnector:
                                                                  true,
                                                              color:
                                                                  secondryColor,
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        5,
                                                                        20,
                                                                        30,
                                                                        20),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      cubit
                                                                          .salaryData!
                                                                          .earnings[
                                                                              index]
                                                                          .salaryComponent!,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      cubit
                                                                          .salaryData!
                                                                          .earnings[
                                                                              index]
                                                                          .amount
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              secondryColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                            ),
                                            Timeline.tileBuilder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              theme: TimelineTheme.of(context)
                                                  .copyWith(nodePosition: 0.1),
                                              builder:
                                                  TimelineTileBuilder.connected(
                                                      itemCount: cubit
                                                          .salaryData!
                                                          .deductions
                                                          .length,
                                                      contentsBuilder:
                                                          (context, index) {
                                                        return Row(
                                                          children: [
                                                            TimelineNode.simple(
                                                              drawStartConnector:
                                                                  true,
                                                              drawEndConnector: index !=
                                                                  cubit
                                                                          .salaryData!
                                                                          .deductions
                                                                          .length -
                                                                      1,
                                                              color:
                                                                  secondryColor,
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        5,
                                                                        20,
                                                                        30,
                                                                        20),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      cubit
                                                                          .salaryData!
                                                                          .deductions[
                                                                              index]
                                                                          .salaryComponent!,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      "- ${cubit.salaryData!.deductions[index].amount.toString()}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              rejectedColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 0, 20, 10),
                                              child: Divider(
                                                height: 2,
                                                thickness: 1,
                                              ),
                                            ),
                                            RichText(
                                                text: TextSpan(
                                              text: 'Net Salary: ',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '${cubit.salaryData?.netPay ?? ""} LE',
                                                    style: const TextStyle(
                                                        color: secondryColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            FontFamilyStrings
                                                                .ROBOTO_BOLD))
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.all(10),
                                color: const Color(0xffEBEEF1),
                                child: const Text(
                                  "Workdays details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      fontFamily:
                                          FontFamilyStrings.ROBOTO_REGULAR),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Workdays",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily:
                                              FontFamilyStrings.ROBOTO_LIGHT,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              cubit
                                                  .salaryData!.totalWorkingDays!
                                                  .toInt()
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: secondryColor),
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          "DAYS",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: secondryColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Leave without pay",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily:
                                              FontFamilyStrings.ROBOTO_LIGHT,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              cubit.salaryData!.leaveWithoutPay!
                                                  .toInt()
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: secondryColor),
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          "DAYS",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: secondryColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SafeArea(
                                top: false,
                                right: false,
                                left: false,
                                bottom: true,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Advance payment",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily:
                                                FontFamilyStrings.ROBOTO_LIGHT,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                cubit
                                                    .salaryData!.totalDeduction!
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: secondryColor),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          const Text(
                                            "LE",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: secondryColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                    fallback: (context) => const Expanded(
                        child: Center(child: CupertinoActivityIndicator())),
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
