part of 'registration_cubit.dart';

@immutable
abstract class RegistrationStates {}

class ChangePasswordState extends RegistrationStates {}

class GetEmailFromLocalState extends RegistrationStates {}
// Get Hub Data
class RegistrationInitialStates extends RegistrationStates {}

class RegistrationLoadingState extends RegistrationStates {}

class RegistrationSuccessState extends RegistrationStates {}

class RegistrationErrorState extends RegistrationStates {}

// Get UserData
class GetUserDataLoadingState extends RegistrationStates {}

class GetUserDataSuccessState extends RegistrationStates {}

class GetUserDataErrorState extends RegistrationStates {}

// Get Managet Data
class GetManagerDataLoadingState extends RegistrationStates {}

class GetManagerDataSuccessState extends RegistrationStates {}
class GetManagerDataSuccessState1 extends RegistrationStates {}

class GetManagerDataErrorState extends RegistrationStates {}

// Add Data To Firebase
final class AddDataToFirebaseLoadingState extends RegistrationStates {}

final class AddDataToFirebaseSuccessState extends RegistrationStates {}

final class AddDataToFirebaseErrorState extends RegistrationStates {}
