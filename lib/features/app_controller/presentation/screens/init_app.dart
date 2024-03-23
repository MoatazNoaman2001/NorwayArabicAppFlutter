import 'package:flutter/material.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/bloc/controller_bloc.dart';
import 'package:norway_flutter_app/main.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_store/data_store_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InitiateApp extends StatefulWidget {
  const InitiateApp({super.key});

  @override
  State<InitiateApp> createState() => _InitiateAppState();
}

class _InitiateAppState extends State<InitiateApp> {
  late VideoPlayerController _controller;
  String title = "";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: BlocConsumer<ControllerBloc, ControllerState>(
          listener: (context, state) {
            if (state is LangGetSuccess) {
              if (state.lang.isEmpty){
                Navigator.of(context).popAndPushNamed('/select_language');
              }else{
                Navigator.popAndPushNamed(context, '/home');
              }
              // Navigator.of(context).popAndPushNamed('/select_language');
            } else if (state is LangFailure) {
              print(state.msg);
              Fluttertoast.showToast(
                  msg: 'failed to get',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1);
            }
          },
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width ?? 0,
                      height: _controller.value.size.height ?? 0,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                //FURTHER IMPLEMENTATION
              ],
            );
          },
        )
    );
  }

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/videos/splash_video.mp4')
      ..initialize().then((_) {
        setState(() {
          // _controller.value.isPlaying
          //     ? _controller.play()
          //     : _controller.pause();
        });
      });

    _controller.play();
    _controller.addListener(() {
      inspicteVideo();
    });
  }

  void inspicteVideo() {
    setState(() {
      if (_controller.value.isCompleted) {
        context.read<ControllerBloc>().add(LanguageGet());
        // Navigator.of(context).popAndPushNamed('/select_language');
      }
    });
  }
}
