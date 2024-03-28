import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:norway_flutter_app/core/streams/audio_hadler.dart';

class StreamsProvider extends ChangeNotifier {
  List<MediaItem> _songs = [];

  List<MediaItem> get songs => _songs;
  bool _isLoading = true;

  bool get isLoading => _isLoading;


  Future<void> loadStreams(MyAudioHandler handler) async{
    try {
      final List<MediaItem> queue = List.empty()
        ..add(MediaItem(
            id: "http://63.141.232.90:9302/stream?type=http&nocache=26",
            title: "Norway audio stream")
        );

      handler.initStreams(streams: queue);
      _isLoading = false;
      notifyListeners();
    }catch (e){
      debugPrint('error load your data: ${e.toString()}');
    }
  }

}