import '../../today_plan/model/today_plan_model.dart';

class PlansOfDaysModel {
  Message? message;

  PlansOfDaysModel({this.message});

  PlansOfDaysModel.fromJson(Map<String, dynamic> json, {isUniqueDoctor}) {
    message = json['message'] != null
        ? Message.fromJson(json['message'], isUniqueDoctor)
        : null;
  }
}

class Message {
  bool? success;
  List<DoctorData> data = [];
  List<DoctorData> uniqueDoctorData = [];
  String? status;

  Message({this.success, required this.data});

  Message.fromJson(Map<String, dynamic> json, bool? isUniqueDoctor) {
    data = [];
    success = json['success'];
    if (json['data'] != null) {
      data = <DoctorData>[];
      json['data'].forEach((v) {
        if (isUniqueDoctor == true && uniqueDoctorData.isNotEmpty) {
          for (var i = 0; i < uniqueDoctorData.length; i++) {
            if (uniqueDoctorData[i].partyName == v['party_name']) {
              break;
            } else if (i == uniqueDoctorData.length - 1) {
              uniqueDoctorData.add(DoctorData.fromJson(v));
            }
          }
        } else {
          uniqueDoctorData.add(DoctorData.fromJson(v));
        }
        data.add(DoctorData.fromJson(v));
        if (status != null) {
          if (status != v['status_plan']) {
            status = "Partially Approved";
          }
        } else {
          status = v['status_plan'];
        }
      });
    }
  }
}
