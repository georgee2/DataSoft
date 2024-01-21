part of 'settlement_cubit.dart';

@immutable
sealed class SettlementStates {}

class SettlementInitialState extends SettlementStates {}

class ChangeScreenTypeState extends SettlementStates {}

class ChangeSettlementTypeState extends SettlementStates {}
class ChangeSettlementForState extends SettlementStates {}

// Get Attach file
class GetAttachFileLoadingState extends SettlementStates {}

class GetAttachFileSuccessState extends SettlementStates {}

class GetAttachFileErrorState extends SettlementStates {}
// Get Settlement States
class GetSettlementLoadingState extends SettlementStates {}

class GetSettlementSuccessState extends SettlementStates {}

class GetSettlementErrorState extends SettlementStates {}

// Add Settlement States
class AddSettlementLoadingState extends SettlementStates {}

class AddSettlementSuccessState extends SettlementStates {}

class AddSettlementErrorState extends SettlementStates {}

// Get Settlement For?
class GetSettlementForLoadingState extends SettlementStates {}

class GetSettlementForSuccessState extends SettlementStates {}

class GetSettlementForErrorState extends SettlementStates {}
