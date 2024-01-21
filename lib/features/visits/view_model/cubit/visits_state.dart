part of 'visits_cubit.dart';

@immutable
sealed class VisitsStates {}

class VisitsInitialState extends VisitsStates {}

class OnCancelState extends VisitsStates {}
class ChangeIncludingClmState extends VisitsStates {}
class ChangeIncludingClmDataState extends VisitsStates {}

class OnOpenState extends VisitsStates {}

class StartVisitState extends VisitsStates {}

// Update Cliet location
class UpdateLocationLoadingState extends VisitsStates {}

class UpdateLocationSuccessState extends VisitsStates {}

class UpdateLocationErrorState extends VisitsStates {}

// Get Doctor Data
class GetDoctorDetailsLoadingState extends VisitsStates {}

class GetDoctorDetailsSuccessState extends VisitsStates {}

class GetDoctorDetailsErrorState extends VisitsStates {}

// Get Doctor Data
class GetOldFeedbackLoadingState extends VisitsStates {}

class GetOldFeedbackSuccessState extends VisitsStates {}

class GetOldFeedbackErrorState extends VisitsStates {}

// End Normal Visit
class EndVisitLoadingState extends VisitsStates {}

class EndVisitSuccessState extends VisitsStates {}

class EndVisitErrorState extends VisitsStates {}

// Timer State
class CountingTimerState extends VisitsStates {}

class StopedTimerState extends VisitsStates {}

// Get CLM Items
class GetCLMItemsLoadingState extends VisitsStates {}

class GetCLMItemsSuccessState extends VisitsStates {}

class GetCLMItemsErrorState extends VisitsStates {}

// Get CLM Pages
class GetCLMPagesLoadingState extends VisitsStates {}

class GetCLMPagesSuccessState extends VisitsStates {}

class GetCLMPagesErrorState extends VisitsStates {}

// Change Page View Count
class ChangePageCountState extends VisitsStates {}

// Postpone
class ChangeDateTimeState extends VisitsStates {}

class PostponeLoadingState extends VisitsStates {}

class PostponeSuccessState extends VisitsStates {}

class PostponeErrorState extends VisitsStates {}

// Update Feedback
class UpdateFeedbackLoadingState extends VisitsStates {}

class UpdateFeedbackSuccessState extends VisitsStates {}

class UpdateFeedbackErrorState extends VisitsStates {}

// Get Questions
class GetQuestionsLoadingState extends VisitsStates {}

class GetQuestionsSuccessState extends VisitsStates {}

class GetQuestionsErrorState extends VisitsStates {}

// Get AttachFile
class GetAttachFileLoadingState extends VisitsStates {}

class GetAttachFileSuccessState extends VisitsStates {}

class GetAttachFileErrorState extends VisitsStates {}
// Update Questions
class UpdateQuestionsLoadingState extends VisitsStates {}

class UpdateQuestionsSuccessState extends VisitsStates {}

class UpdateQuestionsErrorState extends VisitsStates {}
