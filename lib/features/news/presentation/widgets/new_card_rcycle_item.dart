import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/norway_new.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsCardRecycleItem extends StatelessWidget {
  final VoidCallback callback;
  final NorwayNew norwayNew;

  const NewsCardRecycleItem({super.key, required this.norwayNew , required this.callback});

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(4),
        child: GestureDetector(
          onTap: callback,
          child: Card(
            child: Column(
              children: [
                CachedNetworkImage(
                  height: 160,
                  imageUrl: norwayNew.image,
                  placeholderFadeInDuration: Durations.medium3,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, progress) =>
                      Center(
                          child :CircularProgressIndicator(
                            value: progress.progress,
                          )
                      ),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/head_logo.jpeg'),
                ),
                SizedBox(height: 4,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.date_range),
                      Text(
                          norwayNew.date,
                        style: GoogleFonts.rubik().copyWith(
                            fontSize: 14
                        ),
                      ),
                      Spacer(),
                      Text(
                          norwayNew.readDuration,
                          style: GoogleFonts.rubik().copyWith(
                            fontSize: 14
                          ),
                      ),
                      Icon(Icons.timer)
                    ],
                  ),
                ),
                SizedBox(height: 4,),
                Padding(
                  padding: const EdgeInsets.only(right: 8 , left: 8),
                  child: Text(
                      norwayNew.title,
                    style: GoogleFonts.rubik().copyWith(
                      fontSize: 24
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(height: 4,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      norwayNew.content,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.rubik().copyWith(
                        fontSize: 13
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}
