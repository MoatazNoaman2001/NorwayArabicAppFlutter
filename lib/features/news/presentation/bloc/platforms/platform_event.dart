part of 'platform_bloc.dart';

@immutable
sealed class PlatformEvent {}

class GetPlatFromList extends PlatformEvent{}
class GetAboutUSList extends PlatformEvent{}
