import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/data/models/web_pairs.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeListScreen extends StatefulWidget {
  final int selected;
  final List<WebPair> videos = [
    WebPair('xGuKRoqcDqo', 'ماذا ولماذا نحتاج ان نخزن لأوقات الطوارئ'),
    WebPair('zQrc-nrQBZU', 'لقاء صوت النرويج مع السفير المصري عمرو رمضان'),
    WebPair('BUwsrECjm7w', 'Politiavhør حقوقك في جلسة الاستجواب عند الشرطة'),
    WebPair('NYW14oDxNdg', 'نتحمل جميعًا المسؤولية ليعيش الأطفال حياة رقمية امنة'),
    WebPair('bOslnITPV14', 'لقاء امال بن يونس سفيرة تونس لدى النرويج'),
    WebPair('zZbTvk2VN2I', 'جواز السفر الانساني والسياسي الجديد في النرويج'),
    WebPair('DjOjsrK2jr4', 'صباح الخير اوسلو ... الملوخية'),
  ];
  YoutubeListScreen({super.key , required this.selected});

  @override
  State<YoutubeListScreen> createState() => _YoutubeListScreenState();
}

class _YoutubeListScreenState extends State<YoutubeListScreen> {
  YoutubePlayerController? youtubePlayerController;



  @override
  void initState() {
    super.initState();
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: widget.videos[widget.selected].right,
        flags: YoutubePlayerFlags(captionLanguage: 'ar'));
  }
  @override
  void dispose() {
    super.dispose();
    youtubePlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.Youtube.tr()),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                    controller: youtubePlayerController!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red.shade700,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    )),
                builder: (p0, p1) => Column(
                  children: [p1],
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8),
                child: Text(
                  widget.videos[widget.selected].left,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.roboto().copyWith(fontSize: 22),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Expanded(
                  child: ListView.separated(
                      controller: ScrollController(),
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(right: 8, left: 8),
                      itemBuilder: (context, index) {
                        if (index >= widget.selected)
                          index = index +1;
                        return Container(
                          height: 220,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onTap: () {
                              Constants.makeToast('clicked');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => YoutubeListScreen(selected: index),)
                              );
                              // Get.to(YoutubeListScreen(selected: index));
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    height: 140,
                                    fit: BoxFit.cover,
                                    width: 700,
                                    imageUrl:
                                        'https://img.youtube.com/vi/${widget.videos[index].right.trim()}/0.jpg',
                                    progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(value: progress.progress)),
                                    errorWidget: (context, url, error) => Image.asset('assets/images/image_not_found.jpg'),
                                  ),
                                  SizedBox(height: 10,),
                                  Text('${widget.videos[index].left.trim()}' , style: GoogleFonts.rubik().copyWith(fontSize: 16),
                                  textAlign: TextAlign.right,)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Container(
                            height: 0,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(right: 30, left: 30),
                            decoration: BoxDecoration(color: Colors.grey),
                          ),
                      itemCount: widget.videos.length -1 ))
            ],
          ),
        ));
  }
}
