part of 'requests_cubit.dart';

@immutable
sealed class RequestsState {}

final class RequestsInitial extends RequestsState {}

final class ChangeScreenStatusState extends RequestsState {}
final class ChangeSelectionState extends RequestsState {}
final class SingleItemSelectionState extends RequestsState {}
final class InitVisitsDataState extends RequestsState {}
final class FilterAddNewplanStates extends RequestsState {}
final class FilterAddToPlanStates extends RequestsState {}

final class GetAllRequestsLoadingState extends RequestsState {}

final class GetAllRequestsSuccessState extends RequestsState {}

final class GetAllRequestsErrorState extends RequestsState {}

final class UpdateRequestsLoadingState extends RequestsState{}
final class UpdateRequestsSuccessState extends RequestsState{}
final class UpdateRequestsErrorState extends RequestsState{}