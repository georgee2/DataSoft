part of 'today_plan_cubit.dart';

@immutable
sealed class TodayPlanStates {}

class TodayPlanInitialState extends TodayPlanStates {}

class ChangeScreenTypeState extends TodayPlanStates {}

// Get Today Plans Or Today Visits
class GetTodayPlansLoadingState extends TodayPlanStates {}

class GetTodayPlansSuccessState extends TodayPlanStates {}

class GetTodayPlansErorState extends TodayPlanStates {}

// Unplanned Plans Or Visits
class GetAllPlansLoadingState extends TodayPlanStates {}

class GetAllPlansSuccessState extends TodayPlanStates {}

class GetAllPlansErorState extends TodayPlanStates {}

// Unplanned Plans Or Visits
class ChangeDoctorDataState extends TodayPlanStates {}
class AddUnplanndDoctorDataState extends TodayPlanStates {}
class UnplanVisitLoadingState extends TodayPlanStates {}

class UnplanVisitSuccessState extends TodayPlanStates {}

class UnplanVisitErorState extends TodayPlanStates {}

class ChangeVisitStatus extends TodayPlanStates {}
