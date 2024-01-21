part of 'permissions_cubit.dart';

@immutable
sealed class PermissionsStates {}

final class PermissionsInitialState extends PermissionsStates {}

// Get All Permissions
final class GetPermissionsLoadingState extends PermissionsStates {}

final class GetPermissionsSuccessState extends PermissionsStates {}

final class GetPermissionsErrorState extends PermissionsStates {}

// Get Attach file
final class GetAttachFileLoadingState extends PermissionsStates {}

final class GetAttachFileSuccessState extends PermissionsStates {}

final class GetAttachFileErrorState extends PermissionsStates {}

// Change Time in Add Permission
final class ChangePermissioninitTimeState extends PermissionsStates {}

final class ChangePermissionFromTimeState extends PermissionsStates {}

final class ChangePermissionToTimeState extends PermissionsStates {}

// Get Permissions Types
final class SelectPermissionsTypeLoadingState extends PermissionsStates {}

final class GetPermissionsTypesLoadingState extends PermissionsStates {}

final class GetPermissionsTypesSuccessState extends PermissionsStates {}

final class GetPermissionsTypesErrorState extends PermissionsStates {}

// Add New Permissions
final class AddPermissionsLoadingState extends PermissionsStates {}

final class AddPermissionsSuccessState extends PermissionsStates {}

final class AddPermissionsErrorState extends PermissionsStates {}
