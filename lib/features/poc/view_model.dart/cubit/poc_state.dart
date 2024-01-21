part of 'poc_cubit.dart';

@immutable
abstract class PocStates {}

class PocInitialState extends PocStates {}

class ChangeShowingItems extends PocStates {}

class PocLoadingState extends PocStates {}

class PocSuccessState extends PocStates {}

class PocErroeState extends PocStates {}

class PocAddFirstTimeState extends PocStates {}

class PocAddWhenContainsDataState extends PocStates {}

class PocAddWhenNotFoundDataState extends PocStates {}
