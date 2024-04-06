import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:radio_player/radio_player.dart';
import 'package:video_player/video_player.dart';

class Constants {
  static final List<String> newsUrls = [
    "https://norwayvoice.no/category/%d9%85%d9%86%d9%88%d8%b9%d8%a7%d8%aa/",
    "https://norwayvoice.no/category/%d8%a7%d9%84%d8%aa%d8%ad%d9%82%d9%8a%d9%82%d8%a7%d8%aa/",
    "https://norwayvoice.no/category/%d8%a7%d9%84%d8%a3%d8%ae%d8%a8%d8%a7%d8%b1-%d8%a7%d9%84%d8%b3%d9%8a%d8%a7%d8%b3%d9%8a%d8%a9/",
    "https://norwayvoice.no/category/%d8%a7%d9%84%d8%a3%d8%ae%d8%a8%d8%a7%d8%b1-%d8%a7%d9%84%d9%85%d8%ad%d9%84%d9%8a%d8%a9/",
    "https://norwayvoice.no/category/%d8%a7%d9%84%d8%a3%d8%ae%d8%a8%d8%a7%d8%b1-%d8%a7%d9%84%d8%b1%d9%8a%d8%a7%d8%b6%d9%8a%d8%a9/"
  ];

  static VideoPlayerController? _videoPlayerController;
  VideoPlayerController? initPlayer(){
    _videoPlayerController = VideoPlayerController.asset('assets/videos/splash_video.mp4')..initialize().then((_) {
    });
    return _videoPlayerController;
  }

  static final RadioPlayer _player = RadioPlayer();
  static RadioPlayer getInstanceOfRadioPlayer() => _player;

  static void makeToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
  }

  T? ambiguate<T>(T? value) => value;

}