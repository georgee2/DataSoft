part of 'vacation_cubit.dart';

abstract class VacationStates {}

class VacationInitial extends VacationStates {}

// Get Vavcation First Time
class GetVacationLoadingState extends VacationStates {}

class GetVacationSuccessState extends VacationStates {}

class GetVacationErrorState extends VacationStates {}

// Get Vacatoins Types
class GetVacationsTypesLoadingState extends VacationStates {}

class GetVacationsTypesSuccessState extends VacationStates {}

class GetVacationsTypesErrorState extends VacationStates {}

// Get Balance
class GetBalanceLoadingState extends VacationStates {}

class GetBalanceSuccessState extends VacationStates {}

class GetBalanceErrorState extends VacationStates {}

// Change View Type is Approved or Pending...
class ChangeViewTypeState extends VacationStates {}

// Choose Date Time from and to
class ChangePickerDateTimeState extends VacationStates {}

class SubmitDateTimeState extends VacationStates {}

class CloseDateTimeState extends VacationStates {}

// Get Attach File
class GetAttachFileLoadingState extends VacationStates {}

class GetAttachFileSuccessState extends VacationStates {}

class GetAttachFileErrorState extends VacationStates {}

// Add New Vacation
class AddNewVacationLoadingState extends VacationStates {}

class AddNewVacationLSuccessState extends VacationStates {}

class AddNewVacationErrorState extends VacationStates {}

class ChangeAddNewVacationState extends VacationStates {}
