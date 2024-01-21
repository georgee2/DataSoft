
import 'package:localization/localization.dart';

import '../../../core/app_enums.dart';
import '../../../core/app_switches.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/drawer/components/components.dart';
import 'package:data_soft/features/registration/view/registration_screen.dart';
import 'package:data_soft/core/constants.dart';
import 'package:flutter/material.dart';
import '../../core/app_validations.dart';
import '../../core/firebase_helper.dart';
import '../../core/local/cache_helper.dart';
import '../about_us/view/about_us.dart';
import '../notifications/view_model/notification_helper.dart';
import '../planning/view/planning_screen.dart';
import '../registration/model/registration_model.dart';
import '../requests/view/all_requests.dart';
import '../salaries/view/salary_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key,required this.screenName});
  final String screenName;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: primaryColor,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 50,),
                    DrawerContent(screenName: screenName, title: "homeTitle".i18n(), imageSrc: "home_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Home);
                    }),
                    // if(managerData!.isManager!)
                    // DrawerContent(screenName: screenName, title: "requests".i18n(), imageSrc: "requests_icon", onTap: (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => AllRequests(),));
                    // }),
                    DrawerContent(screenName: screenName, title: "profileTitle".i18n(), imageSrc: screenName == "Profile"? "doctor_info_icon" :"profile_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Profile);
                    }),
                    if(AppValidations.screenValidation("0008") == true)
                    DrawerContent(screenName: screenName, title: "tasksTitle".i18n(), imageSrc: 'tasks_icon', onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Tasks);
                    }),
                    if(AppValidations.screenValidation("0010") == true)
                    DrawerContent(screenName: screenName, title: "clientsTitle".i18n(), imageSrc: "client_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Clients);
                    }),
                    if(AppValidations.screenValidation("0001") == true)
                    DrawerContent(screenName: screenName, title: "visitsTitle".i18n(), imageSrc: "visits_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.TodayPlans);
                    }),
                    if(AppValidations.screenValidation("0001") == true)
                    DrawerContent(screenName: screenName, title: "planStatusTitle".i18n(), imageSrc: "plans_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Plans);
                    }),
                    if(AppValidations.screenValidation("0004") == true)
                    DrawerContent(screenName: screenName, title: "expensesTitle".i18n(), imageSrc: "expenses_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Expenses);
                    }),
                    if(AppValidations.screenValidation("0003") == true)
                    DrawerContent(screenName: screenName, title: "activitiesTitle".i18n(), imageSrc: "activities_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Activities);
                    }),
                    if(AppValidations.screenValidation("0007") == true)
                    DrawerContent(screenName: screenName, title: "vacationTitle".i18n(), imageSrc: "vacation_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Vacation);
                    }),
                    if(AppValidations.screenValidation("0002") == true)
                    DrawerContent(screenName: screenName, title: "settlementTitle".i18n(), imageSrc: "settlement_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Settlement);
                    }),
                    if(AppValidations.screenValidation("0009") == true)
                    DrawerContent(screenName: screenName, title: "pocTitle".i18n(), imageSrc: "poc_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.POC);
                    }),
                    if(AppValidations.screenValidation("0005") == true)
                    DrawerContent(screenName: screenName, title: "salesTitle".i18n(), imageSrc: "sales_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Sales);
                    }),
                    if(AppValidations.screenValidation("0006") == true)
                    DrawerContent(screenName: screenName, title: "attendance".i18n(), imageSrc: "check_in_attendance_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.Attendance);
                    }),
                    if(AppValidations.screenValidation("0013") == true)
                    DrawerContent(screenName: screenName, title: "salaries".i18n(), imageSrc: "tasks_icon", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SalaryScreen(),));
                    }),
                    if(AppValidations.screenValidation("0011") == true)
                    DrawerContent(screenName: screenName, title: "checkIn".i18n(), imageSrc: "check_in_attendance_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.CHECK_IN);
                    }),
                    if(AppValidations.screenValidation("0012") == true)
                    DrawerContent(screenName: screenName, title: "permissions".i18n(), imageSrc: "settlement_icon", onTap: (){
                      navigateAndKill(context: context, navigateAndKill: NavigateAndKill.PERMISSIONS);
                    }),
                    if(AppValidations.screenValidation("0001") == true)
                    DrawerContent(screenName: screenName, title: "plansTitle".i18n(), imageSrc: "visits_icon", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PlanningScreen(),));
                    }),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     final locale = Localizations.localeOf(context);
                    //     var currentLang = CacheHelper.getData("lang", String);
                    //     final myApp = context.findAncestorStateOfType<MainAppState>();
                    //     // myApp!.changeLocale(currentLang == "ar" ? const Locale('ar') : const Locale('en'));
                    //     myApp!.changeLocale(currentLang == "ar" ? const Locale("en") : const Locale("ar"));
                    //     CacheHelper.setData("lang", locale == const Locale('ar') ?"ar":"en");
                    //   },
                    //   child: const Text("Language"),
                    // ),
                    DrawerContent(screenName: screenName, title: "aboutUsTitle".i18n(), imageSrc: "about_us_icon", onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUs(),));
                    }),
                    DrawerContent(screenName: screenName, title: "logoutTitle".i18n(), imageSrc: "sing_out_icon", onTap: ()async{
                      showToast("Please wait");
                      topicUnSubscribe();
                      try {
                        await CacheHelper.removeAllData();
                        await CacheHelper.setData("email", hubData?.userData?.email??"");
                        await FirebaseHelper.employees.doc(hubData?.userData?.employeeId)
                            .update({"userStatus": false, "lastSeen": DateTime.now().toString()}).then((value) async{
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RegistrationScreen(),), (route) => false);
                          });
                          } catch (e) {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RegistrationScreen(),), (route) => false);
                          }
                    }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// class LangWidget extends StatefulWidget {
//   const LangWidget({super.key});

//   @override
//   State<LangWidget> createState() => LangWidgetState();
// }

// class LangWidgetState extends State<LangWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children:[
//         ListTile(
//           onTap: (){
//             final locale = Localizations.localeOf(context);
//             // MainApp
//                 final myApp = context.findAncestorStateOfType<MainAppState>();
//                 myApp.changeLocale(locale == const Locale('ar') ? const Locale('en') : const Locale('ar'));
//                 CacheHelper.setData("lang", locale == const Locale('ar') ?"en":"ar");
//           },
//           leading: const Icon(Icons.language),title: const Text('Change lang'))
//       ]
//     );
//   }
// }