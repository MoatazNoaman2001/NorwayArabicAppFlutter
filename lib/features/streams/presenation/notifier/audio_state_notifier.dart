// import 'package:flutter/cupertino.dart';
// import 'package:flutter_radio_player/flutter_radio_player.dart';
//
// import '../../../../core/constants.dart';
//
// class AudioStateNotifier extends ChangeNotifier{
//   final FlutterRadioPlayer player;
//
//   AudioStateNotifier(this.player);
//
//   bool isPlaying = false;
//
//   void StateListener() async{
//     player.getPlaybackState().asStream().listen((value) {
//       print('player state : ' + value);
//       if (value == "PLAYING"){
//         isPlaying = true;
//       }else if (value == "PAUSED"){
//         isPlaying = false;
//       }else if (value  == "STOPPED"){
//         isPlaying = false;
//
//       }else if (value == "LOADING"){
//         isPlaying = false;
//       }
//
//       notifyListeners();
//     }, onError: (e){
//       Constants.makeToast('error :${e.toString()}');
//     }, onDone: () {
//       print('completed');
//       // StateListener();
//     },cancelOnError: false);
//   }
// }