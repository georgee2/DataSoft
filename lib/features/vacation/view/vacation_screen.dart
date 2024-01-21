import 'package:data_soft/features/vacation/view_model/cubit/vacation_cubit.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import '../../../core/app_datetime.dart';
import '../../../core/app_dialogs.dart';
import '../../../core/constants.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class VacationScreen extends StatelessWidget {
  VacationScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => VacationCubit()
        ..getVacationsTypes(),
      child: BlocBuilder<VacationCubit, VacationStates>(
        builder: (context, state) {
          var cubit = VacationCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(),
              endDrawer: const DrawerScreen(
                screenName: "Vacation",
              ),
              body: Column(children: [
                CustAppBarWithClip(
                    title: "vacationTitle".i18n(),
                    scaffoldKey: scaffoldKey,
                    imageSrc: 'vacation_icon',
                    widget: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "yourBalance".i18n(),
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: CircleAvatar(
                                radius: 50,
                                backgroundColor: primaryColor,
                                child: Container(
                                    height: 98,
                                    width: 98,
                                    padding: const EdgeInsets.all(8),
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                        shape: const CircleBorder(),
                                        color: const Color(0xffDDEFFE)
                                            .withOpacity(0.8)
                                        ),
                                    child: cubit.balance == null ||
                                            cubit.vacationModel
                                                    ?.totalVacationDays ==
                                                null
                                        ? const Center(
                                            child: CupertinoActivityIndicator(),
                                          )
                                        : Column(
                                            children: [
                                              Expanded(
                                                  child: FittedBox(
                                                      child: Text(
                                                cubit.totalBalance??"",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor),
                                              ))),
                                              Text(
                                                "days".i18n(),
                                                style: const TextStyle(
                                                    color: primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ))),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    cubit.vacationTypeSelected ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                PopupMenuButton(
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: const Color(0xff727C8E)
                                        .withOpacity(0.4),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  itemBuilder: (context) =>
                                      cubit.vacationsTypeModel!.message
                                          .map((e) => PopupMenuItem(
                                              onTap: () {
                                                cubit.getBalance(e.name);
                                              },
                                              child: Text(e.name.toString())))
                                          .toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ["all".i18n(), "approved".i18n(), "reject".i18n(), "pending".i18n()]
                      .map((e) => TextButton(
                          onPressed: () {
                            cubit.changeViewType(e);
                          },
                          child: Text(
                            e,
                            style: TextStyle(
                                color: e == cubit.viewType
                                    ? primaryColor
                                    : Colors.grey),
                          )))
                      .toList(),
                ),
                Expanded(
                  child: ConditionalBuilder(
                    condition: cubit.vacationModel != null,
                    builder: (context) {
                      return cubit.vacationModel!.message.isEmpty
                          ? noDataFound(context, type: "Settlement")
                          : ListView.builder(
                              itemCount: cubit.vacationModel!.message.length,
                              itemBuilder: (context, index) => ContentWidget(
                                topText: cubit
                                    .vacationModel!.message[index].leaveType,
                                centerText: cubit.vacationModel!.message[index]
                                    .totalLeaveDays,
                                bottomText: cubit.vacationModel!.message[index]
                                            .status ==
                                        "Open"
                                    ? "Pending"
                                    : cubit
                                        .vacationModel!.message[index].status,
                                bottomTextColor: colorStatus(cubit
                                    .vacationModel!
                                    .message[index]
                                    .status)['color'],
                                buttonTitle: "details".i18n(),
                                buttonColor: selectColor(SelectColor.DEFAULT),
                                widget: DateWidgets(
                                    year: DateTimeFormating.formatCustomDate(
                                        date: cubit.vacationModel!
                                                .message[index].postingDate ??
                                            DateTime.now(),
                                        formatType: "yyyy"),
                                    month: DateTimeFormating.formatCustomDate(
                                        date: cubit.vacationModel!
                                                .message[index].postingDate ??
                                            DateTime.now(),
                                        formatType: "MMM"),
                                    day: DateTimeFormating.formatCustomDate(
                                        date: cubit.vacationModel!
                                                .message[index].postingDate ??
                                            DateTime.now(),
                                        formatType: "dd")),
                                onTap: () {
                                  cubit.vacationDetails(context, index);
                                },
                              ),
                            );
                    },
                    fallback: (context) =>
                        const Center(child: CupertinoActivityIndicator()),
                  ),
                )
              ]),
              floatingActionButton: custFloatingAction(onTap: () {
                newVacationDialog(
                  context,
                );
              }));
        },
      ),
    );
  }

  newVacationDialog(
    context,
  ) {
    dialogFrameSingleButton2(
      context: context,
      buttonColor: primaryColor,
      title: "yourBalance".i18n(),
      buttonTitle: 'submit'.i18n(),
      colors: selectGradientColor(SelectColor.DEFAULT),
      action: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocProvider.value(
            value: BlocProvider.of<VacationCubit>(context),
            child: BlocConsumer<VacationCubit, VacationStates>(
              listener: (context, state) {},
              builder: (context, state) {
                var cubit = VacationCubit.get(context);
                return Text(cubit.totalBalance??"",
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white));
              },
            ),
          ),
          Text("days".i18n(), style: const TextStyle(color: Colors.white))
        ],
      ),
      child: BlocProvider.value(
        value: BlocProvider.of<VacationCubit>(context),
        child: BlocConsumer<VacationCubit, VacationStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = VacationCubit.get(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "newVacation".i18n(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "vacationType".i18n(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Wrap(
                      children: [
                        Text(
                          cubit.addVacationTypeSelected ??
                              cubit.vacationsTypeModel!.message[0].name
                                  .toString(),
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xffA8ACAF)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        PopupMenuButton(
                          child: imageSvg(src: "arrow_down", size: 25),
                          itemBuilder: (context) =>
                              cubit.vacationsTypeModel!.message
                                  .map((e) => PopupMenuItem(
                                      onTap: () {
                                        cubit.getBalance(e.name);
                                      },
                                      child: Text(e.name.toString())))
                                  .toList(),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "date".i18n(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          cubit.chooseDate(context);
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            border: Border.all(color: Colors.grey, width: 0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              imageSvg(src: 'calendar_event', size: 24),
                              Expanded(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      cubit.fullDate,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        border: Border.all(color: Colors.grey, width: 0.5),
                      ),
                      child: Text("${cubit.vacationDays} DAYS"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustCommentTextField(
                  onTap: () {
                    cubit.getAttachFile();
                  },
                  controller: cubit.commentController,
                  attachedFile: cubit.attachFile,
                ),
              ],
            );
          },
        ),
      ),
      onTap: () {
        VacationCubit.get(context).postNewVacation(context);
      },
    );
  }
}
