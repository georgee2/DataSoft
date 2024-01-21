part of 'check_in_cubit.dart';

@immutable
sealed class CheckInStates {}

final class CheckInInitialState extends CheckInStates {}

final class GetLocalCheckingDataState extends CheckInStates {}
final class ChangeLocalCheckingDataState extends CheckInStates {}

final class ChangeItemState extends CheckInStates {}

final class GetCheckInLoadingState extends CheckInStates {}

final class GetCheckInSuccessState extends CheckInStates {}

final class GetCheckInErrorState extends CheckInStates {}

// Fitering
final class FitlerAddedFirstTimeState extends CheckInStates {}

final class FitlerAddedState extends CheckInStates {}

final class FitlerUpdatignState extends CheckInStates {}

// Post Checking State is checking in or out
final class AddCheckingLoadingState extends CheckInStates {}

final class AddCheckingSuccessState extends CheckInStates {}

final class AddCheckingErrorState extends CheckInStates {}
