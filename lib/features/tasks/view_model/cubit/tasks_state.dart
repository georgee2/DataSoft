part of 'tasks_cubit.dart';

@immutable
abstract class TasksStates {}

class TasksInitialState extends TasksStates {}

// Change Screen Type
class ChangeScreenType extends TasksStates {}

// Get Al Task Or Todo
class GetTasksLoadingState extends TasksStates {}

class GetTasksSuccessState extends TasksStates {}

class GetTasksErrorState extends TasksStates {}

// Get Attach File
class GetAttachFileLoadingState extends TasksStates {}

class GetAttachFileSuccessState extends TasksStates {}

class GetAttachFileErrorState extends TasksStates {}

// Add New Task Or Todo
class ChangeTodoTypeState extends TasksStates {}

class ChangeTodoPriorityState extends TasksStates {}

class ChangeAssignedToState extends TasksStates {}

class AddNewTaskLoadingState extends TasksStates {}

class AddNewTaskSuccessState extends TasksStates {}

class AddNewTaskErrorState extends TasksStates {}

// Update Task Or Todo
class ChangeTaskState extends TasksStates {}

class UpdatingTaskLoadingState extends TasksStates {}

class UpdatingTaskSuccessState extends TasksStates {}

class UpdatingTaskErrorState extends TasksStates {}

// Add New Task

class ChangeDateTimeState extends TasksStates {}

class ChangeRepSelectionState extends TasksStates {}
