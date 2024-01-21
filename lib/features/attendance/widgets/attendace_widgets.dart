import '../../../core/app_enums.dart';
import '../../../core/app_switches.dart';
import 'package:data_soft/core/app_datetime.dart';
import 'package:flutter/material.dart';
import 'package:data_soft/features/attendance/model/attendance_model.dart';
import 'package:intl/intl.dart';
import '../../../core/app_dialogs.dart';
import '../../../core/app_fonts.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/shared_widgets.dart';

Widget contentRow(context, Data items) {
  if (items.startTime != null && items.endTime != null) {
    items.workingHours = DateTimeFormating.calculateHours(
        DateFormat('yyyy-mmmm-dd HH:mm')
            .parse("${items.attendanceDate} ${items.endTime}")
            .toString(),
        DateFormat('yyyy-mmmm-dd HH:mm')
            .parse("${items.attendanceDate} ${items.startTime}")
            .toString());
  }
  return GestureDetector(
    onTap: items.status == "Present"
        ? () {
            attendanceDialogs(context, items);
          }
        : null,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: borderRadius, color: const Color(0xffDDEFFE)),
      child: Row(
        children: [
          dateTimeWidget(items.attendanceDate),
          const SizedBox(
            width: 5,
          ),
          verticalLine(
              height: 45, color: const Color(0xff707070).withOpacity(0.3)),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: Center(
            child: chooseCenterContent(items.status == "Present", items),
          )),
          items.status == "Present"
              ? Container(
                  height: 30,
                  // width: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: secondryColor),
                  child: Text(items.workingHours!,
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: FontFamilyStrings.ARIAL_LIGHT,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                )
              : Container()
        ],
      ),
    ),
  );
}

Widget chooseCenterContent(isData, Data items) {
  if (!isData) {
    return Text(
      items.status.toString(),
      style: TextStyle(
          fontSize: 28,
          fontFamily: FontFamilyStrings.ARIAL_REGULAR,
          fontWeight: FontWeight.w400,
          color: chooseStateColor(items.status)),
    );
  } else {
    final checkIn = DateFormat('h:mm a').format(DateFormat('yyyy-mmmm-dd HH:mm')
        .parse("${items.attendanceDate} ${items.startTime}"));
    final checkOut = DateFormat('h:mm a').format(
        DateFormat('yyyy-mmmm-dd HH:mm')
            .parse("${items.attendanceDate} ${items.endTime}"));
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.circle,
              color: primaryColor,
              size: 10,
            ),
            const SizedBox(
              width: 5,
            ),
            Text('in $checkIn To $checkOut')
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Row(
          children: [
            Icon(
              Icons.circle,
              color: approvedColor,
              size: 10,
            ),
            SizedBox(
              width: 5,
            ),
            Text('Present')
          ],
        ),
      ],
    );
  }
}

Widget dateTimeWidget(date) {
  return Stack(
    alignment: AlignmentDirectional.topStart,
    children: [
      Container(
        height: 55,
        width: 50,
        margin: const EdgeInsetsDirectional.only(top: 5),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: borderRadius, border: border, color: bgColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              DateTimeFormating.formatCustomDate(date: date, formatType: "dd"),
              style: const TextStyle(
                  fontSize: 26,
                  fontFamily: FontFamilyStrings.ROBOTO_BOLD,
                  color: secondryColor,
                  fontWeight: FontWeight.w900),
            )),
            Text(
              DateTimeFormating.formatCustomDate(date: date, formatType: "MMM"),
              style: const TextStyle(
                  fontSize: 12,
                  color: secondryColor,
                  fontFamily: FontFamilyStrings.ROBOTO_MEDIUM,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsetsDirectional.only(start: 5),
        decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(5),
            color: bgColor),
        child: Text(
          DateTimeFormating.formatCustomDate(date: date, formatType: "yyyy"),
          style: const TextStyle(
              fontFamily: FontFamilyStrings.ROBOTO_LIGHT,
              fontSize: 10,
              color: secondryColor,
              fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

chooseStateColor(
  status,
) {
  switch (status) {
    case "Absent":
      return rejectedColor;
    case "On Leave":
      return Colors.redAccent;
    default:
      return Colors.orange;
  }
}

attendanceDialogs(context, Data items) {
  final checkIn = DateFormat('h:mm a').format(DateFormat('yyyy-mmmm-dd HH:mm')
      .parse("${items.attendanceDate} ${items.startTime}"));
  final checkOut = DateFormat('h:mm a').format(DateFormat('yyyy-mmmm-dd HH:mm')
      .parse("${items.attendanceDate} ${items.endTime}"));
  dialogFrameSingleButton(
    context: context,
    title: "ATTENDANCE DETAILS",
    buttonTitle: "CLOSE",
    buttonColor: primaryColor,
    onTap: () {
      Navigator.pop(context);
    },
    colors: selectGradientColor(SelectColor.DEFAULT),
    child: Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
            alignment: Alignment.centerLeft,
            child: Text("Date", style: TextStyle())),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 45,
              child: FromAndToDateTimeContainer(
                  onTap: () {
                    // cubit.changeDate(context);
                  },
                  time: DateFormat('dd - MMM ,yyyy')
                      .format(DateTime.now())
                      .toString()
                  // cubit.fullDate == null
                  //     ? DateFormat('dd - MMMM ,yyyy')
                  //         .format(DateTime.now())
                  //         .toString()
                  //     : cubit.fullDate!
                  ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Presence",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: approvedColor),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DetailsTimeContainer(title: "Check in", time: checkIn),
            DetailsTimeContainer(title: "Check out", time: checkOut),
            DetailsTimeContainer(
                title: "Working hours", time: items.workingHours!),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DetailsTimeContainer(
              title: "Overtime",
              time: items.workingHours!,
              color: approvedColor,
            ),
            DetailsTimeContainer(
              title: "Delaytime",
              time: items.workingHours!,
              color: rejectedColor,
            ),
          ],
        )
      ],
    ),
  );
}

// ignore: must_be_immutable
class DetailsTimeContainer extends StatelessWidget {
  DetailsTimeContainer({
    super.key,
    required this.time,
    required this.title,
    this.color = secondryColor,
  });
  final String time;
  final String title;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Container(
          height: 35,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            time,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ),
      ],
    );
  }
}
