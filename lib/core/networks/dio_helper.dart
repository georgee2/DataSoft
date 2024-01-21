import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:dio/dio.dart';

class DioHelper {
  //test
  // static late Dio dio;
  //production
  static late Dio dio2;
  static getInit() {
    ///////test
    // dio = Dio(BaseOptions(
    //     baseUrl: "http://154.38.165.213:1212/api/method/mobile_app.apis.",
    //     receiveDataWhenStatusError: true,
    //     headers: {
    //       'Content-Type': 'application/json',
    //       // 'Authorization': "token 3c7cbb0aae8d1c9:02c5d203476d6cd",
    //       'Authorization': "token ${hubData?.userData?.token}"
    //     }));
    //////production
        dio2 = Dio(BaseOptions(
        baseUrl: "http://197.161.38.203/api/method/mobile_app.apis.",
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': "token 3c7cbb0aae8d1c9:02c5d203476d6cd",
          'Authorization': "token ${hubData?.userData?.token}"
        }));
  }

  static Future postData({required String url, query}) async {
    return await dio2.post(
      url,
      queryParameters: query,
    );
  }

  static getData({required String url, queryParameters}) async {
    return await dio2.get(url, queryParameters: queryParameters);
  }

  static putData({required String url, required query}) async {
    return await dio2.put(url, queryParameters: query);
  }

  static delData({required String url, queryParameters}) async {
    return await dio2.delete(url, queryParameters: queryParameters);
  }
}
