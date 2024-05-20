part of 'platform_bloc.dart';

@immutable
sealed class PlatformEvent {}

class GetPlatFromList extends PlatformEvent{}
class GetAppPageList extends PlatformEvent{}
class GetAboutUSList extends PlatformEvent{}
class ContactUSList extends PlatformEvent{}
