import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/web_pairs.dart';

class AboutUsSuccessWidget extends StatelessWidget {
  final List<WebPair> pairs;
  const AboutUsSuccessWidget({super.key, required this.pairs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: pairs.length,
        padding: EdgeInsets.only(right: 8, left: 8),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        controller: ScrollController(

        ),
        itemBuilder: (context, index) {
          return Text(pairs[index].left, style: GoogleFonts.rubik().copyWith(
            fontSize: pairs[index].right == 'h3'? 26 : 18,
            fontWeight: pairs[index].right == 'h3'? FontWeight.w800: FontWeight.w300
          ),textAlign: TextAlign.right,);
        },
      ),
    );
  }
}
