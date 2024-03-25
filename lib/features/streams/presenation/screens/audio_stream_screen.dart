import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio/just_audio.dart';

import '../widgets/audio_player.dart';

class AudioStreamScreen extends StatefulWidget {
  const AudioStreamScreen({super.key});

  @override
  State<AudioStreamScreen> createState() => _AudioStreamScreenState();
}

class _AudioStreamScreenState extends State<AudioStreamScreen> {
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('البث الاذاعي'),
        centerTitle: true,
      ),
      body: StreamAudioPlayer(),
    );
  }
}
