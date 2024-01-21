part of 'activities_cubit.dart';

@immutable
abstract class ActivitiesStates {}

class ActivitiesInitialState extends ActivitiesStates {}

class GetAttachFileLoadingState extends ActivitiesStates {}

class GetAttachFileSuccessState extends ActivitiesStates {}

class GetAttachFileErrorState extends ActivitiesStates {}

class ChangeScreenTypeState extends ActivitiesStates {}

class ChangeSelectionTypeState extends ActivitiesStates {}

class GetActivitiesLoadingState extends ActivitiesStates {}

class GetActivitiesSuccessState extends ActivitiesStates {}

class GetActivitiesErrorState extends ActivitiesStates {}

class GetActivityTypesLoadingState extends ActivitiesStates {}

class GetActivityTypesSuccessState extends ActivitiesStates {}

class GetActivityTypesErrorState extends ActivitiesStates {}
