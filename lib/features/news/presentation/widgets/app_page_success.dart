import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/web_pairs.dart';

class AppPageSuccessScreen extends StatelessWidget {
  final List<WebPair> plts;
  bool isTv = false;

  AppPageSuccessScreen({super.key, required this.plts});

  @override
  Widget build(BuildContext context) {
    isDeviceIsTv();
    return OrientationBuilder(
      builder: (context, orientation) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: plts
                  .sublist(
                      0, isTv || orientation == Orientation.landscape ? 4 : 2)
                  .map((e) => Row(children: [PltCard(e), SizedBox(width: 4,)],))
                  .toList(),
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Row(
              children: plts
                  .sublist(
                  isTv || orientation == Orientation.landscape ? 4: 2, isTv || orientation == Orientation.landscape ? 6 : 4)
                  .map((e) => Row(children: [PltCard(e), SizedBox(width: 4,)],))
                  .toList(),
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            if(!isTv && orientation != Orientation.landscape)
              Row(
                children: plts
                    .sublist(4, 6)
                    .map((e) => Row(children: [PltCard(e), SizedBox(width: 4,)],))
                    .toList(),
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            // Container(
            //     width: Get.width,
            //     height: Get.height - (Get.height * 0.32),
            //     child: GridView.count(
            //       scrollDirection: Axis.vertical,
            //       controller: ScrollController(),
            //       physics: BouncingScrollPhysics(),
            //       padding: EdgeInsets.symmetric(horizontal: 8),
            //       crossAxisCount: isTv ? 4 : orientation == Orientation.landscape ? 4 : 2,
            //       children: plts.sublist(0, 6).map((e) => PltCard(e)).toList(),
            //     )),
            SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bannerImage((plts[9].left as List<String?>)[0]),
                bannerImage((plts[9].left as List<String?>)[1]),
                bannerImage((plts[9].left as List<String?>)[2]),
                bannerImage((plts[9].left as List<String?>)[3]),
              ],
            ),
            CachedNetworkImage(
              imageUrl: plts[6].left,
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 130,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: imageProvider)),
                );
              },
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Center(
                child: Text('error'),
              ),
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(plts[8].left, style: GoogleFonts.rubik()),
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  void isDeviceIsTv() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isTv = androidInfo.systemFeatures.contains('android.software.leanback');
  }

  Widget PltCard(WebPair e) {
    return GestureDetector(
      onTap: () {
        _launchUrl(Uri.parse((e.left as WebPair).left));
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: (e.left as WebPair).right,
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 115,
                  width: 115,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: imageProvider)),
                );
              },
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator(),
              ),
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: 180,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                e.right,
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik().copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue.shade800),
              ),
            )
          ],
        ),
      ),
    );
  }

  bannerImage(String? jsonDecode) {
    return CachedNetworkImage(
      imageUrl: jsonDecode ?? "",
      imageBuilder: (context, imageProvider) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(image: imageProvider)),
        );
      },
      progressIndicatorBuilder: (context, url, progress) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
