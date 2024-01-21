import 'dart:math';
import 'package:data_soft/features/registration/model/registration_model.dart';

class AppValidations {
  // ignore: body_might_complete_normally_nullable
  static bool? screenValidation(code) {
    if (hubData!.servicesData.isNotEmpty) {
      for (var i = 0; i < hubData!.servicesData.length;) {
        if (hubData!.servicesData[i].serviceCode == code &&
            hubData!.servicesData[i].isActive == 1) {
          return true;
        } else if (i == hubData!.servicesData.length - 1) {
          return false;
        } else {
          i++;
        }
      }
    } else {
      return false;
    }
  }

  // set The user location and target location to culculate
  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 1000 * 12742 * asin(sqrt(a));
  }
}
