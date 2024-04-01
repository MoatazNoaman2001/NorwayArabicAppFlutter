import 'package:flutter/material.dart';
import 'package:norway_flutter_app/core/constants.dart';
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
    return Scaffold(
        body: Column(
      children: [
        BlocConsumer<ControllerBloc, ControllerState>(
          listener: (context, state) {
            var bloc = BlocProvider.of<ControllerBloc>(context);
            if (state is ThemeGetSuccess) {
              print('main theme : ' + (bloc.theme ? "dark" : "light"));
              setState(() {
                MyApp.of(context).changeTheme(bloc.theme? ThemeMode.dark : ThemeMode.light);
              });
            } else if (state is ThemeSetSuccess) {
              setState(() {
                MyApp.of(context).changeTheme(bloc.theme? ThemeMode.dark : ThemeMode.light);
              });
            }
          },
          builder: (context, state) {
            return SizedBox.shrink();
          },
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocConsumer<ControllerBloc, ControllerState>(
            listener: (context, state) {
              if (state is LangGetSuccess) {
                if (state.lang.isEmpty) {
                  Navigator.of(context).popAndPushNamed('/select_language');
                } else {
                  Navigator.popAndPushNamed(context, '/home');
                }
                // Navigator.of(context).popAndPushNamed('/select_language');
              } else if (state is LangFailure) {
                print(state.msg);
                Constants.makeToast('failed load language');
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
          ),
        ),
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    context.read<ControllerBloc>().add(ThemeGet());
    _controller = VideoPlayerController.asset('assets/videos/splash_video.mp4')..initialize().then((_) {

    });

    _controller.play();
    _controller.addListener(() {
      inspectVideo();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void inspectVideo() {
    setState(() {
      if (_controller.value.isCompleted) {
        context.read<ControllerBloc>().add(LanguageGet());
      }
    });
  }
}
