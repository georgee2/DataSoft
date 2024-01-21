part of 'available_cubit.dart';

@immutable
sealed class AvailableStates {}

final class AvailableInitialStates extends AvailableStates {}

final class GetAvailableBudgetLoadingState extends AvailableStates {}

final class GetAvailableBudgetSuccessState extends AvailableStates {}

final class GetAvailableBudgetErrorState extends AvailableStates {}
