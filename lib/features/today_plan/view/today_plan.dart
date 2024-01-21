import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/features/today_plan/view_model/cubit/today_plan_cubit.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:data_soft/features/plans/widgets/plans_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants.dart';
import '../../drawer/drawer_sceen.dart';
import '../widgets/today_plan_widgets.dart';

class TodayPlans extends StatelessWidget {
  TodayPlans({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodayPlanCubit()..getVisits(),
      child: BlocBuilder<TodayPlanCubit, TodayPlanStates>(
        builder: (context, state) {
          var cubit = TodayPlanCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            endDrawer: const DrawerScreen(
              screenName: "Visits",
            ),
            appBar: AppBar(),
            body: Column(
              children: [
                CustAppBar(
                  title: "Visits",
                  scaffoldKey: scaffoldKey,
                  imageSrc: 'visits_icon',
                ),
                Expanded(
                    child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            ["All", "Pland", "In-Progress", "Completed   "]
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
                                      ),
                                    ))
                                .toList()),
                    Expanded(
                      child: ConditionalBuilder(
                        condition: cubit.todayPlanModel != null,
                        builder: (context) {
                          return cubit.todayPlanModel!.message!.data.isEmpty
                              ? noDataFound(context, type: "Visits")
                              : Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: ListView.separated(
                                    itemCount: cubit
                                        .todayPlanModel!.message!.data.length,
                                    itemBuilder: (context, index) =>
                                        DoctorsContent(
                                      index: index,
                                      doctorData: cubit
                                          .todayPlanModel!.message!.data[index],
                                          cubit: cubit,
                                    ),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 20,
                                    ),
                                  ),
                                );
                        },
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    )
                  ],
                ))
              ],
            ),
            floatingActionButton: custFloatingAction(
              onTap: () {
                unplannedVisitsDialog(context);
              },
            ),
          );
        },
      ),
    );
  }
}
