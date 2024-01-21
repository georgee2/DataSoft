import 'package:localization/localization.dart';

import '../../../core/app_enums.dart';
import '../../../core/app_switches.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/features/expenses/view_model/cubit/expenses_cubit.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_dialogs.dart';

class ExpensesScreen extends StatelessWidget {
  ExpensesScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpensesCubit()
        ..getExpenses()
        ..getExpensesTypes(),
      child: BlocBuilder<ExpensesCubit, ExpensesStates>(
        builder: (context, state) {
          var cubit = ExpensesCubit.get(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(),
              endDrawer: const DrawerScreen(
                screenName: "Expenses",
              ),
              body: Column(
                children: [
                  CustAppBar(
                    title: "expensesTitle".i18n(),
                    scaffoldKey: scaffoldKey,
                    imageSrc: 'expenses_icon',
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
                                    fontSize: 16,
                                    color: cubit.screenType == e
                                        ? secondryColor
                                        : Colors.grey),
                              ),
                            ))
                        .toList(),
                  ),
                  Expanded(
                    child: ConditionalBuilder(
                      condition: cubit.expensesModel != null,
                      builder: (context) {
                        return cubit.expensesModel!.message.isEmpty
                            ? noDataFound(context, type: "Expenses")
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: cubit.expensesModel?.message.length,
                                itemBuilder: (context, index) => ContentWidget(
                                  bottomTextColor: colorStatus(cubit
                                      .expensesModel!.message[index].status
                                      .toString())['color'],
                                  buttonTitle: "details".i18n(),
                                  bottomText: textStatus(cubit
                                      .expensesModel!.message[index].status
                                      .toString()),
                                  topText: cubit
                                      .expensesModel!.message[index].typeExpense
                                      .toString(),
                                  centerText: cubit.expensesModel!
                                      .message[index].advanceAmount
                                      .toString(),
                                  centerTitleType: "LE",
                                  buttonColor: selectColor(SelectColor.DEFAULT),
                                  widget: selectImage(cubit
                                      .expensesModel!.message[index].status
                                      .toString()),
                                  onTap: () {
                                    activitiesAndSettlementAndExpensesDetails(
                                        context: context,
                                        title: "EXPENSES DETAILS",
                                        taskName: cubit.expensesModel!.message[index].activityName ??
                                            "",
                                        ishaveClient: false,
                                        attachedFile: cubit.expensesModel!
                                            .message[index].attachFiles,
                                        stateText: textStatus(cubit
                                            .expensesModel!
                                            .message[index]
                                            .status
                                            .toString()),
                                        type: "Expenses Type",
                                        typeValue: cubit.expensesModel!
                                            .message[index].typeExpense
                                            .toString(),
                                        buttonTitle: "CLOSE",
                                        color: colorStatus(cubit.expensesModel!
                                            .message[index].status
                                            .toString())['color'],
                                        colors: colorStatus(cubit.expensesModel!
                                            .message[index].status
                                            .toString())['colors'],
                                        comment: cubit.expensesModel!.message[index].purpose.toString(),
                                        amount: cubit.expensesModel!.message[index].advanceAmount.toString(),
                                        clientName: cubit.expensesModel!.message[index].employeeName.toString(),
                                        dateTime: cubit.expensesModel!.message[index].postingDate.toString());
                                  },
                                ),
                              );
                      },
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                ],
              ),
              floatingActionButton: custFloatingAction(onTap: () {
                newActivityAndNewExpensesDialog(
                  context: context,
                  title: "NEW EXPENSES",
                  type: "Expenses Type",
                  typeName: cubit.expenseName,
                  typeValue: cubit.advanceTypesModel?.message ?? [],
                  commentAndAttachFile: BlocProvider.value(
                    value: BlocProvider.of<ExpensesCubit>(context),
                    child: BlocBuilder<ExpensesCubit, ExpensesStates>(
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
                    value: BlocProvider.of<ExpensesCubit>(context),
                    child: BlocBuilder<ExpensesCubit, ExpensesStates>(
                      builder: (context, state) {
                        return Text(
                          cubit.expenseSelected ??
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
                  onSelectedClient: (client) {
                    cubit.client.text = client;
                  },
                  buttonTitle: "SUBMIT",
                  color: selectColor(SelectColor.DEFAULT),
                  colors: selectGradientColor(SelectColor.DEFAULT),
                  amount: cubit.amount,
                  client: cubit.client,
                  onTap: () {
                    cubit.addNewExpense(context);
                  },
                  onSelection: (e) {
                    cubit.changeSelection(e);
                  },
                );
              }));
        },
      ),
    );
  }
}
