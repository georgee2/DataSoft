import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/features/activities/view_model/available_cubit.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import '../../../core/app_dialogs.dart';
import '../../../core/app_enums.dart';
import '../../../core/app_switches.dart';
import '../view_model/activities_cubit.dart';

class ActivitiesScreen extends StatelessWidget {
  ActivitiesScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivitiesCubit()
        ..getActivities()
        ..getActivitiesTypes(),
      child: BlocBuilder<ActivitiesCubit, ActivitiesStates>(
        builder: (context, state) {
          var cubit = ActivitiesCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(),
              endDrawer: const DrawerScreen(
                screenName: "Activities",
              ),
              body: Column(
                children: [
                  CustAppBar(
                    title: "activitiesTitle".i18n(),
                    scaffoldKey: scaffoldKey,
                    imageSrc: 'activities_icon',
                  ),
                  BlocProvider(
                    create: (context) => AvailableCubit()..getAvailableBudget(),
                    child: BlocBuilder<AvailableCubit, AvailableStates>(
                      builder: (context, state) {
                        var cubit = AvailableCubit.get(context);
                        return ConditionalBuilder(
                          condition: cubit.availableBudgetModel != null &&
                              cubit.availableBudgetModel!.message!.success !=
                                  false,
                          builder: (context) {
                            return Container(
                                height: 90,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25)),
                                    color: secondryColor),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Available: ${cubit.availableBudgetModel?.message?.data[0].value} LE",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "Expenditure budget: ${cubit.availableBudgetModel?.message?.data[0].expenditure} LE",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                ));
                          },
                          fallback: (context) => Container(),
                        );
                      },
                    ),
                  ),
                  Expanded(
                      child: ConditionalBuilder(
                    condition: cubit.activitiesModel != null,
                    builder: (context) {
                      return cubit.activitiesModel!.message.isEmpty
                          ? noDataFound(context, type: "Activities")
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    "all".i18n(),
                                    "approved".i18n(),
                                    "reject".i18n(),
                                    "pending".i18n()
                                  ]
                                      .map(
                                        (e) => TextButton(
                                            onPressed: () {
                                              cubit.changeScreenType(e);
                                            },
                                            child: Text(
                                              e,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: cubit.screenType == e
                                                      ? secondryColor
                                                      : Colors.grey),
                                            )),
                                      )
                                      .toList(),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        cubit.activitiesModel?.message.length,
                                    itemBuilder: (context, index) =>
                                        ContentWidget(
                                            buttonTitle: "details".i18n(),
                                            topText: cubit.activitiesModel
                                                ?.message[index].typeExpense,
                                            centerText: cubit.activitiesModel
                                                ?.message[index].advanceAmount
                                                .toString(),
                                            centerTitleType: "LE",
                                            bottomText: textStatus(cubit
                                                .activitiesModel
                                                ?.message[index]
                                                .status),
                                            buttonColor: selectColor(
                                                SelectColor.DEFAULT),
                                            bottomTextColor: colorStatus(cubit
                                                .activitiesModel
                                                ?.message[index]
                                                .status)['color'],
                                            widget: selectImage(cubit
                                                .activitiesModel
                                                ?.message[index]
                                                .status),
                                            onTap: () {
                                              activitiesAndSettlementAndExpensesDetails(
                                                  attachedFile: cubit
                                                      .activitiesModel
                                                      ?.message[index]
                                                      .attachFiles,
                                                  taskName: cubit
                                                          .activitiesModel
                                                          ?.message[index]
                                                          .activityName ??
                                                      "",
                                                  context: context,
                                                  title: "activitiesDetails".i18n(),
                                                  stateText: textStatus(cubit
                                                      .activitiesModel
                                                      ?.message[index]
                                                      .status),
                                                  buttonTitle: "Close",
                                                  type: "activityType".i18n(),
                                                  typeValue: cubit
                                                      .activitiesModel!
                                                      .message[index]
                                                      .typeExpense
                                                      .toString(),
                                                  clientName: cubit
                                                      .activitiesModel!
                                                      .message[index]
                                                      .lead
                                                      .toString(),
                                                  amount: cubit
                                                      .activitiesModel!
                                                      .message[index]
                                                      .advanceAmount
                                                      .toString(),
                                                  comment: cubit
                                                      .activitiesModel!
                                                      .message[index]
                                                      .purpose
                                                      .toString(),
                                                  color: colorStatus(cubit.activitiesModel?.message[index].status)['color'],
                                                  colors: colorStatus(cubit.activitiesModel?.message[index].status)['colors'],
                                                  dateTime: cubit.activitiesModel!.message[index].postingDate.toString());
                                            }),
                                  ),
                                )
                              ],
                            );
                    },
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )),
                ],
              ),
              floatingActionButton: custFloatingAction(onTap: () {
                newActivityAndNewExpensesDialog(
                  context: context,
                  title: "newActivity".i18n(),
                  type: "activityType".i18n(),
                  typeName: cubit.activityName,
                  typeValue: cubit.advanceTypesModel?.message ?? [],
                  buttonTitle: "submit".i18n(),
                  color: primaryColor,
                  amount: cubit.amount,
                  client: cubit.client,
                  commentAndAttachFile: BlocProvider.value(
                    value: BlocProvider.of<ActivitiesCubit>(context),
                    child: BlocBuilder<ActivitiesCubit, ActivitiesStates>(
                        builder: (context, state) {
                      return CustCommentTextField(
                        onTap: () {
                          cubit.getAttachFile();
                        },
                        controller: cubit.comment,
                        attachedFile: cubit.attachFile,
                      );
                    }),
                  ),
                  stateText: BlocProvider.value(
                    value: BlocProvider.of<ActivitiesCubit>(context),
                    child: BlocBuilder<ActivitiesCubit, ActivitiesStates>(
                      builder: (context, state) {
                        return Text(
                          cubit.activitySelected ??
                              cubit.advanceTypesModel!.message[0].name
                                  .toString(),
                          style: const TextStyle(
                              fontFamily: FontFamilyStrings.ARIAL_REGULAR,
                              fontSize: 16,
                              color: Color(0xffA8ACAF)),
                        );
                      },
                    ),
                  ),
                  colors: selectGradientColor(SelectColor.DEFAULT),
                  onTap: () {
                    cubit.addNewActivity(context);
                  },
                  onSelectedClient: (val) => cubit.client.text = val,
                  onSelection: (value) {
                    cubit.changeActivitySelection(value);
                  },
                );
              }));
        },
      ),
    );
  }
}
