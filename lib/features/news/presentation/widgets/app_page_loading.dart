import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AppPageLoadingScreen extends StatelessWidget {
  AppPageLoadingScreen({super.key});
  bool isTV = false;

  @override
  Widget build(BuildContext context) {
    isDeviceIsTv();

    return OrientationBuilder(
      builder: (context, orientation) {
        return Column(
          children: [
            Expanded(
                child: GridView.count(
              controller: ScrollController(),
              crossAxisCount: isTV? 4 : orientation == Orientation.landscape? 4  : 2,
              children: List.generate(8, (index) {
                return Shimmer.fromColors(
                    child: Card(),
                    baseColor: Colors.transparent,
                    highlightColor: Colors.black12);
              }),
            )),
            SizedBox(
              height: 14,
            ),
            Shimmer.fromColors(
                child: Container(
                  width: Get.width,
                  height: 46,
                  margin: EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Card(),
                ),
                baseColor: Colors.transparent,
                highlightColor: Colors.black12)
          ],
        );
      },
    );
  }


  void isDeviceIsTv() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isTV = androidInfo.systemFeatures.contains('android.software.leanback');
  }
}
