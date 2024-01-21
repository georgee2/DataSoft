import 'dart:io';
import 'app.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:data_soft/core/local/cache_helper.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  final localHubData = await CacheHelper.getData("hubData", Map);
  final localUserData = await CacheHelper.getData("userData", Map);
  final localManagerData = await CacheHelper.getData("managerData", Map);
  hubData = localHubData != null ? HubDataModel.fromJson(localHubData) : null;
  userData = localUserData != null ? UserData.fromJson(localUserData) : null;
  managerData = localManagerData != null
      ? ManagerDataModel.fromJson(localManagerData, fromLocal: true)
      : null;
  await DioHelper.getInit();
  var lang = await CacheHelper.getData("lang", String);
  runApp(MainApp(currentLang: lang));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
