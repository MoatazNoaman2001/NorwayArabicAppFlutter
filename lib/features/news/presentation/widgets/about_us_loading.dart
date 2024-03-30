import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shimmer/shimmer.dart';

class AboutUsLoadingWidget extends StatelessWidget {
  const AboutUsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: List.generate(6, (index) {
          return Shimmer.fromColors(
              child: Container(
                width: MediaQuery.of(context).size.width -( Random(498721321).nextDouble() %  MediaQuery.of(context).size.width ) + 50,
                height: Random().nextInt(200) + 1 ,
                padding: EdgeInsets.all(4),
                color: Colors.white70,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
              ),
              baseColor: Colors.transparent,
              highlightColor: Colors.white24);
        })),
      ),
    );
  }
}
