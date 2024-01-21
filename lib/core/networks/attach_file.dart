import 'package:dio/dio.dart';
import '../../features/registration/model/registration_model.dart';
import '../local/storage.dart';

// This Function to posting attach file to ERP system to get attach file url and this function used in (Activities, Expenses, Permissions, Settlement, Tasks, Vacation, Visits)
Future<String?> getAttachUrl() async {
  try {
    final file = await getAttachFileFromDevice();
    if (file != null) {
      FormData formData = FormData.fromMap(
        {
          'file': await MultipartFile.fromFile(
            file.path.toString(),
            filename: file.name.toString(),
          ),
        },
      );
      Dio dio = Dio(BaseOptions(
          baseUrl: "http://154.38.165.213:1212/api/method/",
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "token ${hubData!.userData!.token}"
          }));
      Response response = await dio.post("upload_file", data: formData);
      if (response.statusCode == 200 &&
          response.data['message']['file_url'] != null) {
        return response.data['message']['file_url'];
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
