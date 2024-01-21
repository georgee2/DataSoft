import 'dart:convert';

UserData? userData;
HubDataModel? hubData;
ManagerDataModel? managerData;

class HubDataModel {
  String? companyLogo;
  String? company;
  String? companylocation;
  String? macAddress;
  String? customerName;
  String? endDate;
  String? gressPeriod;
  double? allowedDistance;
  double? lat;
  double? long;
  int? isActive;
  String? startDate;
  HubUserData? userData;
  List<ServicesData> servicesData = [];

  HubDataModel(
      {this.companyLogo,
      this.customerName,
      this.endDate,
      this.gressPeriod,
      this.isActive,
      this.startDate,
      this.userData});

  HubDataModel.fromJson(Map<String, dynamic> json) {
    companyLogo = json['external_data']['company_data']['company_logo'];
    macAddress = json['external_data']['company_data']['mac_address'];
    companylocation = json['external_data']['company_data']['company_location'];
    allowedDistance = json['external_data']['company_data']['allowed_distance'];
    customerName = json['external_data']['company_data']['customer_name'];
    endDate = json['external_data']['company_data']['end_date'];
    gressPeriod = json['external_data']['company_data']['gress_period'];
    isActive = json['external_data']['company_data']['is_active'];
    startDate = json['external_data']['company_data']['start_date'];
    if (json['user_data'] != null) {
      userData = HubUserData.fromJson(json['user_data']);
      userData?.token = json['external_data']['token'];
      company = json['external_data']['company'];
    }
    json['external_data']['services'].forEach((element) {
      servicesData.add(ServicesData.fromJson(element));
    });
    if (json['external_data']['company_data']['company_location'] != null) {
      String jsonString =
          json['external_data']['company_data']['company_location'];

      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      if (jsonMap.containsKey("features") && jsonMap["features"].isNotEmpty) {
        var feature = jsonMap["features"][0];

        if (feature.containsKey("geometry") &&
            feature["geometry"].containsKey("coordinates")) {
          List<dynamic> coordinates = feature["geometry"]["coordinates"];

          if (coordinates.length == 2) {}
        }
      }
    }
  }
}

class HubUserData {
  String? email;
  String? employeeId;
  String? name;
  String? password;
  String? managerId;
  String? leaveApprover;
  String? expenseApprover;
  String? employeeAdvanceApprover;
  String? token;
  int? isActive;

  HubUserData(
      {this.email,
      this.employeeId,
      this.isActive,
      this.name,
      this.password,
      this.token});

  HubUserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    employeeId = json['employee_id'];
    isActive = json['is_active'];
    name = json['name'];
    password = json['password'];
    token = json['token'];
    managerId = json['manager_id'];
    leaveApprover = json['leave_approver'];
    expenseApprover = json['expense_approver'];
    employeeAdvanceApprover = json['employee_advance_approver'];
  }
}

class ServicesData {
  String? service;
  String? serviceCode;
  int? isActive;

  ServicesData({this.service, this.serviceCode, this.isActive});

  ServicesData.fromJson(Map<String, dynamic> json) {
    service = json['service'];
    serviceCode = json['service_code'];
    isActive = json['is_active'];
  }
}

class UserData {
  String? email;
  String? fullName;
  String? gender;
  String? birthDate;
  String? bannerImage;
  String? mobileNo;
  String? location;
  String? bio;
  String? profession;
  String? city;

  UserData(
      {this.email,
      this.fullName,
      this.gender,
      this.birthDate,
      this.bannerImage,
      this.mobileNo,
      this.location,
      this.bio,
      this.profession,
      this.city});

  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    fullName = json['full_name'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    bannerImage = json['banner_image'];
    mobileNo = json['mobile_no'];
    location = json['location'];
    bio = json['bio'];
    profession = json['profession'];
    city = json['city'];
  }
}

class ManagerDataModel {
  String? employeeId;
  String? user;
  String? managerName;
  bool? isManager;
  List? managersList = [];

  ManagerDataModel({this.employeeId, this.user, this.isManager});

  ManagerDataModel.fromJson(json, {bool fromLocal = false}) {
    json[0].forEach((element) {
      if (element['Employee_id'] != hubData?.userData?.employeeId) {
        employeeId = element['Employee_id'];
        managerName = element['employee_name'];
      }
    });
    managersList = json[0];
    managersList?.remove({
      "Employee_id": hubData?.userData?.employeeId,
      "user": hubData?.userData?.email,
      "employee_name": userData?.fullName
    });
    user = json[0][0]['user'];
    print("usssssseeeeeeeerrrrrrrrr::: $user");
    isManager = json[1]['role'] == "Area Manager";
  }
}
