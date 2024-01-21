part of 'attendance_cubit.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitial extends AttendanceState {}

final class GetAttendanceLoadingState extends AttendanceState {}

final class GetAttendanceSuccessState extends AttendanceState {}

final class GetAttendanceErrorState extends AttendanceState {}
