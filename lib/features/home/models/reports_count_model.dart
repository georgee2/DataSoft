class ReportsCount {
  late UnconveredDoctorsModel unconveredVisit;
  late UnPlannedVisitsModel unPlannedVisit;
  late CancelledVisitsModel cancelledVisit;
  String? unconveredVisitsPercent;
  String? unPlannedVisitsPercent;
  String? cancelledVisitsPercent;
  ReportsCount.fromJson(Map<String, dynamic> json) {
    unconveredVisit = UnconveredDoctorsModel.fromJson(json);
    unPlannedVisit = UnPlannedVisitsModel.fromJson(json);
    cancelledVisit = CancelledVisitsModel.fromJson(json);
    if (unconveredVisit.cancelledVisitsCount != "0" &&
        unPlannedVisit.unPlannedVisitsCount != "0" &&
        cancelledVisit.cancelledVisitsCount != "0") {
      unconveredVisitsPercent =
          "${((double.parse(unconveredVisit.cancelledVisitsCount) / (double.parse(unconveredVisit.cancelledVisitsCount) + double.parse(unPlannedVisit.unPlannedVisitsCount) + double.parse(cancelledVisit.cancelledVisitsCount))) * 100).toInt()} %";
      unPlannedVisitsPercent =
          "${((double.parse(unPlannedVisit.unPlannedVisitsCount) / (double.parse(unconveredVisit.cancelledVisitsCount) + double.parse(unPlannedVisit.unPlannedVisitsCount) + double.parse(cancelledVisit.cancelledVisitsCount))) * 100).toInt()} %";
      cancelledVisitsPercent =
          "${((double.parse(cancelledVisit.cancelledVisitsCount) / (double.parse(unconveredVisit.cancelledVisitsCount) + double.parse(unPlannedVisit.unPlannedVisitsCount) + double.parse(cancelledVisit.cancelledVisitsCount))) * 100).toInt()} %";
    }
  }
}

class UnconveredDoctorsModel {
  late String cancelledVisitsCount;

  UnconveredDoctorsModel.fromJson(Map<String, dynamic> json) {
    cancelledVisitsCount =
        json['message']['uncovered_opportunity_count'].toString();
  }
}

class UnPlannedVisitsModel {
  late String unPlannedVisitsCount;
  UnPlannedVisitsModel.fromJson(Map<String, dynamic> json) {
    unPlannedVisitsCount =
        json['message']['unplanned_opportunity_count'].toString();
  }
}

class CancelledVisitsModel {
  late String cancelledVisitsCount;

  CancelledVisitsModel.fromJson(Map<String, dynamic> json) {
    cancelledVisitsCount =
        json['message']['cancelled_opportunity_count'].toString();
  }
}
