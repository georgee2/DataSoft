library weekly_date_picker;

import 'package:clip_shadowx/clip_shadowx.dart';
import 'package:flutter/material.dart';

import '../../../core/app_datetime.dart';

class WeeklyDatePicker extends StatefulWidget {
  const WeeklyDatePicker({
    Key? key,
    required this.selectedDay,
    required this.changeDay,
    this.weekdayText = 'Week',
    this.weekdays = const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.selectedBackgroundColor = const Color(0xFF2A2859),
    this.selectedDigitColor = const Color(0xFFFFFFFF),
    this.digitsColor = const Color(0xFF000000),
    this.weekdayTextColor = const Color(0xFF303030),
    this.weeknumberColor = const Color(0xFFB2F5FE),
    this.weeknumberTextColor = const Color(0xFF000000),
    this.daysInWeek = 7,
  })  : assert(weekdays.length == daysInWeek,
            "weekdays must be of length $daysInWeek"),
        super(key: key);

  /// The current selected day
  final DateTime selectedDay;

  /// Callback function with the new selected date
  final Function(DateTime) changeDay;

  /// Specifies the weekday text: default is 'Week'
  final String weekdayText;

  /// Specifies the weekday strings ['Mon', 'Tue'...]
  final List<String> weekdays;

  /// Background color
  final Color backgroundColor;

  /// Color of the selected digits text
  final Color selectedBackgroundColor;

  /// Color of the unselected digits text
  final Color selectedDigitColor;

  /// Color of the unselected digits text
  final Color digitsColor;

  /// Is the color of the weekdays 'Mon', 'Tue'...
  final Color weekdayTextColor;

  /// Set to false to hide the weeknumber textfield to the left of the slider

  /// Color of the weekday container
  final Color weeknumberColor;

  /// Color of the weekday text
  final Color weeknumberTextColor;

  /// Specifies the number of weekdays to render, default is 7, so Monday to Sunday
  final int daysInWeek;

  @override
  // ignore: library_private_types_in_public_api
  _WeeklyDatePickerState createState() => _WeeklyDatePickerState();
}

class _WeeklyDatePickerState extends State<WeeklyDatePicker> {
  // final DateTime _todaysDateTime = DateTime.now();

  // About 100 years back in time should be sufficient for most users, 52 weeks * 100
  final int _weekIndexOffset = 5200;

  late final PageController _controller;
  late final DateTime _initialSelectedDay;
  late int weeknumberInSwipe;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _weekIndexOffset);
    _initialSelectedDay = widget.selectedDay;
    weeknumberInSwipe = widget.selectedDay.weekday;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      onPageChanged: (int index) {
        setState(() {
          weeknumberInSwipe = _initialSelectedDay
              .add(Duration(days: 7 * (index - _weekIndexOffset)))
              .weekday;
        });
      },
      scrollDirection: Axis.horizontal,
      itemBuilder: (_, weekIndex) => SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _weekdays(weekIndex - _weekIndexOffset),
        ),
      ),
    );
  }

  // Builds a 5 day list of DateButtons
  List<Widget> _weekdays(int weekIndex) {
    List<Widget> weekdays = [];

    for (int i = 0; i < widget.daysInWeek; i++) {
      final int offset = i + 1 - _initialSelectedDay.weekday;
      final int daysToAdd = weekIndex * 7 + offset;
      final DateTime dateTime =
          _initialSelectedDay.add(Duration(days: daysToAdd));
      weekdays.add(_dateButton(dateTime));
    }
    return weekdays;
  }

  Widget _dateButton(DateTime dateTime) {
    final String weekday = widget.weekdays[dateTime.weekday - 1];
    final month =
        DateTimeFormating.formatCustomDate(date: dateTime, formatType: 'MMM');
    final bool isToday = DateTimeFormating.formatCustomDate(
                date: widget.selectedDay, formatType: 'E')
            .toString()
            .toUpperCase() ==
        weekday;
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.changeDay(dateTime),
        child: Align(
          alignment: Alignment.topCenter,
          child: ClipShadow(
            clipper: TaskClipPath(),
            shadows: [
              isToday
                  ? BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                      color: Colors.black.withOpacity(0.2))
                  : const BoxShadow(color: Colors.transparent)
            ],
            child: Container(
              height: isToday ? 80 : null,
              width: 50,
              color: isToday ? Colors.white : Colors.transparent,
              padding: const EdgeInsets.only(top: 3),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    weekday,
                    style:
                        TextStyle(color: isToday ? Colors.black : Colors.white),
                  ),
                  Text(
                    '${dateTime.day}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isToday ? Colors.black : Colors.white),
                  ),
                  Text(
                    month,
                    style:
                        TextStyle(color: isToday ? Colors.black : Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaskClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 70);
    path.lineTo(size.width / 2, 55);
    path.lineTo(size.width, 70);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
