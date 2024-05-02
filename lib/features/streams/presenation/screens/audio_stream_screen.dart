import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_fonts/google_fonts.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/bloc/controller_bloc.dart';
import 'package:norway_flutter_app/features/streams/data/audio_parser_impl.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/radio_player.dart';

class AudioStreamScreen extends StatefulWidget {
  @override
  State<AudioStreamScreen> createState() => _AudioStreamScreenState();
}

class _AudioStreamScreenState extends State<AudioStreamScreen> {
  RadioPlayer radioPlayer = Constants.getInstanceOfRadioPlayer();
  final AudioParserImpl audioParser = AudioParserImpl();
  bool isPlaying = false;
  bool streamisOff = false;
  bool playInBackGround = true;

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
    radioPlayer.setChannel(
        title: 'Norway Audio',
        url: 'http://63.141.232.90:9302/stream?type=http&nocache=26',
        imagePath: 'assets/images/nv1.png');
    context.read<ControllerBloc>().add(CouldPlayInBackGround());

    // SystemChrome.setPreferredOrientations(
    //   [
    //     DeviceOrientation.portraitUp,
    //     DeviceOrientation.portraitDown,
    //   ]
    // );

    audioParser.LiveStreamAvailable.whenComplete(() {
      setState(() {
        streamisOff = true;
      });
    });
    radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    }, onError: (e) {
      print('error happened: ${e.toString()}');
      setState(() {
        streamisOff = true;
      });
    });

    radioPlayer.metadataStream.listen((event) {
      print('event : ' + event.join());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.AudioStream.tr()),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding:
                      EdgeInsets.only(right: 25, left: 25, top: 30, bottom: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 18,
                      ),
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
                                image: AssetImage('assets/images/nv1.png'))),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      FloatingActionButton(
                          onPressed: () {
                            if (isPlaying) {
                              radioPlayer.stop();
                            } else {
                              try {
                                radioPlayer.play();
                              } catch (e) {
                                setState(() {
                                  streamisOff = true;
                                });
                              }
                            }
                          },
                          child: isPlaying
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow)),
                      SizedBox(
                        height: 10,
                      ),
                      if (streamisOff)
                        Container(
                          width: 250,
                          height: 120,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color:
                                  Theme.of(context).brightness == Brightness.light
                                      ? Colors.green.shade100
                                      : Colors.green.shade900.withBlue(90)),
                          child: Text(
                            LocaleKeys.StreamIsOff.tr(),
                            style: GoogleFonts.rubik(),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      BlocConsumer<ControllerBloc, ControllerState>(
                        builder: (context, state) {
                          return SizedBox.shrink();
                        },
                        listener: (context, state) {
                          setState(() {
                            if (state is PlayInBackGroundGetSuccess) {
                              print('play in back ground value: ${state.value}');
                              playInBackGround = state.value;
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: Get.width,
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                    "This Stream is powered by Norway Voice",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik().copyWith(
                    color: Colors.grey.shade500,
                    fontSize: 12
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (playInBackGround == false)
      radioPlayer.stop();
  }
}
