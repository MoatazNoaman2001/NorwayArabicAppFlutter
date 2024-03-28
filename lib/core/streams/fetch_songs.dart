

import 'package:audio_service/audio_service.dart';
import 'package:permission_handler/permission_handler.dart';


// Future<void> accessStorage() async =>
//     await Permission.storage.status.isGranted.then(
//         (granted) async{
//           if (granted == false){
//             PermissionStatus permissionStatus = await Permission.storage.request();
//             if (permissionStatus == PermissionStatus.permanentlyDenied){
//               await openAppSettings();
//             }
//           }
//         }
//     );
//
// class FetchSongs{
//   static Future<List<MediaItem>> excute() async{
//     List<MediaItem> items= [];
//     await accessStorage().then((_) async{
//       List<Song
//     });
//   }
// }