part of 'requests_cycles_cubit.dart';

@immutable
sealed class RequestsCyclesState {}

final class RequestsCyclesInitial extends RequestsCyclesState {}
final class SetHomeCyclesState extends RequestsCyclesState {}
