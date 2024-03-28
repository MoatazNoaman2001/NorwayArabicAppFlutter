import 'dart:collection';

import 'package:audio_service/audio_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/core/streams/audio_hadler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_session/audio_session.dart';

import '../../../../main.dart';
import '../../domain/entities/position_data.dart';

class StreamAudioPlayer extends StatefulWidget {
  const StreamAudioPlayer({super.key});

  @override
  State<StreamAudioPlayer> createState() => _StreamAudioPlayerState();
}

class _StreamAudioPlayerState extends State<StreamAudioPlayer>
    with WidgetsBindingObserver {
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 64.0,
            height: 64.0,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 64.0,
            onPressed: player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 64.0,
            onPressed: player.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: 64.0,
            onPressed: () => player.seek(Duration.zero),
          );
        }
      },
    );
  }
}
