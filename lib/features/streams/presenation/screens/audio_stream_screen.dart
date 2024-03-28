import 'package:audio_service/audio_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';
import 'package:just_audio/just_audio.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';

class AudioStreamScreen extends StatefulWidget {
  // final MyAudioHandler audioHandler;
  //
  // const AudioStreamScreen({super.key, required this.audioHandler});

  @override
  State<AudioStreamScreen> createState() => _AudioStreamScreenState();
}

class _AudioStreamScreenState extends State<AudioStreamScreen> {
  final AudioPlayer player = AudioPlayer();
  final FlutterRadioPlayer _flutterRadioPlayer = FlutterRadioPlayer();
  final FRPSource frp_source = FRPSource(mediaSources: [
    MediaSources(
        url: "http://63.141.232.90:9302/stream?type=http&nocache=26",
        description: 'norway audio live stream',
        title: 'norway live',
        isAac: true,
        isPrimary: true)
  ]);

  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    _flutterRadioPlayer.initPlayer();
    _flutterRadioPlayer.addMediaSources(frp_source);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.AudioStream.tr()),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width *0.25,
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height *0.5,
            child: Card(
              child: Column(
                children: [
                  SizedBox(height: 18,),
                  Container(
                    width: 250,
                    height: 260,
                    padding: EdgeInsets.only(top: 32 , left: 28,right: 28, bottom: 28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      color: Colors.green.shade600,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:AssetImage(
                          'assets/images/nv1.png'
                        )
                      )
                    ),
                  ),
                  SizedBox(height: 25,),
                  FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _flutterRadioPlayer.playOrPause();
                          isPlaying = !isPlaying;
                        });
                      },
                      child: isPlaying
                          ? Icon(Icons.pause)
                          : Icon(Icons.play_arrow))
                ],
              ),
            ),
          ),
        ));
  }
}
