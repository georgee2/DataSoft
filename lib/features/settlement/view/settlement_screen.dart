import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/features/settlement/view_model/cubit/settlement_cubit.dart';
import 'package:data_soft/features/settlement/widgets/components.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import '../../../core/app_dialogs.dart';
import '../../../core/constants.dart';
import '../model/settlement_model.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';

class SettlementScreen extends StatelessWidget {
  SettlementScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettlementCubit()..getSettlement(),
      child: BlocBuilder<SettlementCubit, SettlementStates>(
        builder: (context, state) {
          var cubit = SettlementCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            endDrawer: const DrawerScreen(
              screenName: "Settlement",
            ),
            body: Column(
              children: [
                CustAppBar(
                  title: 'settlementTitle'.i18n(),
                  scaffoldKey: scaffoldKey,
                  imageSrc: 'settlement_icon',
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ["all".i18n(), "approved".i18n(), "reject".i18n(), "pending".i18n()]
                        .map((e) => TextButton(
                            onPressed: () {
                              cubit.changeScreenType(e);
                            },
                            child: Text(
                              e,
                              style: TextStyle(
                                  color: cubit.screenType == e
                                      ? secondryColor
                                      : Colors.grey),
                            )))
                        .toList()),
                Expanded(
                    child: ConditionalBuilder(
                  condition: cubit.settlementModel != null,
                  builder: (context) {
                    return cubit.settlementModel!.message!.data.isEmpty
                        ? noDataFound(context, type: "Settlement")
                        : ListView.builder(
                            itemCount:
                                cubit.settlementModel?.message?.data.length,
                            itemBuilder: (context, index) {
                              SettlementDataModel item =
                                  cubit.settlementModel!.message!.data[index];
                              return ContentWidget(
                                buttonTitle: "details".i18n(),
                                buttonColor: selectColor(SelectColor.DEFAULT),
                                widget: selectDollar(item.status.toString()),
                                topText:
                                    item.expenses?[0].expenseType.toString(),
                                bottomText: textStatus(item.status.toString()),
                                bottomTextColor:
                                    colorStatus(item.status)['color'],
                                centerText: item.expenses?[0].amount.toString(),
                                centerTitleType: "LE",
                                onTap: () {
                                  activitiesAndSettlementAndExpensesDetails(
                                    taskName: item.taskName??"",
                                    attachedFile: item.attachFile,
                                      context: context,
                                      title: "SETTLEMENT DETAILS",
                                      stateText:
                                          textStatus(item.status.toString()),
                                      type: "settlementType".i18n(),
                                      typeValue: item.typeExpense.toString(),
                                      buttonTitle: "close".i18n(),
                                      color: colorStatus(item.status)['color'],
                                      colors:
                                          colorStatus(item.status)['colors'],
                                      amount:
                                          item.expenses![0].amount.toString(),
                                      ishaveClient: false,
                                      dateTime: item.postingDate.toString(),
                                      comment: item.comment.toString());
                                },
                              );
                            },
                          );
                  },
                  fallback: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ))
              ],
            ),
            floatingActionButton: custFloatingAction(onTap: () {
              newSettlementDialog(context: context);
            }),
          );
        },
      ),
    );
  }
}
