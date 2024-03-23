part of 'controller_bloc.dart';

@immutable
sealed class ControllerEvent {}

final class LanguageChange extends ControllerEvent {
  final String lang;
  LanguageChange(this.lang);
}
final class LanguageGet extends ControllerEvent {
}

final class ThemeChange extends ControllerEvent {
  final String theme;
  ThemeChange(this.theme);
}
final class ThemeGet extends ControllerEvent {
}

