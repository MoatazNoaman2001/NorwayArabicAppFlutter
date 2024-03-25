part of 'youtube_stream_bloc.dart';

@immutable
sealed class YoutubeStreamEvent {}


class GetYoutubeLink extends YoutubeStreamEvent{}