part of 'expenses_cubit.dart';

@immutable
abstract class ExpensesStates {}

class ExpensesInitialState extends ExpensesStates {}

class GetAttachFileLoadingState extends ExpensesStates {}

class GetAttachFileSuccessState extends ExpensesStates {}

class GetAttachFileErrorState extends ExpensesStates {}

class ChangeScreenTypeState extends ExpensesStates {}

class GetExpensesLoadingState extends ExpensesStates {}

class GetExpensesSuccessState extends ExpensesStates {}

class GetExpensesErrorState extends ExpensesStates {}

class ChangeSelectionState extends ExpensesStates {}

// Get Expenses Types
class GetExpensesTypesLoadingState extends ExpensesStates {}

class GetExpensesTypesSuccessState extends ExpensesStates {}

class GetExpensesTypesErrorState extends ExpensesStates {}

class AddNewExpenseLoadingState extends ExpensesStates {}

class AddNewExpenseSuccessState extends ExpensesStates {}

class AddNewExpenseErrorState extends ExpensesStates {}
