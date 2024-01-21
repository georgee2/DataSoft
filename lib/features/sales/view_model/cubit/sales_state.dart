part of 'sales_cubit.dart';

@immutable
sealed class SalesStates {}

final class SalesInitialState extends SalesStates {}

final class ChangeDateTimeState extends SalesStates {}

final class ChangeUintsState extends SalesStates {}
final class ChangeProductState extends SalesStates {}

// Get Products
final class GetSalesLoadingState extends SalesStates {}

final class GetSalesSuccessState extends SalesStates {}

final class GetSalesErrorState extends SalesStates {}

// Filttering
final class ChangeTimeState extends SalesStates {}

final class ChangeFilterProductState extends SalesStates {}

final class ChangeFilterBrickState extends SalesStates {}

final class ChangeFilterDistributorsState extends SalesStates {}
