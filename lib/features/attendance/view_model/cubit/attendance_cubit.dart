import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/features/attendance/model/attendance_model.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/app_datetime.dart';
part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());
  static AttendanceCubit get(BuildContext context) => BlocProvider.of(context);
  AttendanceModel? attendanceModel;
  String? fullDate;
  changeDate(context) {
    showDialog(
      context: context,
      builder: (context) {
        dynamic start, end, year;
        return Dialog(
          child: SizedBox(
            height: 370,
            width: 350,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SfDateRangePicker(
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      start = args.value.startDate;
                      end = args.value.endDate;
                      year = DateTimeFormating.formatYearDate(
                          args.value.endDate ?? args.value.startDate);
                    },
                    selectionMode: DateRangePickerSelectionMode.extendableRange,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        if (start != null && end != null && year != null) {
                          fullDate =
                              "${DateTimeFormating.formatMonthDate(start)} - ${DateTimeFormating.formatMonthDate(end)} ${DateTimeFormating.formatYearDate(end ?? start)}";
                          getAttendance(
                              from: DateTimeFormating.sendFormatDate(start),
                              to: DateTimeFormating.sendFormatDate(end));
                          Navigator.pop(context);
                        }
                      },
                    ),
                    TextButton(
                      child: const Text("CANCEL"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  getAttendance({from, to}) async {
    emit(GetAttendanceLoadingState());
    try {
      Map<String, dynamic> data = {
        "employee": hubData?.userData?.employeeId,
        "from_date": from,
        "to_date": to
      };
      Response response = await DioHelper.getData(
          url: EndPoints.GET_ATTENDANCE, queryParameters: data);
      attendanceModel = AttendanceModel.fromJson(response.data);
      if (attendanceModel?.message?.success == true) {
        emit(GetAttendanceSuccessState());
      } else {
        emit(GetAttendanceErrorState());
      }
    } catch (e) {
      emit(GetAttendanceErrorState());
    }
  }
}
