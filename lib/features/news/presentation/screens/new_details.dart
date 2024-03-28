import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/details/details_bloc.dart';
import 'package:shimmer/shimmer.dart';

class NewDetails extends StatefulWidget {
  const NewDetails({super.key});

  @override
  State<NewDetails> createState() => _NewDetailsState();
}

class _NewDetailsState extends State<NewDetails> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        NorwayNew norwayNew =
            ModalRoute.of(context)!.settings.arguments as NorwayNew;
        print('link : ${norwayNew.link}');
        context.read<DetailsBloc>().add(GetNewDetails(norwayNew.link));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    NorwayNew norwayNew =
        ModalRoute.of(context)!.settings.arguments as NorwayNew;

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل'),
        centerTitle: true,
      ),
      body: BlocConsumer<DetailsBloc, DetailsState>(
        listener: (context, state) {
          if (state is DetailsSuccess) {
            Constants.makeToast('details received');
          } else if (state is DetailsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('error loading data'),
              duration: Duration(hours: 1),
              action: SnackBarAction(
                label: 'retry',
                onPressed: () {
                  context
                      .read<DetailsBloc>()
                      .add(GetNewDetails(norwayNew.link));
                },
              ),
            ));
          }
        },
        builder: (context, state) {
          // Constants.makeToast('${state.toString()}');
          var bloc = BlocProvider.of<DetailsBloc>(context);
          if (state is DetailsSuccess) {
            return DetailsSuccessView(norwayNew: state.norwayNew);
          } else {
            return DetailsLoadingScreen(norwayNew: norwayNew);
          }
          // if (state is DetailsLoading){
          // }else if(state is DetailsSuccess){
          //   return DetailsSuccessView(norwayNew: state.norwayNew);
          // }else if (state is DetailsFailure){
          //   return DetailsLoadingScreen(norwayNew: norwayNew);
          // }else{
          //   return DetailsLoadingScreen(norwayNew: norwayNew);
          // }
        },
      ),
    );
  }
}

class DetailsLoadingScreen extends StatelessWidget {
  final NorwayNew norwayNew;

  const DetailsLoadingScreen({super.key, required this.norwayNew});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      width: double.infinity,
      height: double.infinity,
      child: Card(
        borderOnForeground: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        elevation: 4,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(14), topLeft: Radius.circular(14)),
              child: CachedNetworkImage(
                height: 240,
                imageUrl: norwayNew.image,
                placeholderFadeInDuration: Durations.medium3,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                  value: progress.progress,
                )),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/head_logo.jpeg'),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.only(right: 8, left: 8),
              child: Column(
                children: [
                  Shimmer.fromColors(
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        padding: EdgeInsets.only(right: 8, left: 8),
                        child: Card(),
                      ),
                      baseColor: Colors.transparent,
                      highlightColor: Colors.white24),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    norwayNew.title,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.rubik().copyWith(fontSize: 24),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Shimmer.fromColors(
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        padding: EdgeInsets.only(right: 8, left: 8),
                        child: Card(),
                      ),
                      baseColor: Colors.transparent,
                      highlightColor: Colors.white24)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsSuccessView extends StatelessWidget {
  final NorwayNew norwayNew;

  const DetailsSuccessView({super.key, required this.norwayNew});

  @override
  Widget build(BuildContext context) {
    print('share list' + norwayNew.socialShare.toString());
    return Container(
      padding: const EdgeInsets.all(7),
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Card(
          borderOnForeground: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          elevation: 4,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(14), topLeft: Radius.circular(14)),
                child: CachedNetworkImage(
                  height: 240,
                  imageUrl: norwayNew.image,
                  placeholderFadeInDuration: Durations.medium3,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, progress) => Center(
                      child: CircularProgressIndicator(
                    value: progress.progress,
                  )),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/head_logo.jpeg'),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding: EdgeInsets.only(right: 8, left: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          ' | ${norwayNew.readDuration}',
                          style: GoogleFonts.rubik().copyWith(fontSize: 14),
                        ),
                        Icon(Icons.timer_outlined),
                        Text(
                          '| نشر في ${norwayNew.date}',
                          style: GoogleFonts.rubik().copyWith(fontSize: 14),
                        ),
                        Icon(Icons.calendar_month_outlined),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'by ${norwayNew.publisher}',
                          style: GoogleFonts.rubik().copyWith(fontSize: 14),
                        ),
                        Icon(Icons.person_2_outlined),
                        Text(
                          ' | ${norwayNew.votes}',
                          style: GoogleFonts.rubik().copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      norwayNew.title,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.rubik().copyWith(fontSize: 24),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(right: 8, left: 8),
                      height: 600,
                      child: ListView.builder(
                        itemCount: norwayNew.articleContent.length,
                        padding: EdgeInsets.only(right: 8, left: 8),
                        itemBuilder: (context, index) {
                          // return Text(norwayNew.articleContent[index].left , style: GoogleFonts.rubik().copyWith(
                          //     fontSize: 14
                          // ),);
                          if (norwayNew.articleContent[index].right == 'txt') {
                            return Text(
                              norwayNew.articleContent[index].left,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.rubik().copyWith(fontSize: 14),
                            );
                          } else if (norwayNew.articleContent[index].right ==
                              'img') {
                            return CachedNetworkImage(
                              height: 140,
                              imageUrl: norwayNew.articleContent[index].left,
                              placeholderFadeInDuration: Durations.medium3,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                      child: CircularProgressIndicator(
                                value: progress.progress,
                              )),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/images/head_logo.jpeg'),
                            );
                          } else if (norwayNew.articleContent[index].left
                              .startsWith('https')) {
                            print(norwayNew.articleContent[index]);
                            return TextButton(
                                onPressed: () {
                                  _launchUrl(Uri.parse(
                                      norwayNew.articleContent[index].left));
                                },
                                child: Text(
                                  textAlign: TextAlign.right,
                                  norwayNew.articleContent[index].right.trim(),
                                  style: GoogleFonts.rubik().copyWith(
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ));
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: norwayNew.socialShare.length,
                        padding: EdgeInsets.only(right: 8, left: 8),
                        itemBuilder: (context, index) {
                          print('share: ' +
                              norwayNew.socialShare[index].toString());
                          switch (norwayNew.socialShare[index].right) {
                            case "share-button-linkedin":
                              return FloatingActionButton(
                                  onPressed: () {
                                    _launchUrl(Uri.parse(
                                        norwayNew.socialShare[index].left));
                                  },

                                  child: Container(
                                    child: Image.asset(
                                        'assets/images/linkedin.png'),
                                    padding: EdgeInsets.all(4),
                                  ));
                            case "post-share":
                              return FloatingActionButton(
                                  onPressed: () {
                                    Share.share('check out norway arabic new on ${norwayNew.link}');
                                  },
                                  child: Icon(Icons.share_outlined
                                  ));
                            case "share-button-pinterest":
                              return FloatingActionButton(
                                  onPressed: () {
                                    _launchUrl(Uri.parse(
                                        norwayNew.socialShare[index].left));
                                  },
                                  child: Container(
                                    child: Image.asset(
                                        'assets/images/pinterest.png'),
                                    padding: EdgeInsets.all(4),
                                  ));
                            case "share-button-google":
                              return FloatingActionButton(
                                  onPressed: () {
                                    _launchUrl(Uri.parse(
                                        norwayNew.socialShare[index].left));
                                  },
                                  child: Container(
                                    child:
                                        Image.asset('assets/images/google.png'),
                                    padding: EdgeInsets.all(4),
                                  ));
                            case "share-button-twitter":
                              return FloatingActionButton(
                                  onPressed: () {
                                    _launchUrl(Uri.parse(
                                        norwayNew.socialShare[index].left));
                                  },
                                  child: Container(
                                    child:
                                        Image.asset('assets/images/twitter.png'),
                                    padding: EdgeInsets.all(4),
                                  ));
                            case "share-button-facebook":
                              return FloatingActionButton(
                                  onPressed: () {
                                    _launchUrl(Uri.parse(
                                        norwayNew.socialShare[index].left));
                                  },
                                  child: Container(
                                    child: Image.asset(
                                        'assets/images/facebook.png'),
                                    padding: EdgeInsets.all(4),
                                  ));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
