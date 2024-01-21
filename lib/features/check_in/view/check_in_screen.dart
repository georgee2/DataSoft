import 'package:data_soft/core/app_datetime.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/features/check_in/view_model/cubit/check_in_cubit.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../drawer/drawer_sceen.dart';
import '../../registration/model/registration_model.dart';
import 'check_in_history.dart';

class CheckInScreen extends StatelessWidget {
  CheckInScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (contextt) => CheckInCubit()
        ..checkIsChecking()
        ..getLocalCheckingDataState()
        ..getAllItems(),
      child: BlocConsumer<CheckInCubit, CheckInStates>(
        listener: (contextt, state) {},
        builder: (BuildContext contextt, state) {
          var cubit = CheckInCubit.get(contextt);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            endDrawer: const DrawerScreen(
              screenName: "Check in",
            ),
            body: Column(
              children: [
                CustAppBar(
                    title: "Check in",
                    scaffoldKey: scaffoldKey,
                    imageSrc: "check_in_attendance_icon"),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              children: [
                                const Text(
                                  "Good Morning ",
                                  style: TextStyle(
                                      fontFamily:
                                          FontFamilyStrings.ROBOTO_LIGHT),
                                ),
                                Text(
                                  userData?.fullName ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          FontFamilyStrings.ROBOTO_BOLD),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CheckInHistory(context: contextt),
                                    ));
                              },
                              child: Image.asset(
                                "assets/images/history_icon.png",
                                height: 30,
                                width: 30,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            imageSvg(src: "calendar_event"),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              DateTimeFormating.formatCustomDate(
                                  date: DateTime.now(),
                                  formatType: 'dd MMM, yyyy'),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontFamilyStrings.ROBOTO_BOLD),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // content
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                        DateTimeFormating.formatCustomDate(
                            date: DateTime.now(), formatType: 'hh:mm a'),
                        style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamilyStrings.ROBOTO_BOLD)),
                    const SizedBox(
                      height: 20,
                    ),
                    imageSvg(src: "finger_print_icon", size: 100),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 240,
                      child: DateTimeFormating.sendFormatDate(DateTime.now()) ==
                                  cubit.localCheckInData?.checkinDate &&
                              cubit.localCheckInData?.isCheckOut == true
                          ? Container()
                          : Stack(
                              children: [
                                RotatedBox(
                                  quarterTurns:
                                      cubit.localCheckInData?.isCheckOut != null
                                          ? 90
                                          : 0,
                                  child: Container(
                                    height: 50,
                                    width: 240,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                            begin: Alignment(-1.0, 0),
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xffE5DFD6),
                                              Colors.white
                                            ])),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      cubit.localCheckInData?.isCheckIn == true
                                          ? Alignment.centerLeft
                                          : Alignment.centerRight,
                                  child: Container(
                                    height: 50,
                                    width: 120,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Check ${cubit.localCheckInData?.isCheckIn != true ? "Out" : "In"}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontFamily:
                                              FontFamilyStrings.ROBOTO_LIGHT),
                                    ),
                                  ),
                                ),
                                AnimatedAlign(
                                  duration: const Duration(milliseconds: 300),
                                  alignment:
                                      cubit.localCheckInData?.isCheckIn == true
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      // cubit.changeCheckingData(context);
                                      cubit.locationFunction(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 120,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xff088BD2),
                                                Color(0xff3ABDFA)
                                              ])),
                                      child: Text(
                                        "Check ${cubit.localCheckInData?.isCheckIn == true ? "Out" : "In"}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily:
                                                FontFamilyStrings.ROBOTO_LIGHT),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                    )
                  ],
                )),
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Row(
                    children: [
                      imageSvg(src: "check_in_location", size: 40),
                      const SizedBox(
                        width: 10,
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You should know that:",
                              style:
                                  TextStyle(fontSize: 12, color: secondryColor),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                                "You will not be able to register to come or leave except within a specific location.",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black),
                                textAlign: TextAlign.left)
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
