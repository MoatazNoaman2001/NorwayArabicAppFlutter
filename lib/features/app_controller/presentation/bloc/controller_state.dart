part of 'controller_bloc.dart';

@immutable
sealed class ControllerState {}

final class ControllerInitial extends ControllerState {}

final class LangSetSuccess extends ControllerState {
  final bool state;

  LangSetSuccess(this.state);
}
final class LangGetSuccess extends ControllerState{
  final String lang;

  LangGetSuccess(this.lang);
}
final class LangFailure extends ControllerState{
  final String msg;

  LangFailure(this.msg);
}

final class ThemeSetSuccess extends ControllerState {
  final bool state;

  ThemeSetSuccess(this.state);
}
final class ThemeGetSuccess extends ControllerState{
  final String theme;

  ThemeGetSuccess(this.theme);
}
final class ThemeFailure extends ControllerState{
  final String msg;

  ThemeFailure(this.msg);
}
