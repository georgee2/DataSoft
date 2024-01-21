import 'package:data_soft/features/settlement/view_model/cubit/settlement_cubit.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';
import 'package:localization/localization.dart';
import '../../../core/app_dialogs.dart';

newSettlementDialog({
  required BuildContext context,
}) {
  dialogFrameSingleButton(
    context: context,
    title: "newSettlement".i18n(),
    buttonTitle: 'submit'.i18n(),
    buttonColor: selectColor(SelectColor.DEFAULT),
    onTap: () {
      SettlementCubit.get(context).addNewSettlement();
    },
    colors: selectGradientColor(SelectColor.DEFAULT),
    child: BlocProvider.value(
      value: BlocProvider.of<SettlementCubit>(context)
        ..changeTypeSelection("Expense"),
      child: BlocBuilder<SettlementCubit, SettlementStates>(
        builder: (context, state) {
          var cubit = SettlementCubit.get(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "settlementType".i18n(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        cubit.settlementType,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xffA8ACAF)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      PopupMenuButton(
                        child: imageSvg(src: "arrow_down", size: 25),
                        itemBuilder: (context) => ['Expense', 'Activity']
                            .map((e) => PopupMenuItem(
                                onTap: () {
                                  cubit.changeTypeSelection(e);
                                },
                                child: Text(e.toString())))
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
                "settlementFor".i18n(),
                style: const TextStyle(fontSize: 16),
              ),
              Container(
                height: 35,
                alignment: AlignmentDirectional.centerStart,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(5),
                decoration: decorationOfTextFeild,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cubit.taskName ?? "Choose Name...",
                      style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    ),
                    PopupMenuButton(
                      child: imageSvg(src: "arrow_down", size: 25),
                      itemBuilder: (context) =>
                          cubit.settlementTypeModel!.message
                              .map((e) => PopupMenuItem(
                                  onTap: () {
                                    cubit.changeSettlementFor(e);
                                  },
                                  child: Text(e.taskName.toString())))
                              .toList(),
                    ),
                  ],
                ),
              ),
              Text(
                "amount".i18n(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: CupertinoTextField(
                      decoration: decorationOfTextFeild,
                      controller: cubit.amount,
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 90,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(9),
                      decoration: decorationOfTextFeild,
                      child: const Text("LE"),
                    ),
                  ],
                ),
              ),
              CustCommentTextField(
                controller: cubit.comment,
                onTap: () {
                  cubit.getAttachFile();
                },
                attachedFile: cubit.attachFile,
              ),
            ],
          );
        },
      ),
    ),
  );
}
