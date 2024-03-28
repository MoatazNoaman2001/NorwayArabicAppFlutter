import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Colors.transparent,
                          Theme.of(context).brightness == Brightness.dark
                              ? darkColorScheme.surface
                              : lightColorScheme.surface
                        ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                    // border: Border.all(width: 30),
                                    gradient: LinearGradient(colors:[
                                      Colors.transparent ,  Colors.white12
                                    ] , begin: Alignment.topRight , end: Alignment.bottomLeft),
                                    borderRadius: BorderRadius.circular(14),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                        'assets/images/nerway_full_logo.png'
                                      )
                                    )
                                  ),
                                ))
                          ],
                        ),
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
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Colors.transparent,
                          Theme.of(context).brightness == Brightness.dark
                              ? darkColorScheme.surface
                              : lightColorScheme.surface
                        ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
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
                                      width: 790,
                                    )))
                          ],
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
