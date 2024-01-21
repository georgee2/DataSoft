part of 'reports_cubit.dart';

@immutable
sealed class ReportsState {}

class ReportsInitial extends ReportsState {}

class GetReportsLoadingState extends ReportsState {}

class GetReportsSuccessState extends ReportsState {}

class GetReportsErrorState extends ReportsState {}
