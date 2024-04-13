part of 'details_bloc.dart';

@immutable
sealed class DetailsEvent {}

class GetNewDetails extends DetailsEvent{
  final String url;
  GetNewDetails(this.url);
}

class GetTiktokEmbed extends DetailsEvent{
  final String url;
  GetTiktokEmbed(this.url);
}