import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/media_query_values.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import '../../plans/widgets/plans_widgets.dart';
import '../view_model/cubit/planning_cubit.dart';

class PlanningScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  PlanningScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (contextt) => PlanningCubit()
        ..getMedicalSpecialties()
        ..getAllClients()
        ..getPlanningClms(),
      child: BlocBuilder<PlanningCubit, PlanningStates>(
        builder: (contextt, state) {
          var cubit = PlanningCubit.get(contextt);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            endDrawer: const DrawerScreen(
              screenName: "Create Plan",
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    CustAppBar(
                      title: "createPlan".i18n(),
                      scaffoldKey: scaffoldKey,
                      imageSrc: 'visits_icon',
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: Row(
                                    children: [
                                      imageSvg(
                                          src: "calendar_icon",
                                          color: const Color(0xff2699FB)),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: FittedBox(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: PlanSelectDateTime(
                                            onTap: () {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime(2025))
                                                  .then((value) {
                                                if (value != null) {
                                                  cubit.changeDateTime(value);
                                                }
                                              });
                                            },
                                            time: cubit.dateTime,
                                            title: null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.circle,
                                size: 10,
                                color: primaryColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "planned".i18n(),
                                style: const TextStyle(
                                    fontSize: 18, color: primaryColor),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: imageSvg(src: "back_icon", size: 20),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: TextField(
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: "searchSomething".i18n(),
                                    prefixIcon: const Icon(Icons.search),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 8),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  controller: cubit.search,
                                  onChanged: (value) {
                                    cubit.searchForClients();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          PlanningFilteringContainer(
                                              contextt: contextt),
                                    );
                                  },
                                  child:
                                      imageSvg(src: "filter_icon", size: 20)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "lastVisit".i18n(),
                            "firstTime".i18n(),
                            "amOnly".i18n(),
                            "pmOnly".i18n(),
                          ]
                              .map((e) => TextButton(
                                    onPressed: () {
                                      cubit.changeScreenTypeState(e);
                                    },
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          color: cubit.screenType == e
                                              ? primaryColor
                                              : Colors.grey.withOpacity(0.6)),
                                    ),
                                  ))
                              .toList(),
                        ),
                        Container(
                          height: 35,
                          width: double.infinity,
                          color: primaryColor.withOpacity(0.15),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 35, end: 20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                    value: cubit.isAllSelection,
                                    onChanged: (value) {
                                      cubit.changeAllClientSelectionState(
                                          type: true);
                                    },
                                  ),
                                  Expanded(
                                      child: Text(
                                    "selectAll".i18n(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  )),
                                  TextButton(
                                      onPressed: () {
                                        cubit.changeAllClientSelectionState(
                                            type: false);
                                      },
                                      child: Text("clear".i18n(),
                                          style:
                                              const TextStyle(color: Colors.blue))),
                                ]),
                          ),
                        ),
                        ConditionalBuilder(
                          condition: cubit.planningModel != null,
                          builder: (context) {
                            return cubit.planningModel!.data.isEmpty
                                ? noDataFound(context, type: "Clients")
                                : cubit.search.text.trim().isEmpty
                                    ? ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            cubit.planningModel?.data.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => Card(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4),
                                          child: ListTile(
                                            leading: Checkbox(
                                                value: cubit.planningModel!
                                                    .data[index].isSelected,
                                                onChanged: (val) {
                                                  cubit.changeClientSelection(
                                                      val, index);
                                                }),
                                            title: Text(cubit.planningModel!
                                                .data[index].customerName
                                                .toString()),
                                            subtitle: Text(cubit.planningModel!
                                                .data[index].medicalSpecialty
                                                .toString()),
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: cubit.searchList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) => Card(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4),
                                          child: ListTile(
                                            leading: Checkbox(
                                                value: cubit.searchList[index]
                                                    .isSelected,
                                                onChanged: (val) {
                                                  cubit.changeClientSelection(
                                                      val, index);
                                                }),
                                            title: Text(cubit
                                                .searchList[index].customerName
                                                .toString()),
                                            subtitle: Text(cubit
                                                .searchList[index]
                                                .medicalSpecialty
                                                .toString()),
                                          ),
                                        ),
                                      );
                          },
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        )
                      ]),
                    )),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
                if (!context.isVisible)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 40),
                    child: SecondryButton(
                        color: primaryColor,
                        title: "createPlan".i18n(),
                        onTap: () {
                          if (cubit.planningClms != null) {
                            cubit.addNewPlan();
                          } else {
                            cubit.addNewPlan();
                          }
                        }),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}

class PlanningFilteringContainer extends StatelessWidget {
  const PlanningFilteringContainer({super.key, required this.contextt});
  final BuildContext contextt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 220,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: (context.height - 200) * 0.85,
                    width: context.width * 0.2,
                    color: Colors.transparent,
                  ),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<PlanningCubit>(contextt),
                  child: BlocBuilder<PlanningCubit, PlanningStates>(
                    builder: (contextt, state) {
                      var cubit = PlanningCubit.get(contextt);
                      return Container(
                        height: (context.height - 200) * 0.85,
                        width: context.width * 0.8,
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 25),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "refineResults".i18n(),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                TextButton(
                                    onPressed: () {
                                      cubit.getAllClients();
                                    },
                                    child: Text("clear".i18n(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: secondryColor)))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FilterContent(
                                title: "time".i18n(),
                                result: cubit.timeSelected ?? "All",
                                onSelect: (value) {
                                  cubit.changeClientTimeFiltering(value);
                                },
                                items: ["all".i18n(), "amOnly".i18n(), "pmOnly".i18n()]),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "medicalSpecialty".i18n(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: PopupMenuButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  cubit.medicalSpecialtySelected ??
                                                      "All",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: imageSvg(
                                                  src: 'arrow_down', size: 20),
                                            ),
                                          ],
                                        ),
                                        itemBuilder: (context) => cubit
                                            .medicalSpecialtyModel!.message
                                            .map((e) => PopupMenuItem(
                                                onTap: () {
                                                  cubit
                                                      .changeClientMedicalSpecialtyFiltering(
                                                          e.name);
                                                },
                                                child: Text(e.name.toString())))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                            FilterContent(
                                title: "location".i18n(),
                                result: cubit.citySelected ?? "All",
                                onSelect: (value) {
                                  cubit.changeClientLocationSelectedFiltering(
                                      value);
                                },
                                items: cubit.planningModel?.city ?? []),
                            Expanded(
                                child: Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () {
                                  cubit.getAllClients(
                                      leadTime: cubit.timeSelected,
                                      medicalSpecialty:
                                          cubit.medicalSpecialtySelected,
                                      city: cubit.citySelected);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    height: 45,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: secondryColor),
                                    child: Row(children: [
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.center,
                                        child: Text("applyFilters".i18n(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      )),
                                      imageSvg(
                                          src: "apply_filter_icon", size: 25)
                                    ])),
                              ),
                            ))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
