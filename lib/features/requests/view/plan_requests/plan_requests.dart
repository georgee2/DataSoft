import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_datetime.dart';
import '../../../../core/app_fonts.dart';
import '../../../../core/app_switches.dart';
import '../../../../core/constants.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../drawer/drawer_sceen.dart';
import '../../model/request_details_model.dart';
import '../../view_model/cubit/requests_cubit.dart';
import '../../widgets/requests_widgets.dart';

class RepRequests extends StatelessWidget {
  RepRequests({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(),
        endDrawer: const DrawerScreen(
          screenName: "Requests",
        ),
        body: Column(
          children: [
            CustAppBar(
                title: "Requests",
                scaffoldKey: scaffoldKey,
                imageSrc: "requests_icon"),
            Expanded(
              child: BlocProvider(
                create: (contextt) => RequestsCubit()
                  ..changeStatus("Opportunity", "In Review", null),
                child: BlocBuilder<RequestsCubit, RequestsState>(
                  builder: (contextt, state) {
                    var cubit = RequestsCubit.get(contextt);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
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
                                    const Text(
                                      "Dates",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily:
                                              FontFamilyStrings.ROBOTO_REGULAR,
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
                                      cubit.changeDate(
                                          context, cubit.screenType);
                                    },
                                    time: cubit.fullDate == null
                                        ? "Choose date.."
                                        : cubit.fullDate!),
                              ],
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.zero,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: ["In Review", "Approved", "Rejected"]
                                    .map(
                                      (e) => TextButton(
                                          onPressed: () {
                                            cubit.changeStatus(
                                                "Opportunity", e, null);
                                          },
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: cubit.screenType == e
                                                    ? secondryColor
                                                    : Colors.grey),
                                          )),
                                    )
                                    .toList()),
                          ),
                          ConditionalBuilder(
                            condition:
                                cubit.requestsData.isNotEmpty || cubit.isEmpty,
                            builder: (context) => cubit.isEmpty ||
                                    cubit.repsData.isEmpty
                                ? Container(
                                    alignment: Alignment.center,
                                    height: context.height * .5,
                                    child: noDataFound(context, type: "Reps"))
                                : ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cubit.repsData.length,
                                    itemBuilder: (cubitContext, index) {
                                      final item = cubit.repsData[index];
                                      return Card(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 10),
                                        child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                custProviderNetWorkImage(
                                                  image: item.image,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child:
                                                        Text(item.name ?? "")),
                                                PrimaryButton(
                                                  title: "View Plans",
                                                  color: approvedColor,
                                                  onTap: () {
                                                    cubit.plansFiltering(cubit
                                                        .repsData[index].data);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              VisitsRequests(
                                                            contextt: contextt,
                                                            repIndex: index,
                                                          ),
                                                        ));
                                                  },
                                                ),
                                              ],
                                            )),
                                      );
                                    },
                                  ),
                            fallback: (context) => SizedBox(
                                height: context.height * .5,
                                child: const Center(
                                    child: CircularProgressIndicator())),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}

class VisitsRequests extends StatelessWidget {
  VisitsRequests({super.key, required this.contextt, required this.repIndex});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final BuildContext contextt;
  final int repIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(),
        endDrawer: const DrawerScreen(
          screenName: "Requests",
        ),
        body: Column(
          children: [
            CustAppBar(
                title: "Requests",
                scaffoldKey: scaffoldKey,
                imageSrc: "requests_icon"),
            Expanded(
              child: BlocProvider.value(
                value: BlocProvider.of<RequestsCubit>(contextt),
                child: BlocBuilder<RequestsCubit, RequestsState>(
                  builder: (contextt, state) {
                    var cubit = RequestsCubit.get(contextt);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.only(bottom: 4),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 15, 20, 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(contextt);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: imageSvg(
                                            src: "back_icon", size: 20),
                                      )),
                                  Expanded(
                                      child: Text(
                                    cubit.plansData.isNotEmpty
                                        ? cubit.plansData[0]['data'][0].repName
                                        : "",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          ConditionalBuilder(
                            condition:
                                cubit.requestsData.isNotEmpty || cubit.isEmpty,
                            builder: (context) => cubit.isEmpty ||
                                    cubit.plansData.isEmpty
                                ? Container(
                                    alignment: Alignment.center,
                                    height: context.height * .5,
                                    child: noDataFound(context, type: "Plans"))
                                : ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cubit.plansData.length,
                                    itemBuilder: (cubitContext, index) {
                                      final item = cubit.plansData[index];
                                      return ContentWidget(
                                        buttonTitle: "View",
                                        centerTitleType: "Visits",
                                        centerText:
                                            item['data'].length.toString(),
                                        bottomTextColor: colorStatus(
                                            item['status_plan'])['color'],
                                        bottomText:
                                            textStatus(item['status_plan']),
                                        buttonColor: primaryColor,
                                        widget: DateWidgets(
                                            year: DateTimeFormating
                                                .formatCustomDate(
                                                    date: item[
                                                        'transaction_date'],
                                                    formatType: "yyyy"),
                                            month: DateTimeFormating
                                                .formatCustomDate(
                                                    date: item[
                                                        'transaction_date'],
                                                    formatType: "MMM"),
                                            day: DateTimeFormating
                                                .formatCustomDate(
                                                    date: item[
                                                        'transaction_date'],
                                                    formatType: "dd")),
                                        onTap: () {
                                          cubit.requestsData
                                              .addAll(item['data']);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlanScreen(
                                                        data: item['data'],
                                                        contextt: contextt,
                                                        indexx: index,
                                                        repIndex: repIndex,
                                                      )));
                                        },
                                      );
                                    },
                                  ),
                            fallback: (context) => SizedBox(
                                height: context.height * .5,
                                child: const Center(
                                    child: CircularProgressIndicator())),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}

class PlanScreen extends StatelessWidget {
  PlanScreen(
      {super.key,
      required this.data,
      required this.contextt,
      required this.indexx,
      required this.repIndex});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<RequestsDetailsModel> data;
  final BuildContext contextt;
  final int indexx;
  final int repIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(
        screenName: "Requests",
      ),
      body: Column(
        children: [
          CustAppBar(
              title: "Requests",
              scaffoldKey: scaffoldKey,
              imageSrc: "requests_icon"),
          Expanded(
            child: BlocProvider.value(
              value: BlocProvider.of<RequestsCubit>(contextt)
                ..initVisitsData(data),
              child: BlocBuilder<RequestsCubit, RequestsState>(
                builder: (contextt, state) {
                  var cubit = RequestsCubit.get(contextt);
                  return Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 20, 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(contextt);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: imageSvg(
                                            src: "back_icon", size: 20),
                                      )),
                                  Expanded(
                                      child: Text(
                                    cubit.visitsItem.isNotEmpty
                                        ? DateTimeFormating.formatCustomDate(
                                            date:
                                                cubit.visitsItem[0].postingDate,
                                            formatType: "dd MMM yyyy")
                                        : "",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor),
                                  )),
                                  Text(
                                    cubit.isSelectAll
                                        ? "Unselect All"
                                        : "Select All",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Checkbox(
                                    value: cubit.isSelectAll,
                                    onChanged: (value) {
                                      cubit.changeSelectionItems();
                                    },
                                  )
                                ],
                              ),
                              if (cubit.selectionMode)
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          cubit.updateAllItems(
                                              repIndex, context, true, indexx);
                                        },
                                        style: ButtonStyle(
                                            minimumSize:
                                                MaterialStatePropertyAll(Size(
                                                    context.width * .3, 50)),
                                            backgroundColor:
                                                const MaterialStatePropertyAll(
                                                    approvedColor)),
                                        child: const Text(
                                          "ACCEPT",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          cubit.updateAllItems(
                                              repIndex, context, false, indexx);
                                        },
                                        style: ButtonStyle(
                                            minimumSize:
                                                MaterialStatePropertyAll(Size(
                                                    context.width * .3, 50)),
                                            backgroundColor:
                                                const MaterialStatePropertyAll(
                                                    rejectedColor)),
                                        child: const Text(
                                          "REJECT",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: cubit.visitsItem.isEmpty
                            ? noDataFound(context, type: "Visits")
                            : ListView.builder(
                                itemCount: cubit.visitsItem.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            15, 10, 10, 10),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 8, 20, 8),
                                      child: Row(children: [
                                        Checkbox(
                                          value: cubit
                                              .visitsItem[index].isSelected,
                                          onChanged: (value) {
                                            cubit.singleItemSelection(
                                                index, value!);
                                          },
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cubit.visitsItem[index].clientName
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily: FontFamilyStrings
                                                      .ROBOTO_BOLD,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        )),
                                        Container(
                                            width: 1,
                                            height: 50,
                                            color: primaryColor),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        PrimaryButton(
                                            color: const Color(0xff13B824),
                                            title: "Details",
                                            onTap: () {
                                              requestsDialog(
                                                  contextt: contextt,
                                                  requestsDetailsModel:
                                                      cubit.visitsItem[index],
                                                  docType: "Opportunity");
                                            })
                                      ]),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
