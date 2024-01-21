import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/core/media_query_values.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/features/tasks/view_model/cubit/tasks_cubit.dart';
import 'package:data_soft/features/tasks/widgets/week_daya.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import '../../../core/app_datetime.dart';
import '../widgets/tasks_widgets.dart';
import 'package:data_soft/core/app_switches.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksCubit()
        ..getAllTodo()
        ..getTodoTypes()
        ..getTodoPriority(),
      child: BlocBuilder<TasksCubit, TasksStates>(
        builder: (context, state) {
          var cubit = TasksCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            endDrawer: const DrawerScreen(
              screenName: "Tasks",
            ),
            body: Column(
              children: [
                CustAppBar(
                    title: "tasksTitle".i18n(),
                    scaffoldKey: scaffoldKey,
                    imageSrc: 'tasks_icon'),
                Expanded(
                    child: ConditionalBuilder(
                  condition: cubit.todoModel != null,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 6,
                                      color: Colors.black.withOpacity(0.3))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(children: [
                                    Text(
                                      "goodMorning".i18n(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      userData!.fullName.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "today".i18n(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff7646FF)),
                                      ),
                                      Text(
                                        "completed".i18n(),
                                        style: const TextStyle(
                                            fontSize: 14, color: approvedColor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateTimeFormating.formatCustomDate(
                                            date: DateTime.now(),
                                            formatType: 'd MMM, yyyy'),
                                        style: const TextStyle(
                                            fontFamily: FontFamilyStrings
                                                .ROBOTO_REGULAR,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Wrap(
                                        children: [
                                          Text(
                                            cubit.todoModel!.completedCount
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: approvedColor),
                                          ),
                                          const Text(
                                            "/",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: approvedColor),
                                          ),
                                          Text(
                                            cubit.todoModel!.message.length
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.red),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: 55,
                                width: double.infinity,
                                color: primaryColor,
                              ),
                              SizedBox(
                                height: 75,
                                child: WeeklyDatePicker(
                                  selectedDay:
                                      DateTime.parse(cubit.transactionDate),
                                  changeDay: (date) {
                                    cubit.getTodoDataByDate(date);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Card(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    'all'.i18n(),
                                    'planned'.i18n(),
                                    'inProgress'.i18n(),
                                    'completed'.i18n()
                                  ]
                                      .map(
                                        (e) => TextButton(
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
                                        ),
                                      )
                                      .toList())),
                          const SizedBox(height: 20),
                          cubit.todoModel!.message.isEmpty
                              // ? noDataFound(context, type: "Tasks")
                          ? Container(
                            height: context.height * .3,
                            alignment: Alignment.center,
                            child: Text("noTasksFound".i18n(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontFamilyStrings.ROBOTO_BOLD,
                                color: Colors.grey),),
                          )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cubit.todoModel?.message.length,
                                  itemBuilder: (context, index) => Card(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateTimeFormating.formatTime(cubit
                                                              .todoModel
                                                              ?.message[index]
                                                              .dueTime
                                                              .toString() ==
                                                          "null"
                                                      ? "10:14:38"
                                                      : cubit
                                                          .todoModel
                                                          ?.message[index]
                                                          .dueTime
                                                          .toString())[0]
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              DateTimeFormating.formatTime(cubit
                                                              .todoModel
                                                              ?.message[index]
                                                              .dueTime
                                                              .toString() ==
                                                          "null"
                                                      ? "17:14:38"
                                                      : cubit
                                                          .todoModel
                                                          ?.message[index]
                                                          .dueTime
                                                          .toString())[1]
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                cubit.todoModel!.message[index]
                                                    .todoName
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                cubit.todoModel!.message[index]
                                                    .todoType
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black)),
                                          ],
                                        )),
                                        Row(
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  cubit.description.text = cubit
                                                      .todoModel!
                                                      .message[index]
                                                      .description
                                                      .toString();
                                                  cubit.taskName.text = cubit
                                                      .todoModel!
                                                      .message[index]
                                                      .todoName
                                                      .toString();
                                                  cubit.dateTime = DateTimeFormating
                                                      .formatCustomDate(
                                                          date: DateTime.parse(
                                                              cubit
                                                                  .todoModel!
                                                                  .message[
                                                                      index]
                                                                  .date
                                                                  .toString()),
                                                          formatType:
                                                              "dd MMMM ,yyyy");
                                                  cubit.getTaskState(index);
                                                  updatingTask(context, index);
                                                },
                                                child: imageSvg(
                                                    src: "edit_icon",
                                                    size: 25)),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Icon(Icons.circle,
                                                size: 20,
                                                color: colorStatus(cubit
                                                    .todoModel!
                                                    .message[index]
                                                    .status
                                                    .toString())['color'])
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                                )
                        ],
                      ),
                    );
                  },
                  fallback: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                )),
              ],
            ),
            floatingActionButton: managerData!.isManager!
                ? custFloatingAction(onTap: () {
                    newTask(context: context);
                  })
                : null,
          );
        },
      ),
    );
  }
}
