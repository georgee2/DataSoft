import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_dialogs.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../view_model/cubit/tasks_cubit.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';

updatingTask(context, index) {
  dialogFrameSingleButton2(
      context: context,
      title: "TASK DETAILE",
      buttonTitle: "UPDATE",
      action: imageSvg(src: 'edit_icon', size: 20, color: Colors.white),
      buttonColor: approvedColor,
      onTap: () {
        TasksCubit.get(context).taskUpdating(context, index);
      },
      colors: selectGradientColor(SelectColor.APPROVED),
      child: BlocProvider.value(
        value: BlocProvider.of<TasksCubit>(context),
        child: BlocBuilder<TasksCubit, TasksStates>(
          builder: (context, state) {
            var cubit = TasksCubit.get(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            cubit.changeTaskState(0);
                          },
                          child: radioRow(
                            title: "It's done",
                            value: cubit.taskValue,
                            groupValue: 0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cubit.changeTaskState(1);
                          },
                          child: radioRow(
                            title: "Pending",
                            value: cubit.taskValue,
                            groupValue: 1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cubit.changeTaskState(2);
                          },
                          child: radioRow(
                            title: "Canceled",
                            value: cubit.taskValue,
                            groupValue: 2,
                          ),
                        ),
                      ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Task Type",
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Visits",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        imageSvg(src: "arrow_down", size: 20)
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Task Priority",
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Important",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        imageSvg(src: "arrow_down", size: 20)
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Date",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025))
                              .then((value) {
                            if (value != null) {
                              cubit.changeDateTime(value);
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              imageSvg(src: "calendar_event", size: 30),
                              Expanded(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(cubit.dateTime)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            if (value != null) {
                              cubit.changeTimeOfDay(value);
                            }
                          });
                        },
                        child: Row(
                          children: [
                            imageSvg(src: "calendar_event", size: 30),
                            Align(
                                alignment: Alignment.center,
                                child: Text(cubit.timeOfDay))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Task Name",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: custTaskCupertinoTextField(
                      placeholder: "Your Task Name...",
                      controller: cubit.taskName),
                ),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: custTaskCupertinoTextField(
                      placeholder: "Your Description...",
                      isDescription: true,
                      controller: cubit.description),
                ),
                attachFile(
                  onTap: () {},
                  attachedFile: cubit.attachFile,
                )
              ],
            );
          },
        ),
      ));
}

newTask({required BuildContext context}) {
  dialogFrameSingleButton(
    context: context,
    title: "NEW TASK",
    buttonTitle: 'ADD',
    buttonColor: selectColor(SelectColor.DEFAULT),
    onTap: () {
      TasksCubit.get(context).addNewTodo(context);
    },
    colors: selectGradientColor(SelectColor.DEFAULT),
    child: BlocProvider.value(
        value: BlocProvider.of<TasksCubit>(context),
        child: BlocConsumer<TasksCubit, TasksStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = TasksCubit.get(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Task Type",
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          cubit.todoSelectedType ?? "",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        PopupMenuButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: imageSvg(src: 'arrow_down', size: 20),
                          ),
                          itemBuilder: (context) => cubit.todoTypeModel!.data
                              .map((e) => PopupMenuItem(
                                  onTap: () {
                                    cubit.changeTodoType(e);
                                  },
                                  child: Text(e.toString())))
                              .toList(),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Task Priority",
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          cubit.prioritySelected ?? "",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        PopupMenuButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: imageSvg(src: 'arrow_down', size: 20),
                          ),
                          itemBuilder: (context) =>
                              cubit.todoPriorityModel!.data
                                  .map((e) => PopupMenuItem(
                                      onTap: () {
                                        cubit.changeTodoPriority(e);
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
                const Text(
                  "Date",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025))
                              .then((value) {
                            if (value != null) {
                              cubit.changeDateTime(value);
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              imageSvg(src: "calendar_event", size: 30),
                              Expanded(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(cubit.dateTime)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.2),
                          borderRadius: BorderRadius.circular(5)),
                      child: GestureDetector(
                        onTap: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            if (value != null) {
                              cubit.changeTimeOfDay(value);
                            }
                          });
                        },
                        child: Row(
                          children: [
                            imageSvg(src: "calendar_event", size: 30),
                            Align(
                                alignment: Alignment.center,
                                child: Text(cubit.timeOfDay))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Task To assigned to",
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Expanded(
                        child: PopupMenuButton(
                      child: custTaskCupertinoTextField(
                          placeholder: "Assigned to...",
                          isClickable: false,
                          controller: cubit.assignedto),
                      itemBuilder: (context) => managerData!.managersList!
                          .map((e) => PopupMenuItem(
                              onTap: () {
                                cubit.selectRep(
                                    e['user'], e['Employee_id'].toString());
                              },
                              child: Text(e['employee_name'].toString())))
                          .toList(),
                    )),
                    GestureDetector(
                      onTap: () {
                        cubit.changeAssignedTo();
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 12.5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: cubit.allocatedTo == true
                                    ? Border.all(
                                        width: 7.5, color: primaryColor)
                                    : Border.all(width: 2, color: Colors.grey),
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white),
                          ),
                          const Text(
                            "For Me",
                            style: TextStyle(fontSize: 16, color: primaryColor),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const Text(
                  "Task Name",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: custTaskCupertinoTextField(
                      placeholder: "Your Task Name...",
                      controller: cubit.taskName),
                ),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: custTaskCupertinoTextField(
                      placeholder: "Your Description...",
                      isDescription: true,
                      controller: cubit.description),
                ),
                attachFile(
                  onTap: () {
                    cubit.getAttachFile();
                  },
                  attachedFile: cubit.attachFile,
                )
              ],
            );
          },
        )),
  );
}

Widget custTaskCupertinoTextField(
    {required String placeholder,
    bool isDescription = false,
    bool isClickable = true,
    required TextEditingController controller}) {
  return CupertinoTextField(
    placeholder: placeholder,
    maxLines: isDescription ? 4 : null,
    keyboardType: TextInputType.text,
    decoration: decorationOfTextFeild,
    enabled: isClickable,
    controller: controller,
  );
}

Widget radioRow({
  required String title,
  required int value,
  required int groupValue,
}) {
  return Row(
    children: [
      Container(
        height: 20,
        width: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: value == groupValue
                ? Border.all(
                    width: 7.5,
                    color: groupValue == 0
                        ? approvedColor
                        : groupValue == 1
                            ? pendingColor
                            : rejectedColor)
                : Border.all(width: 2, color: Colors.grey),
            borderRadius: BorderRadius.circular(25),
            color: Colors.white),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        title,
        style: TextStyle(
            color: groupValue == 0
                ? approvedColor
                : groupValue == 1
                    ? pendingColor
                    : rejectedColor),
      )
    ],
  );
}
