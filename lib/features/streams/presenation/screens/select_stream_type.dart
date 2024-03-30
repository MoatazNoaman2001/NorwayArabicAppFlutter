import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/core/theme/color_schemes.g.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';

class SelectStreamType extends StatelessWidget {
  const SelectStreamType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Streams.tr()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: 155,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/audio_stream');
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: Stack(
                        children: [
                          Container(
                            foregroundDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Colors.transparent,
                                  Theme.of(context).brightness == Brightness.dark
                                      ? darkColorScheme.surface
                                      : lightColorScheme.surface
                                ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      // border: Border.all(width: 30),
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.white12
                                          ],
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft),
                                      borderRadius: BorderRadius.circular(14),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              'assets/images/nerway_full_logo.png'))),
                                ))
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.70,
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                'اذاعة النرويج علي اليوتيوب',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.rubik().copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white
                                ),
                                maxLines: 3,
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              Container(
                height: 155,
                color: Colors.transparent,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/video_stream');
                      },
                      child: Stack(
                        children: [
                          Container(
                            foregroundDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Colors.transparent,
                                  Theme.of(context).brightness == Brightness.dark
                                      ? darkColorScheme.surface
                                      : lightColorScheme.surface
                                ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Flexible(
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(14),
                                            child: Image.asset(
                                              'assets/images/youtube.png',
                                              fit: BoxFit.cover,
                                              width: 1090,
                                            )))
                                  ],
                                ),

                          ),

                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.65,
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                'تيلفزيون النرويج علي اليوتيوب',
                                textAlign: TextAlign.right,
                                style: GoogleFonts.rubik().copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                                maxLines: 3,
                              ),
                            ),
                          )
                        ],
                      ),


                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
