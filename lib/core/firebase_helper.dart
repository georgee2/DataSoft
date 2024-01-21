import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/registration/model/registration_model.dart';

class FirebaseHelper {
  static FirebaseFirestore inst = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> employees = inst
      .collection(hubData!.customerName!)
      .doc('employees')
      .collection(
          hubData!.userData!.managerId ?? hubData!.userData!.employeeId!);

  static CollectionReference<Map<String, dynamic>> notificationPath = employees
      .doc(managerData!.isManager == true
          ? hubData!.userData!.employeeId!
          : hubData!.userData!.managerId!)
      .collection("Notifications");
}
