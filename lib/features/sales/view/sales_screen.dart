import 'package:data_soft/features/sales/widgets/components.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/media_query_values.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import '../view_model/cubit/sales_cubit.dart';

class SalesScreen extends StatelessWidget {
  SalesScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const DrawerScreen(
        screenName: "Sales",
      ),
      appBar: AppBar(),
      body: BlocProvider(
        create: (contextt) => SalesCubit()
          ..getDistributions()
          ..getProducts(),
        child: BlocBuilder<SalesCubit, SalesStates>(
          builder: (contextt, state) {
            var cubit = SalesCubit.get(contextt);
            return Column(children: [
              CustAppBar(
                  title: "salesTitle".i18n(),
                  scaffoldKey: scaffoldKey,
                  imageSrc: "sales_icon"),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConditionalBuilder(
                    condition: cubit.salesProductModel != null,
                    builder: (context) {
                      return Column(
                        children: [
                          Card(
                            margin: EdgeInsets.zero,
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "tapForPeriodOfSales".i18n(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FromAndToDateTimeContainer(
                                            onTap: () {
                                              cubit.changeDate(contextt);
                                            },
                                            time: cubit.fromDate == null ||
                                                    cubit.toDate == null
                                                ? "chooseDate".i18n()
                                                : "${DateTimeFormating.formatMonthDate(cubit.fromDate)} - ${DateTimeFormating.formatCustomDate(date: cubit.toDate, formatType: "dd MMM, yyyy")}"),
                                        GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    FilteringContainer(
                                                        contextt: contextt),
                                              );
                                            },
                                            child: imageSvg(
                                                src: "filter_icon", size: 25))
                                      ],
                                    )
                                  ]),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Row(children: [
                                SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: donutChart(
                                        red: cubit.isUintData
                                            ? cubit.salesProductModel!.message!
                                                .totalUnit
                                            : cubit.salesProductModel!.message!
                                                .totalValue,
                                        green: cubit.isUintData
                                            ? cubit.salesProductModel!.message!
                                                .targetUnit
                                            : cubit.salesProductModel?.message
                                                    ?.totalValue ??
                                                0)),
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "totalCombined".i18n(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                child: Text("achievement".i18n())),
                                            Text(
                                              numbersFormat(cubit.isUintData
                                                  ? cubit.salesProductModel!
                                                      .message!.totalUnit
                                                  : cubit.salesProductModel!
                                                      .message!.totalValue),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff21D59B)),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                                cubit.isUintData
                                                    ? "Unit"
                                                    : "EGP",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                child: Text(cubit.isUintData
                                                    ? "Target Units"
                                                    : "targetValue".i18n())),
                                            Text(
                                              numbersFormat(cubit.isUintData
                                                  ? cubit.salesProductModel!
                                                      .message!.targetUnit
                                                  : cubit.salesProductModel!
                                                      .message!.totalTarget),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                                cubit.isUintData
                                                    ? "Unit"
                                                    : "EGP",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                          const DistrictPharmacies()
                        ],
                      );
                    },
                    fallback: (context) => Container(
                      height: context.height * .8,
                      width: context.width,
                      alignment: Alignment.center,
                      child: const CupertinoActivityIndicator(),
                    ),
                  ),
                ),
              )
            ]);
          },
        ),
      ),
    );
  }
}

class FilteringContainer extends StatelessWidget {
  const FilteringContainer({super.key, required this.contextt});
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
                height: 198,
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
                    height: (context.height - 200) * 0.8,
                    width: context.width * 0.3,
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  height: (context.height - 150) * 0.8,
                  width: context.width * 0.7,
                  padding: const EdgeInsets.fromLTRB(15, 0, 10, 25),
                  color: Colors.white,
                  child: BlocProvider.value(
                    value: BlocProvider.of<SalesCubit>(contextt),
                    child: BlocConsumer<SalesCubit, SalesStates>(
                      listener: (contextt, state) {},
                      builder: (contextt, state) {
                        var cubit = SalesCubit.get(contextt);
                        return Column(
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
                                      cubit.getProducts();
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Value",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600),
                                ),
                                Radio(
                                  value: false,
                                  groupValue: cubit.isUintData,
                                  onChanged: (value) {
                                    cubit.changeUintsData(value);
                                  },
                                ),
                                Text(
                                  "Unit",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600),
                                ),
                                Radio(
                                  value: true,
                                  groupValue: cubit.isUintData,
                                  onChanged: (value) {
                                    cubit.changeUintsData(value);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FilterContent(
                                title: "time".i18n(),
                                result: cubit.timeSelected ?? "All",
                                onSelect: (value) {
                                  cubit.changeFilterTime(value);
                                },
                                items: ["all".i18n(), "amOnly".i18n(), "pmOnly".i18n()]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "products".i18n(),
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              cubit.product2?.productName ??
                                                  "All",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: imageSvg(
                                              src: 'arrow_down', size: 20),
                                        ),
                                      ],
                                    ),
                                    itemBuilder: (context) => cubit.productsList
                                        .map((e) => PopupMenuItem(
                                            onTap: () {
                                              cubit.changeFilterProduct(e);
                                            },
                                            child:
                                                Text(e.productName.toString())))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FilterContent(
                                title: "brick".i18n(),
                                result: cubit.birckSelected ?? "All",
                                onSelect: (value) {
                                  cubit.changeFilterBrick(value);
                                },
                                items: cubit.brickList),
                            FilterContent(
                                title: "distributors".i18n(),
                                result: cubit.distributionSelected ?? "All",
                                onSelect: (value) {
                                  cubit.changeFilterDistributor(value);
                                },
                                items: cubit.distributionModel != null &&
                                        cubit.distributionModel?.message?.data
                                                .length !=
                                            1
                                    ? cubit.distributionModel!.message!.data
                                    : []),
                            Expanded(
                                child: Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () {
                                  cubit.getProducts(isFilttering: false);
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
                        );
                      },
                    ),
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
