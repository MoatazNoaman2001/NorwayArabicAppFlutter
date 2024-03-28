import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/streams/presenation/notifier/audio_state_notifier.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/radio_player.dart';

class AudioStreamScreen extends StatefulWidget {
  @override
  State<AudioStreamScreen> createState() => _AudioStreamScreenState();
}

class _AudioStreamScreenState extends State<AudioStreamScreen> {
  RadioPlayer radioPlayer = RadioPlayer();
  bool isPlaying = false;
  bool streamisOff = false;

  // final FRPSource frp_source = FRPSource(mediaSources: [
  //   MediaSources(
  //       url: "http://63.141.232.90:9302/stream?type=http&nocache=26",
  //       description: 'norway audio live stream',
  //       title: 'norway live',
  //       isAac: true,
  //       isPrimary: true)
  // ]);


  @override
  void initState() {
    super.initState();
    radioPlayer.setChannel(title: 'Norway Audio',
        url: 'http://63.141.232.90:9302/stream?type=http&nocache=26',
        imagePath: 'assets/images/nv1.png');
    // _flutterRadioPlayer.initPlayer();
    // _flutterRadioPlayer.addMediaSources(frp_source);

    radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    }, onError: (e){
      setState(() {
        streamisOff = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.AudioStream.tr()),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - MediaQuery
                  .of(context)
                  .size
                  .width * 0.25,
              height: MediaQuery
                  .of(context)
                  .size
                  .height - MediaQuery
                  .of(context)
                  .size
                  .height * 0.5,
              child: Card(
                child: Column(
                  children: [
                    SizedBox(height: 18,),
                    Container(
                      width: 250,
                      height: 260,
                      padding: EdgeInsets.only(
                          top: 32, left: 28, right: 28, bottom: 28),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: Colors.green.shade600,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/nv1.png'
                              )
                          )
                      ),
                    ),
                    SizedBox(height: 25,),
                    FloatingActionButton(
                        onPressed: () {
                           if (isPlaying){
                             radioPlayer.stop();
                           }else{
                             radioPlayer.play();
                           }
                        },
                        child: isPlaying
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow)
                    ),
                    if (streamisOff)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green.shade100
                        ),
                        child: Text(LocaleKeys.StreamIsOff.tr()),
                      )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    // _flutterRadioPlayer.stop();
  }
}
