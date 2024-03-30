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
  final bool theme;

  ThemeGetSuccess(this.theme);
}
final class ThemeFailure extends ControllerState{
  final String msg;

  ThemeFailure(this.msg);
}

final class PlayInBackGroundSetSuccess extends ControllerState {
  final bool state;

  PlayInBackGroundSetSuccess(this.state);
}
final class PlayInBackGroundGetSuccess extends ControllerState{
  final bool value;

  PlayInBackGroundGetSuccess(this.value);
}
final class PlayInBackGroundFailure extends ControllerState{
  final String msg;

  PlayInBackGroundFailure(this.msg);
}
