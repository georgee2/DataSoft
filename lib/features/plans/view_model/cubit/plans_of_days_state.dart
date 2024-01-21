part of 'plans_of_days_cubit.dart';

@immutable
sealed class PlansOfDaysStates {}

class PlansOfDaysInitialStates extends PlansOfDaysStates {}

class SetDataToPlansModelStates extends PlansOfDaysStates {}

class ChangeDateTimeState extends PlansOfDaysStates {}

// Filtering
// Add New Plan
class FilterAddNewplanStates extends PlansOfDaysStates {}

// Add to plan
class FilterAddToPlanStates extends PlansOfDaysStates {}

// Get All Plans
class PlansOfDaysLoadingStates extends PlansOfDaysStates {}

class PlansOfDaysSuccessStates extends PlansOfDaysStates {}

class PlansOfDaysErrorStates extends PlansOfDaysStates {}
// Get All Plans using from and to date
class PlansfromAndToDateLoadingStates extends PlansOfDaysStates {}

class PlansfromAndToDateSuccessStates extends PlansOfDaysStates {}

class PlansfromAndToDateErrorStates extends PlansOfDaysStates {}

// Get Custom Visits by Date
class GetCustomDateVisitsLoadingStates extends PlansOfDaysStates {}

class GetCustomDateVisitsSuccessStates extends PlansOfDaysStates {}

class GetCustomDateVisitsErrorStates extends PlansOfDaysStates {}

// Delete Visit
class DeleteVisitLoadingStates extends PlansOfDaysStates {}

class DeleteVisitSuccessStates extends PlansOfDaysStates {}

class DeleteVisitErrorStates extends PlansOfDaysStates {}

// Get Last Visit
class GetLastVisitLoadingStates extends PlansOfDaysStates {}

class GetLastVisitSuccessStates extends PlansOfDaysStates {}

class GetLastVisitErrorStates extends PlansOfDaysStates {}
