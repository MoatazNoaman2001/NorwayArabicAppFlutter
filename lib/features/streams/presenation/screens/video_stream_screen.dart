import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/streams/data/repo/youtube_repo_impl.dart';
import 'package:norway_flutter_app/features/streams/data/youtube_parser.dart';
import 'package:norway_flutter_app/features/streams/data/youtube_parser_impl.dart';
import 'package:norway_flutter_app/features/streams/presenation/bloc/youtube_stream_bloc.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoStreamScreen extends StatefulWidget {
  const VideoStreamScreen({super.key});

  @override
  State<VideoStreamScreen> createState() => _VideoStreamScreenState();
}

class _VideoStreamScreenState extends State<VideoStreamScreen> {
  final AudioPlayer player = AudioPlayer();
  String link = "";

  @override
  void dispose() {
    super.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
  }

  @override
  void initState() {
    super.initState();
    context.read<YoutubeStreamBloc>().add(GetYoutubeLink());
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          extendBodyBehindAppBar: orientation == Orientation.landscape,
          appBar: AppBar(
            title: Text(
              LocaleKeys.TvStream.tr(),
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            titleTextStyle: GoogleFonts.rubik().copyWith(fontSize: 20),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: BlocConsumer<YoutubeStreamBloc, YoutubeStreamState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is YoutubeStreamLoading) {
                    return CircularProgressIndicator();
                  } else if (state is YoutubeStreamSuccess) {
                    if (state.link.contains('channel')) {
                      return Text('Youtube streams seems to be off');
                    } else {
                      // SystemChrome.setPreferredOrientations([
                      //   DeviceOrientation.landscapeRight,
                      //   DeviceOrientation.landscapeLeft,
                      // ]);
                      YoutubePlayerController controller =
                          YoutubePlayerController(
                              // initialVideoId: '6nxPpEdjdPE',
                              initialVideoId:
                                  YoutubePlayer.convertUrlToId(state.link)!,
                              flags: YoutubePlayerFlags(isLive: true));
                      return YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: controller,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.amber,
                          liveUIColor: Colors.amber,
                          progressColors: const ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                          ),
                          onReady: () {
                            controller.addListener(
                              () {},
                            );
                          },
                        ),
                        builder: (context, player) {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: player,
                          );
                        },
                      );
                    }
                  } else if (state is YoutubeStreamFailure) {
                    return Text('failure : ${state.msg}');
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
