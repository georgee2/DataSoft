class RequestsDetailsModel {
  String? requestId;
  String? repName;
  String? postingDate;
  String? type;
  String? amount;
  String? clientName;
  String? comment;
  String? employeeId;
  String? statusPlan;
  String? email;
  String? image;
  bool isSelected = false;

  RequestsDetailsModel(
      {required this.requestId,
      required this.employeeId,
      required this.repName,
      required this.postingDate,
      this.statusPlan,
      this.email,
      this.image,
      required this.type,
      required this.amount,
      required this.clientName,
      required this.comment});
}
