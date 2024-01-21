import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/toast_message.dart';
import 'package:data_soft/features/chat/model/message_model.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/local/cache_helper.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/firebase_helper.dart';
part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationStates> {
  RegistrationCubit() : super(RegistrationInitialStates());
  static RegistrationCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  final List itemsSuggestionsData = [
    "assets/images/001.jpg",
    "assets/images/003.jpg",
    "assets/images/003.png",
  ];
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isHide = true;

  changePasswordState() {
    isHide = !isHide;
    emit(ChangePasswordState());
  }

  getEmail() async {
    final email = await CacheHelper.getData('email', String);
    if (email != null) {
      userName.text = email;
      emit(GetEmailFromLocalState());
    }
  }

  login(context) async {
    try {
      await DioHelper.getInit();
      hubData = null;
      emit(RegistrationLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_HUB_DATA,
          queryParameters: {
            "email": userName.text.trim(),
            "password": password.text.trim()
          });
      hubData = HubDataModel.fromJson(response.data['message']);
      CacheHelper.setData("hubData", response.data['message']);
      CacheHelper.setData("password", password.text.trim());
      emit(RegistrationSuccessState());
      await getProfileData(context);
      await getManagerData(context);
      updataFirebseFile();
      await addDatassToFirebase(context);
    } catch (e) {
      Navigator.pop(context);
      emit(RegistrationErrorState());
    }
  }

  updataFirebseFile() {
    FirebaseHelper.employees = FirebaseHelper.inst
        .collection(hubData!.customerName!)
        .doc('employees')
        .collection(
            hubData!.userData!.managerId ?? hubData!.userData!.employeeId!);
    FirebaseHelper.notificationPath = FirebaseHelper.employees
        .doc(managerData!.isManager == true
            ? hubData!.userData!.employeeId!
            : hubData!.userData!.managerId!)
        .collection("Notifications");
  }

  Future getProfileData(context) async {
    try {
      emit(GetUserDataLoadingState());
      Response response = await DioHelper.getData(
          url: EndPoints.GET_USER_DATA,
          queryParameters: {"email": hubData?.userData?.email});
      if (response.data['message'][0] != null) {
        userData = UserData.fromJson(response.data['message'][0]);
        CacheHelper.setData("userData", response.data['message'][0]);
        emit(GetUserDataSuccessState());
      } else {
        emit(GetUserDataErrorState());
        Navigator.pop(context);
      }
    } catch (e) {
      emit(GetUserDataErrorState());
      Navigator.pop(context);
    }
  }

  Future getManagerData(context) async {
    try {
      emit(GetManagerDataLoadingState());
      if (kDebugMode) {
        print("acccccccounnnnnnnt::::: ${userData!.email}");
      }
      Response response = await DioHelper.getData(
          url: EndPoints.GET_MANAGER_DATA,
          queryParameters: {"user": userData?.email});
      if (kDebugMode) {
        print("resssssponseeeeeeee:::: $response");
      }
      managerData = ManagerDataModel.fromJson(response.data['message']);
      if (kDebugMode) {
        print("registteeeerrrrr:::::: $managerData");
      }
      await CacheHelper.setData("managerData", response.data['message']);
      emit(GetManagerDataSuccessState());
    } catch (e) {
      emit(GetManagerDataErrorState());
      Navigator.pop(context);
    }
  }

  Future addDatassToFirebase(context) async {
    try {
      emit(AddDataToFirebaseLoadingState());
      await FirebaseHelper.employees
          .doc(hubData!.userData!.employeeId!)
          .get()
          .then((value) async {
        if (value.data() == null) {
          FirebaseUserData data = FirebaseUserData(
              lastMessage: '',
              isManager: managerData!.isManager,
              userImage: userData!.bannerImage,
              lastMessageDate: DateTime.now().toString(),
              lastSeen: "",
              userStatus: true,
              employeeId: hubData!.userData!.employeeId,
              userName: userData!.fullName);
          await FirebaseHelper.employees
              .doc(hubData!.userData!.employeeId!)
              .set(data.toJson())
              .catchError((e) {
            showSnackBar(context, text: e);
          });
          emit(AddDataToFirebaseSuccessState());
        } else {
          emit(AddDataToFirebaseSuccessState());
        }
      }).catchError((e) {
        showSnackBar(context, text: e);
      });
    } on FirebaseException catch (e) {
      showSnackBar(context, text: e.message);
      emit(AddDataToFirebaseErrorState());
    }
  }
}
