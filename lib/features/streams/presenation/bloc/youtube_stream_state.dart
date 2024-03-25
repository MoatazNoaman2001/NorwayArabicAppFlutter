part of 'youtube_stream_bloc.dart';

@immutable
sealed class YoutubeStreamState {}

final class YoutubeStreamInitial extends YoutubeStreamState {}

final class YoutubeStreamLoading extends YoutubeStreamState {}
final class YoutubeStreamSuccess extends YoutubeStreamState {
  final String link;
  YoutubeStreamSuccess(this.link);
}
final class YoutubeStreamFailure extends YoutubeStreamState {
  final String msg;
  YoutubeStreamFailure(this.msg);
}
