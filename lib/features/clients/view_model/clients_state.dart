part of 'clients_cubit.dart';

abstract class ClientsEvents {}

class ClientsInitial extends ClientsEvents {}

// Add New Expense And activity Choosing Client
class ChooseClientState extends ClientsEvents {}
class SearchingForClientsState extends ClientsEvents {}

class GetClientsLoadingState extends ClientsEvents {}

class GetClientsSuccessState extends ClientsEvents {}

class GetClientsErrorState extends ClientsEvents {}

class ChangeClientTimeFilteringState extends ClientsEvents {}

class ChangeClientMedicalSpecialtyFilteringState extends ClientsEvents {}

class ChangeClientLocationSelectedFilteringState extends ClientsEvents {}

// Clients Details
abstract class ClientDetailsEvents {}

class ClientDetailsInitial extends ClientDetailsEvents {}

class GetClientsDetailsLoadingState extends ClientDetailsEvents {}

class GetClientsDetailsSuccessState extends ClientDetailsEvents {}

class GetClientsDetailsErrorState extends ClientDetailsEvents {}
