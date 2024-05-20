part of 'platform_bloc.dart';

@immutable
sealed class PlatformState {}

final class PlatformInitial extends PlatformState {}

final class PlatformLoading extends PlatformState {}
final class PlatformSuccess extends PlatformState {}
final class PlatformFailure extends PlatformState {
  final String msg;
  PlatformFailure(this.msg);
}
final class AppPageLoading extends PlatformState {}
final class AppPageSuccess extends PlatformState {}
final class AppPageFailure extends PlatformState {
  final String msg;
  AppPageFailure(this.msg);
}


final class AboutUsLoading extends PlatformState {}
final class AboutUSSuccess extends PlatformState {}
final class AboutUSFailure extends PlatformState {
  final String msg;
  AboutUSFailure(this.msg);
}

final class ContactUSLoading extends PlatformState {}
final class ContactUSSuccess extends PlatformState {
  final List<WebPair> contents;
  ContactUSSuccess(this.contents);
}
final class ContactUSFailure extends PlatformState {
  final String msg;
  ContactUSFailure(this.msg);
}