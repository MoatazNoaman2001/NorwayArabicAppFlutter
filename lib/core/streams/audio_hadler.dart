import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final _player = AudioPlayer();

  UriAudioSource _createAudioSource(MediaItem item) {
    return ProgressiveAudioSource(Uri.parse(item.id));
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      mediaItem.add(playlist[index]);
    });
  }

  void _broadcastState(PlaybackEvent event){
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (_player.playing) MediaControl.pause else MediaControl.play,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekBackward,
          MediaAction.seekForward,
        },
        processingState: const {
          ProcessingState.idle : AudioProcessingState.idle,
          ProcessingState.loading : AudioProcessingState.loading,
          ProcessingState.buffering : AudioProcessingState.buffering,
          ProcessingState.ready : AudioProcessingState.ready,
          ProcessingState.completed : AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex
      )
    );
  }
  Future<void> initStreams({required List<MediaItem> streams}) async{
    _player.playbackEventStream.listen(_broadcastState);
    final audioSource = streams.map(_createAudioSource);

    await _player.setAudioSource(ConcatenatingAudioSource(children: audioSource.toList()));

    queue.value.clear();
    queue.value.addAll(streams);
    queue.add(queue.value);

    _listenForCurrentSongIndexChanges();

    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) skipToNext();
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) async => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async{
    await _player.seek(Duration.zero , index: index);
    play();
  }

  @override
  Future<void> skipToPrevious() async => _player.seekToPrevious();
  @override
  Future<void> skipToNext() async => _player.seekToNext();

  @override
  BehaviorSubject<PlaybackState> get playbackState => super.playbackState;

  @override
  BehaviorSubject<List<MediaItem>> get queue => super.queue;

  @override
  BehaviorSubject<MediaItem?> get mediaItem => super.mediaItem;
}
