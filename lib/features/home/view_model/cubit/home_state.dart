part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class SetHomeCyclesState extends HomeState {}

// Counts
class GetCountsLoadingState extends HomeState {}

class GetCountsSuccessState extends HomeState {}

class GetCountsErrorState extends HomeState {}

// Status Percentages
class GetStatusPercentagesLoadingState extends HomeState {}

class GetStatusPercentagesSuccessState extends HomeState {}

class GetStatusPercentagesErrorState extends HomeState {}

// Check Hub Data
class CheckHubDataLoadingState extends HomeState {}

class CheckHubDataSuccessState extends HomeState {}

class CheckHubDataErrorState extends HomeState {}
