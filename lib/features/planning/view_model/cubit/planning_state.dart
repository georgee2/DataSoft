part of 'planning_cubit.dart';

abstract class PlanningStates {}

class PlanningInitialState extends PlanningStates {}

// Clients Selection (Check Box Changes)
class ChangeClientsSelectionState extends PlanningStates {}

class ChangeIncludingClmState extends PlanningStates {}
class ChangeIncludingClmDataState extends PlanningStates {}

// Searching
class SearchingForClientsState extends PlanningStates {}

class ChangeDateTimeState extends PlanningStates {}

class ChangeAllClientsSelectionState extends PlanningStates {}

class ChangeScreenTypeState extends PlanningStates {}

// Get Planning Clms
class GetPlanningClmsLoadingState extends PlanningStates {}

class GetPlanningClmsSuccessState extends PlanningStates {}

class GetPlanningClmsErrorState extends PlanningStates {}

// Get All Planning Clients
class GetPlanningLoadingState extends PlanningStates {}

class GetPlanningSuccessState extends PlanningStates {}

class GetPlanningErrorState extends PlanningStates {}

// Search For Clients
class PlanningSearchLoadingState extends PlanningStates {}

class PlanningSearchSuccessState extends PlanningStates {}

class PlanningSearchErrorState extends PlanningStates {}

// Add New Plan
class AddNewPlanLoadingState extends PlanningStates {}

class AddNewPlanSuccessState extends PlanningStates {}

class AddNewPlanErrorState extends PlanningStates {}

// Time Filttering
class ChangeClientTimeFilteringState extends PlanningStates {}

class ChangeClientMedicalSpecialtyFilteringState extends PlanningStates {}

class ChangeClientLocationSelectedFilteringState extends PlanningStates {}
