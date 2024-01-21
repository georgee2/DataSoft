import 'package:data_soft/core/constants.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/features/profile/widgets/profile_widgets.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '../../../app.dart';
import '../../../core/local/cache_helper.dart';
import '../../registration/model/registration_model.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final myApp = context.findAncestorStateOfType<MainAppState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(
        screenName: "Profile",
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        CustAppBar(
          title: "profileTitle".i18n(),
          scaffoldKey: scaffoldKey,
          imageSrc: 'profile_icon',
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff3FC3FE), Color(0xff0B8FD5)])),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: custProviderNetWorkImage(
                              image:
                                  'http://197.161.38.203${userData?.bannerImage}',
                              radius: 60),
                        ),
                      ],
                    ),
                    Text(
                      userData!.fullName.toString(),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    if (userData!.bio != null)
                      Text(
                        userData!.bio.toString(),
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                  ]),
                ),
                userDetails(
                    title: userData!.email!.toString(), icon: "mail_icon"),
                userDetails(
                    title: managerData!.isManager! ? "Area Manager" : "REP",
                    icon: "user_icon"),
                if (userData!.mobileNo != null)
                  userDetails(
                      title: userData!.mobileNo.toString(), icon: "phone_icon"),
                if (userData!.location != null)
                  userDetails(
                      title: userData!.location!.toString(),
                      icon: "location_icon"),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("English", style: TextStyle(color: primaryColor),),
                        Switch(
                          value:  myApp!.lang == "ar" ? true : false,
                          onChanged: (val) async{
                            final locale = Localizations.localeOf(context);
                            myApp.changeLocale(locale == const Locale("ar") ? "en" : "ar");
                            await CacheHelper.setData("lang", locale == const Locale("ar") ? "en" : "ar");
                          },
                        ),
                        const Text("عربي", style: TextStyle(color: primaryColor),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
