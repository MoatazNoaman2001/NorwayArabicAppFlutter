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
