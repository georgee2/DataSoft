import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/features/check_in/view_model/cubit/check_in_cubit.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import '../../drawer/drawer_sceen.dart';

class CheckInHistory extends StatelessWidget {
  CheckInHistory({super.key, required this.context});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final dynamic context;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CheckInCubit>(this.context),
      child: BlocConsumer<CheckInCubit, CheckInStates>(
        listener: (context, state) {},
        builder: (BuildContext context, state) {
          var cubit = CheckInCubit.get(this.context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            endDrawer: const DrawerScreen(
              screenName: "Check In",
            ),
            body: Column(
              children: [
                CustAppBar(
                    title: "Check In",
                    scaffoldKey: scaffoldKey,
                    imageSrc: "check_in_attendance_icon"),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      return ConditionalBuilder(
                        condition: cubit.checkInModel != null,
                        builder: (context) {
                          return cubit.checkInData.isEmpty ? noDataFound(context)
                          : SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              children: cubit.checkInData
                                  .map(
                                    (e) => Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          // padding: const EdgeInsets.all(10),
                                          // margin: const EdgeInsets.only(top: 10),
                                          margin: const EdgeInsets.only(top: 30),
                                          color: const Color(0xffEBEEF1),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  // alignment: Alignment.centerLeft,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    DateTimeFormating.formatCustomDate(
                                                        date: e.date ?? DateTime.now(),
                                                        formatType: "dd MMM yyyy"),
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontFamily: FontFamilyStrings
                                                            .ROBOTO_BOLD),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    cubit.changeItemState(e);
                                                  },
                                                  child: RotatedBox(
                                                    quarterTurns: e.isShow! ? 90 : 0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child:
                                                          imageSvg(src: 'arrow_down'),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        if (e.isShow == true)
                                          Timeline.tileBuilder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            theme: TimelineTheme.of(context)
                                                .copyWith(nodePosition: 0.1),
                                            builder: TimelineTileBuilder.connected(
                                                itemCount: 2,
                                                contentsBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          TimelineNode.simple(
                                                            drawStartConnector: true,
                                                            drawEndConnector: true,
                                                            color: secondryColor,
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .fromLTRB(
                                                                  5, 20, 30, 20),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    index == 0
                                                                        ? "Check In"
                                                                        : "Check Out",
                                                                    style:
                                                                        const TextStyle(
                                                                            fontSize:
                                                                                18),
                                                                  ),
                                                                  Text(
                                                                    index == 0
                                                                        ? DateFormat(
                                                                                'h:mm a')
                                                                            .format(DateFormat(
                                                                                    'yyyy-mmmm-dd HH:mm')
                                                                                .parse(e
                                                                                    .checkIn!))
                                                                        : e.checkOut !=
                                                                                null
                                                                            ? DateFormat(
                                                                                    'h:mm a')
                                                                                .format(
                                                                                    DateFormat('yyyy-mmmm-dd HH:mm').parse(e.checkOut!))
                                                                            : '',
                                                                    // "09:00 AM",
                                                                    style: const TextStyle(
                                                                        fontSize: 16,
                                                                        color:
                                                                            secondryColor),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          ),
                                        if (e.isShow!)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Divider(height: 2),
                                          ),

                                        ///work hours
                                        if (e.isShow!)
                                          RichText(
                                              text: TextSpan(
                                            text: 'working hours: ',
                                            style: const TextStyle(
                                                color: Colors.black, fontSize: 16),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      DateTimeFormating.calculateHours(
                                                          e.checkOut!, e.checkIn!),
                                                  // text: '8 hours',
                                                  style: const TextStyle(
                                                      color: secondryColor,
                                                      fontSize: 18))
                                            ],
                                          )),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                        fallback: (context) => const Center(child: CircularProgressIndicator()),
                      );
                    }
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
