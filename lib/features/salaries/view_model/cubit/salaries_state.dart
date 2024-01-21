part of 'salaries_cubit.dart';

@immutable
sealed class SalariesStates {}

final class SalariesInitialState extends SalariesStates {}
final class ChangeSalaryItem extends SalariesStates {}
// Get All Salaries
final class SalariesLoadingState extends SalariesStates {}
final class SalariesSuccessState extends SalariesStates {}
final class SalariesErrorState extends SalariesStates {}
