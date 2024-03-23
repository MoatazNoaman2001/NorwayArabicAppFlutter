import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class AudioStreamScreen extends StatefulWidget {
  const AudioStreamScreen({super.key});

  @override
  State<AudioStreamScreen> createState() => _AudioStreamScreenState();
}

class _AudioStreamScreenState extends State<AudioStreamScreen> {
  final AudioPlayer player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
