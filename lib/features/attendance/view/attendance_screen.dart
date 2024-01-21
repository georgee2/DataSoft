import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/features/attendance/model/attendance_model.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../drawer/drawer_sceen.dart';
import '../view_model/cubit/attendance_cubit.dart';
import '../widgets/attendace_widgets.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(
        screenName: "Attendance",
      ),
      body: BlocProvider(
        create: (context) => AttendanceCubit()..getAttendance(),
        child: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            var cubit = AttendanceCubit.get(context);
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustAppBar(
                      title: "Attendance",
                      scaffoldKey: scaffoldKey,
                      imageSrc: "check_in_attendance_icon"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Period attendance report'),
                        const SizedBox(
                          height: 10,
                        ),
                        FromAndToDateTimeContainer(
                            onTap: () {
                              cubit.changeDate(context);
                            },
                            time: cubit.fullDate == null
                                ? "Choose date"
                                : cubit.fullDate!),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 25,
                    thickness: 25,
                    color: Color(0xffEBEEF1),
                  ),

                  ///absence container
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ConditionalBuilder(
                      condition: cubit.attendanceModel?.message?.data != null,
                      builder: (context) {
                        return cubit.attendanceModel!.message!.data.isEmpty
                            ? noDataFound(context, type: "Attendance")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    cubit.attendanceModel?.message?.data.length,
                                itemBuilder: (context, index) {
                                  Data items = cubit
                                      .attendanceModel!.message!.data[index];
                                  return contentRow(context, items);
                                },
                              );
                      },
                      fallback: (context) => const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
