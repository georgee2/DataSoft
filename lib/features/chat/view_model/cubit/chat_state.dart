part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class MessageSendingLoadingState extends ChatState {}

final class MessageSendingSuccessState extends ChatState {}

final class MessageSendingErrorState extends ChatState {}
