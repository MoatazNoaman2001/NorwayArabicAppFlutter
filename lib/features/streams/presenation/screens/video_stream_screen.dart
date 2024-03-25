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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
      ,
      DeviceOrientation.portraitDown,
    ]);
  }
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    context.read<YoutubeStreamBloc>().add(GetYoutubeLink());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('البث التلفزروني'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
                } else{
                  YoutubePlayerController controller = YoutubePlayerController(
                      initialVideoId: YoutubePlayer.convertUrlToId(state.link)!, flags: YoutubePlayerFlags(isLive: true));
                  return YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      liveUIColor: Colors.amber,
                      controller: controller,
                      onReady: () {
                        controller.addListener(() {});
                      },
                    ),
                    builder: (context, player) {
                      return Column(
                        children: [player],
                      );
                    },
                  );
                }
              } else if (state is YoutubeStreamFailure){
                return Text('failure : ${state.msg}');
              } else {
                return Center();
              }
            },
          ),
        ),
      ),
    );
  }
}
