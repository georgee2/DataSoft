import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/today_plan/view_model/cubit/today_plan_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_dialogs.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/shared_widgets.dart';

unplannedVisitsDialog(context) {
  dialogFrameSingleButton(
      context: context,
      title: "UNPLANNED VISITS",
      buttonTitle: "SUBMIT",
      buttonColor: primaryColor,
      colors: [primaryColor, primaryColor.withOpacity(0.70)],
      onTap: () {
        TodayPlanCubit.get(context).postPoneVisit(context);
      },
      child: BlocProvider.value(
        // lazy: false,
        value: BlocProvider.of<TodayPlanCubit>(context)
          ..getAllPlansToUnplanndVisit(context),
        child: BlocConsumer<TodayPlanCubit, TodayPlanStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = TodayPlanCubit.get(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PopupMenuButton(
                  child: custCupertinoTextField(
                      title: "Client",
                      textInputType: TextInputType.name,
                      controller: TextEditingController(
                          text: cubit.unplannedDoctorData?.customerName ??
                              "Choose client..."),
                      isDisabled: false),
                  itemBuilder: (context) {
                    if (cubit.plansOfDaysModel!.message!.data.isEmpty) {
                      showToast("No Visits found");
                    }
                    return cubit.plansOfDaysModel!.message!.uniqueDoctorData
                        .map((e) => PopupMenuItem(
                            onTap: () {
                              cubit.changeUnplannedDoctorData(e);
                            },
                            child: Text(e.customerName.toString())))
                        .toList();
                  },
                ),
                custCupertinoTextField(
                    title: "Medical Specialty",
                    textInputType: TextInputType.name,
                    controller: TextEditingController(
                        text: cubit.unplannedDoctorData?.medicalSpecialty ??
                            "Choose Client..."),
                    isDisabled: false),
                custCupertinoTextField(
                    title: "CLM Status",
                    textInputType: TextInputType.name,
                    controller: TextEditingController(
                        text: cubit.unplannedDoctorData?.includeClm == 1
                            ? "Include CLM"
                            : "not include CLM"),
                    isDisabled: false),
                PopupMenuButton(
                  child: custCupertinoTextField(
                      title: "Visits Date",
                      textInputType: TextInputType.name,
                      controller: TextEditingController(
                          text:
                              cubit.unplannedDoctorData?.transactionDate != null
                                  ? DateTimeFormating.formatCustomDate(
                                      date: cubit
                                          .unplannedDoctorData?.transactionDate,
                                      formatType: "dd MMM yyyy")
                                  : "Choose client..."),
                      isDisabled: false),
                  itemBuilder: (context) => cubit.unplannedVisits
                      .map((e) => PopupMenuItem(
                          onTap: () {
                            cubit.changeUnplannedDoctorData(e);
                          },
                          child: Text(DateTimeFormating.formatCustomDate(
                              date: e.transactionDate,
                              formatType: "dd MMM yyyy"))))
                      .toList(),
                ),
              ],
            );
          },
        ),
      ));
}
