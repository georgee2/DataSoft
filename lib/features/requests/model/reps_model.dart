import 'package:data_soft/features/requests/model/request_details_model.dart';

class RepsModel {
  String? email;
  String? name;
  String? image;
  List<RequestsDetailsModel> data = [];
  RepsModel({this.email, this.name, this.image, required this.data});
}
