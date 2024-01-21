import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/toast_message.dart';
import 'package:vibration/vibration.dart';
import 'package:data_soft/core/constants.dart';
import 'features/home/view_model/cubit/home_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'features/notifications/view_model/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/registration/view/registration_screen.dart';
import 'features/splash_screen/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
dynamic viewNotificationScreen;

class MainApp extends StatefulWidget {
  final currentLang;
  const MainApp({
    super.key, this.currentLang,
  });

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  String? notificationType;
  Locale? _locale;
  var lang;

  changeLocale(String locale) {
    setState(() {
      lang = locale;
    });
  }

  @override
  void initState() {
    lang = widget.currentLang;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {});
      notificationType = event.data['type'].toString();
    });
    FirebaseMessaging.onMessage.listen((message) async {
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate();
      }
      showToast("You have a new notification", color: pendingColor);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getPermission();
    setupInteractedMessage();
    LocalJsonLocalization.delegate.directories = ['assets/lang'];

    return MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(
              lazy: false, create: (context) => HomeCubit()..initUserState()),
        ],
        child: hubData != null && hubData?.userData != null
            ? MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: lang == "ar" ? const Locale("ar") : const Locale("en"),
                localeResolutionCallback: (locale, supportedLocales) {
                  if (supportedLocales.contains(locale)) {
                    return locale;
                  }
                  if (locale?.languageCode == 'en') {
                    return const Locale('en');
                  }
                  return const Locale('ar');
                },
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  LocalJsonLocalization.delegate,
                ],
                supportedLocales: const [
                  Locale('ar'),
                  Locale('en'),
                ],
                theme: ThemeData(
                    appBarTheme: const AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle.dark,
                      toolbarHeight: 0,
                      elevation: 0,
                      backgroundColor: primaryColor,
                    ),
                    scaffoldBackgroundColor: bgColor),
                navigatorKey: navigatorKey,
                home: SplashScreen(notificationType: notificationType),
              )
            : MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle.dark,
                    toolbarHeight: 0,
                    elevation: 0,
                    backgroundColor: primaryColor,
                  ),
                  scaffoldBackgroundColor: bgColor,
                ),
                navigatorKey: navigatorKey,
                locale: lang == "ar" ? const Locale("ar") : const Locale("en"),
                localeResolutionCallback: (locale, supportedLocales) {
                  if (supportedLocales.contains(locale)) {
                    return locale;
                  }

                  if (locale?.languageCode == 'en') {
                    return const Locale('en');
                  }
                  return const Locale('ar');
                },
                localizationsDelegates: [
                  LocalJsonLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('ar'),
                  Locale('en'),
                ],
                home: const RegistrationScreen(),
              ));
  }
}
