import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/features/today_plan/model/today_plan_model.dart';
import 'package:data_soft/features/visits/view/visits_screen.dart';
import 'package:data_soft/core/local/cache_helper.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';
import '../notifications/view_model/notification_helper.dart';
import '../visits/model/visit_count_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.notificationType});
  final String? notificationType;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigateTimer(context) async {
    VisitCountModel? visitCountModel = VisitCountModel.fromJson(
        await CacheHelper.getData("VisitData", Map) ?? {});
    Future.delayed(const Duration(seconds: 5)).then((value) async {
      if (visitCountModel.opportunityName != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VisitsScreen(
                      fromLocal: true,
                      tag: '',
                      visitCountModel: visitCountModel,
                      doctorData: DoctorData(
                          customerName: visitCountModel.doctorName,
                          medicalSpecialty: visitCountModel.medicalSpecialty,
                          partyName: visitCountModel.doctorID,
                          visitId: visitCountModel.opportunityName),
                    )));
      } else {
        if (widget.notificationType == null) {
          await navigateAndKill(
              context: context, navigateAndKill: NavigateAndKill.Home);
        } else {
          notificationAction(context, widget.notificationType);
        }
      }
    });
  }

  startAnimatedTimer() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      isend = true;
      setState(() {});
    });
  }

  bool isend = false;
  @override
  void initState() {
    navigateTimer(context);
    startAnimatedTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1500),
              opacity: isend ? 1.0 : 0.0,
              child: SizedBox(
                  height: 150,
                  // child: custDefaultNetWorkImage("http://154.38.165.213:1212/files/Home_Logo_Web-2-e1540243947404.png")
                  child: custDefaultNetWorkImage(
                      "http://154.38.165.213:1313${hubData?.companyLogo}",
                      fit: BoxFit.fitWidth)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/dataSoft_logo.png",
                height: 60,
              ),
              const Text("Powered by: Data Soft"),
            ],
          ),
        ]),
      ),
    );
  }
}
