import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/data/models/web_pairs.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/platforms/platform_bloc.dart';

class PlatformScreen extends StatefulWidget {
  const PlatformScreen({super.key});

  @override
  State<PlatformScreen> createState() => _PlatformScreenState();
}

class _PlatformScreenState extends State<PlatformScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlatformBloc>().add(
      GetPlatFromList()
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('منصاتنا'),
        centerTitle: true,
      ),
      body: BlocConsumer<PlatformBloc, PlatformState>(
        listener: (context, state) {
          if (state is PlatformSuccess){
            Constants.makeToast('success');
          }else{
            Constants.makeToast('${state.toString()}');
          }
        },
        builder: (context, state) {
          var bloc = BlocProvider.of<PlatformBloc>(context);
          if (state is PlatformSuccess) {
            return PlatFormSuccessView(platforms: bloc.platforms);
          } else {
            return PlatFormLoadingView();
          }
        },
      ),
    );
  }
}

class PlatFormLoadingView extends StatelessWidget {
  const PlatFormLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(12, (index){
              return Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.4,
                height: MediaQuery
                    .of(context)
                    .size
                    .width * 0.4,
                child: Shimmer.fromColors(
                    child: Card(),
                    baseColor: Colors.transparent,
                    highlightColor: Colors.white12),
              );
            }),)
    ,
    );
  }
}


class PlatFormSuccessView extends StatelessWidget {
  final List<WebPair> platforms;
  const PlatFormSuccessView({super.key, required this.platforms});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      child: GridView.count(
        crossAxisCount: 2,
        children: platforms.map((e) {
          Widget image = Image.asset('assets/images/email.png', height: 100, width: 100,);
          switch(e.right){
            case "Facebook" : image = Image.asset('assets/images/facebook.png', height: 100, width: 100,);
            case "Twitter" :image = Image.asset('assets/images/twitter.png', height: 100, width: 100,);
            case "Youtube" : image =Image.asset('assets/images/youtube.png', height: 100, width: 100,);
            case "Instagram" :image = Image.asset('assets/images/instagram.png', height: 100, width: 100,);
            case "Soundcloud" :image = Image.asset('assets/images/sound_cloud.png', height: 100, width: 100,);
            case "Flickr" : image =Image.asset('assets/images/flickr.png', height: 100, width: 100,);
            case "Tiktok" :image = Image.asset('assets/images/tiktok.png', height: 100, width: 100,);

          }

          return Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.5,
              height: MediaQuery
                  .of(context)
                  .size
                  .width * 0.5,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                child: GestureDetector(
                  onTap: () {
                    _launchUrl(Uri.parse(e.left));
                  },
                  child: Container(padding:EdgeInsets.all(34),child: Column(
                    children: [
                      image,
                      SizedBox(height: 4,),
                      Container(width: MediaQuery
                          .of(context)
                          .size
                          .width , child: Text(e.right == "Link"? "Email" : e.right , textAlign: TextAlign.center,))
                    ],
                  )),
                ),
              )
          );
        }).toList(),
      ),
    );
  }

  void _launchUrl(Uri uri) async{
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}

