import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';
import '../../../core/app_datetime.dart';
import '../../../core/app_dialogs.dart';
import '../../../core/app_fonts.dart';
import '../../drawer/drawer_sceen.dart';
import '../view_model/cubit/permissions_cubit.dart';

class PermissionsScreen extends StatelessWidget {
  PermissionsScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionsCubit()
        ..getPermissions()
        ..getPermissionsTypes(),
      child: BlocBuilder<PermissionsCubit, PermissionsStates>(
        builder: (context, state) {
          var cubit = PermissionsCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            endDrawer: const DrawerScreen(
              screenName: "Permissions",
            ),
            body: Column(
              children: [
                CustAppBar(
                  title: "Permissions",
                  scaffoldKey: scaffoldKey,
                  imageSrc: 'settlement_icon',
                ),
                Expanded(
                    child: ConditionalBuilder(
                  condition: cubit.permissionsModel != null,
                  builder: (context) {
                    return cubit.permissionsModel!.message!.permissions.isEmpty
                        ? noDataFound(context, type: "Permissions")
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  decoration:
                                      BoxDecoration(color: bgColor, boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0.0, 3),
                                        blurRadius: 6,
                                        color: Colors.black.withOpacity(0.3))
                                  ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Good Morning, ",
                                              style: TextStyle(fontSize: 14)),
                                          Text(userData!.fullName!,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 0),
                                        child: Text("Today",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff7646FF))),
                                      ),
                                      Row(
                                        children: [
                                          imageSvg(src: 'calendar_event'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            DateTimeFormating.formatCustomDate(
                                                date: DateTime.now(),
                                                formatType: 'dd MMM yyyy'),
                                            style: const TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 50,
                                    color: const Color(0xffEBEEF1),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Permissions",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    )),
                                ...cubit.permissionsModel!.message!.permissions
                                    .map((e) {
                                  final from = DateFormat('h:mm a').format(
                                      DateFormat('yyyy-mmmm-dd HH:mm').parse(
                                          e.fromTime ?? "2023-09-20 11:00:24"));
                                  final to = DateFormat('h:mm a').format(
                                      DateFormat('yyyy-mmmm-dd HH:mm').parse(
                                          e.toTime ?? "2023-09-20 11:00:24"));
                                  return Container(
                                    margin:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            20, 15, 20, 0),
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: const Color(0xffDDEFFE),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0.0, 3),
                                              blurRadius: 5,
                                              color:
                                                  Colors.black.withOpacity(0.3))
                                        ]),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Center(
                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 12.5,
                                                      color: secondryColor,
                                                    ),
                                                  ),
                                                  Text(" $from To $to",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: primaryColor,
                                                      ))
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(start: 15),
                                                child: Text(
                                                  e.permissionType ?? "",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xffA8ACAF)),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 7.5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    size: 12.5,
                                                    color: colorStatus(
                                                        e.status)['color'],
                                                  ),
                                                  Text(
                                                      " ${textStatus(e.status)}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: colorStatus(
                                                            e.status)['color'],
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        PrimaryButton(
                                          title:
                                              DateTimeFormating.calculateHours(
                                                  e.toTime ??
                                                      "2023-09-20 11:00:24",
                                                  e.fromTime ??
                                                      "2023-09-20 11:00:24"),
                                          color: secondryColor,
                                          onTap: null,
                                        )
                                      ],
                                    ),
                                  );
                                }),
                                const SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                          );
                  },
                  fallback: (context) => const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ))
              ],
            ),
            floatingActionButton: custFloatingAction(onTap: () {
              cubit.initTime(context);
              addPermissionDialog(context, cubit);
            }),
          );
        },
      ),
    );
  }
}

addPermissionDialog(context, PermissionsCubit cubit) {
  dialogFrameSingleButton(
    onTap: () {
      cubit.addPermission(context);
    },
    context: context,
    title: "NEW PERMISSIONS",
    buttonTitle: "SUBMIT",
    buttonColor: primaryColor,
    colors: selectGradientColor(SelectColor.DEFAULT),
    child: BlocProvider.value(
      value: BlocProvider.of<PermissionsCubit>(context),
      child: BlocBuilder<PermissionsCubit, PermissionsStates>(
        builder: (context, state) {
          var cubit = PermissionsCubit.get(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New Permissions",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamilyStrings.ROBOTO_BOLD,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff515C6F),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        cubit.permissionsSelected,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: FontFamilyStrings.ROBOTO_MEDIUM,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      PopupMenuButton(
                        child: imageSvg(src: "arrow_down", size: 23),
                        itemBuilder: (context) => cubit
                            .permissionsTypes!.message
                            .map((e) => PopupMenuItem(
                                onTap: () {
                                  cubit.selectPermissionType(e.name.toString());
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
              const Text(
                "Time",
                style: TextStyle(fontSize: 16, color: Color(0xff515C6F)),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "From",
                    style: TextStyle(fontSize: 16, color: Color(0xff515C6F)),
                  ),
                  GestureDetector(
                    onTap: () {
                      cubit.setFromTime(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          border: border,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        cubit.fromTime,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xff515C6F)),
                      ),
                    ),
                  ),
                  verticalLine(height: 40, color: secondryColor),
                  const Text("To",
                      style: TextStyle(fontSize: 16, color: Color(0xff515C6F))),
                  GestureDetector(
                    onTap: () {
                      cubit.setToTime(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          border: border,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        cubit.toTime,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xff515C6F)),
                      ),
                    ),
                  ),
                ],
              ),
              CustCommentTextField(
                controller: cubit.comment,
                onTap: () {
                  cubit.getAttachFile();
                },
                attachedFile: cubit.attachFile,
              )
            ],
          );
        },
      ),
    ),
  );
}
