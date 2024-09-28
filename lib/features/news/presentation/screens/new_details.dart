import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart' hide Trans;
import 'package:norway_flutter_app/core/theme/color_schemes.g.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/details/details_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../translations/locale_keys.g.dart';
import '../widgets/tik_tok_container.dart';

class NewDetails extends StatefulWidget {
  const NewDetails({super.key});

  @override
  State<NewDetails> createState() => _NewDetailsState();
}

class _NewDetailsState extends State<NewDetails> {
  late ScaffoldMessengerState snackbar;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    snackbar = ScaffoldMessenger.of(context);
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
  void dispose() {
    snackbar.dispose();
    ScaffoldMessenger.of(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NorwayNew norwayNew =
        ModalRoute.of(context)!.settings.arguments as NorwayNew;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Details.tr()),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<DetailsBloc, DetailsState>(
        listener: (context, state) {
          if (state is DetailsSuccess) {
            print('${state.norwayNew.articleContent.toString()}');
          } else if (state is DetailsFailure) {
            snackbar.showSnackBar(SnackBar(
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
            return DetailsSuccessView(norwayNew: bloc.norwayNew!);
          } else if (state is DetailsLoading || state is DetailsFailure) {
            return DetailsLoadingScreen(norwayNew: norwayNew);
          } else {
            if (bloc.norwayNew != null && norwayNew.link == bloc.norwayNew?.link)
              return DetailsSuccessView(norwayNew: bloc.norwayNew!);
            else
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
      child: SingleChildScrollView(
        child: Card(
          borderOnForeground: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          elevation: 4,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    topLeft: Radius.circular(14)),
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
      height: Get.height,
      child: SingleChildScrollView(
        child: Card(
          borderOnForeground: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          elevation: 4,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    topLeft: Radius.circular(14)),
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: norwayNew.articleContent.map((phrase) {
                        if (phrase.right == 'txt') {
                          return Text(
                            phrase.left.trim(),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.rubik().copyWith(fontSize: 12),
                          );
                        }
                        else if (phrase.right== 'figure'){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment:  MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14.0),
                                child: CachedNetworkImage(imageUrl: (phrase.left as List<String>)[0] ,height: 200,),
                              ),
                              SizedBox(height: 8,),
                              Text((phrase.left as List<String>)[1], style: GoogleFonts.rubik().copyWith(
                                fontSize: 16
                              ),)
                            ],
                          );
                        }
                        else if (phrase.right== 'gallery'){
                          return Container(
                            height: 350,
                            width: Get.width,
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            child:GridView.count(crossAxisCount: 2, physics: BouncingScrollPhysics(),
                            controller: ScrollController(),children: (phrase.left as List<String?>).map((e) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CachedNetworkImage(imageUrl: e??"", height: 40,),
                              );
                              }).toList(),),
                          );
                        }
                        else if (phrase.right == 'img') {
                          return CachedNetworkImage(
                            height: 140,
                            imageUrl: phrase.left,
                            placeholderFadeInDuration: Durations.medium3,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider
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
                        } else if (phrase.right == 'blockquote') {
                          return TiktokContainer(
                            url: phrase.left,
                            // url: 'https://www.tiktok.com/embed/v2/7356988212381814049?lang=en-US&referrer=https%3A%2F%2Fnorwayvoice.no%2F%25D9%2586%25D8%25B4%25D8%25B1%25D8%25A9-%25D9%2585%25D8%25AD%25D8%25A7%25D9%2583%25D9%2585-%25D8%25A7%25D9%2588%25D8%25B3%25D9%2584%25D9%2588-%25D8%25A7%25D9%2584%25D8%25AC%25D9%2586%25D8%25A7%25D8%25A6%25D9%258A%25D8%25A9-%25D9%2584%25D9%2587%25D8%25B0%25D8%25A7-%25D8%25A7%25D9%2584%25D9%258A%25D9%2588%25D9%2585-14%2F%3Ffbclid%3DIwAR35ahY9tCqtY3e1zs16r8aAISKNAb91t3W8LBfbXY0AnYxrpHSak9BhvZc&embedFrom=oembed',
                            // html: '<blockquote class="tiktok-embed" cite="https://www.tiktok.com/@nvradio/video/7356988212381814049" data-video-id="7356988212381814049" style="max-width: 605px;min-width: 325px;" > <section> <a target="_blank" title="@nvradio" href="https://www.tiktok.com/@nvradio?refer=embed">@nvradio</a> ‏Hva skjer i tingretten - uke 16 - 2024 نشرة اوسلو القضائية لهذا اليوم الجمعة، الخامس من نيسان - اپريل 2024. @وسام كريم العزاوي @Janna Al-Rubaye <a title="المستشار_الصحفي" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D9%85%D8%B3%D8%AA%D8%B4%D8%A7%D8%B1_%D8%A7%D9%84%D8%B5%D8%AD%D9%81%D9%8A?refer=embed">#المستشار_الصحفي</a> <a title="مستشار" target="_blank" href="https://www.tiktok.com/tag/%D9%85%D8%B3%D8%AA%D8%B4%D8%A7%D8%B1?refer=embed">#مستشار</a> <a title="قانون_الجنسية" target="_blank" href="https://www.tiktok.com/tag/%D9%82%D8%A7%D9%86%D9%88%D9%86_%D8%A7%D9%84%D8%AC%D9%86%D8%B3%D9%8A%D8%A9?refer=embed">#قانون_الجنسية</a> <a title="اخبار_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%AE%D8%A8%D8%A7%D8%B1_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#اخبار_النرويج</a> <a title="النرويجية" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC%D9%8A%D8%A9?refer=embed">#النرويجية</a> <a title="norske_nyheter_på_arabisk" target="_blank" href="https://www.tiktok.com/tag/norske_nyheter_p%C3%A5_arabisk?refer=embed">#norske_nyheter_på_arabisk</a> <a title="medierådgiver" target="_blank" href="https://www.tiktok.com/tag/medier%C3%A5dgiver?refer=embed">#medierådgiver</a> <a title="wisam_karim_alazawi" target="_blank" href="https://www.tiktok.com/tag/wisam_karim_alazawi?refer=embed">#wisam_karim_alazawi</a> <a title="redaktør" target="_blank" href="https://www.tiktok.com/tag/redakt%C3%B8r?refer=embed">#redaktør</a> <a title="udi" target="_blank" href="https://www.tiktok.com/tag/udi?refer=embed">#udi</a> <a title="أخبار_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A3%D8%AE%D8%A8%D8%A7%D8%B1_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#أخبار_النرويج</a> <a title="صحافة_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%B5%D8%AD%D8%A7%D9%81%D8%A9_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#صحافة_النرويج</a> <a title="اخبار_النرويج_بالعربية" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%AE%D8%A8%D8%A7%D8%B1_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC_%D8%A8%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9?refer=embed">#اخبار_النرويج_بالعربية</a> <a title="المستشار_الاعلامي" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D9%85%D8%B3%D8%AA%D8%B4%D8%A7%D8%B1_%D8%A7%D9%84%D8%A7%D8%B9%D9%84%D8%A7%D9%85%D9%8A?refer=embed">#المستشار_الاعلامي</a> <a title="وسام_كريم_العزاوي" target="_blank" href="https://www.tiktok.com/tag/%D9%88%D8%B3%D8%A7%D9%85_%D9%83%D8%B1%D9%8A%D9%85_%D8%A7%D9%84%D8%B9%D8%B2%D8%A7%D9%88%D9%8A?refer=embed">#وسام_كريم_العزاوي</a> <a title="مستشار" target="_blank" href="https://www.tiktok.com/tag/%D9%85%D8%B3%D8%AA%D8%B4%D8%A7%D8%B1?refer=embed">#مستشار</a> <a title="اخبار_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%AE%D8%A8%D8%A7%D8%B1_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#اخبار_النرويج</a> <a title="الشرطة" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%B4%D8%B1%D8%B7%D8%A9?refer=embed">#الشرطة</a> <a title="الشرطة_النرويجية" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%B4%D8%B1%D8%B7%D8%A9_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC%D9%8A%D8%A9?refer=embed">#الشرطة_النرويجية</a> <a title="الخارجية" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%AE%D8%A7%D8%B1%D8%AC%D9%8A%D8%A9?refer=embed">#الخارجية</a> <a title="الخارجية_النرويجية" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%AE%D8%A7%D8%B1%D8%AC%D9%8A%D8%A9_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC%D9%8A%D8%A9?refer=embed">#الخارجية_النرويجية</a> <a title="وزارة_الخارجية" target="_blank" href="https://www.tiktok.com/tag/%D9%88%D8%B2%D8%A7%D8%B1%D8%A9_%D8%A7%D9%84%D8%AE%D8%A7%D8%B1%D8%AC%D9%8A%D8%A9?refer=embed">#وزارة_الخارجية</a> <a title="رئيس_الوزراء" target="_blank" href="https://www.tiktok.com/tag/%D8%B1%D8%A6%D9%8A%D8%B3_%D8%A7%D9%84%D9%88%D8%B2%D8%B1%D8%A7%D8%A1?refer=embed">#رئيس_الوزراء</a> <a title="اوسلو_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%88%D8%B3%D9%84%D9%88_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#اوسلو_النرويج</a> <a title="صحفي_نرويجي" target="_blank" href="https://www.tiktok.com/tag/%D8%B5%D8%AD%D9%81%D9%8A_%D9%86%D8%B1%D9%88%D9%8A%D8%AC%D9%8A?refer=embed">#صحفي_نرويجي</a> <a title="الاعلام_الالكتروني" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%A7%D8%B9%D9%84%D8%A7%D9%85_%D8%A7%D9%84%D8%A7%D9%84%D9%83%D8%AA%D8%B1%D9%88%D9%86%D9%8A?refer=embed">#الاعلام_الالكتروني</a> <a title="اعلامي" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%B9%D9%84%D8%A7%D9%85%D9%8A?refer=embed">#اعلامي</a> <a title="اعلاميات" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%B9%D9%84%D8%A7%D9%85%D9%8A%D8%A7%D8%AA?refer=embed">#اعلاميات</a> <a title="نشرة_الاخبار" target="_blank" href="https://www.tiktok.com/tag/%D9%86%D8%B4%D8%B1%D8%A9_%D8%A7%D9%84%D8%A7%D8%AE%D8%A8%D8%A7%D8%B1?refer=embed">#نشرة_الاخبار</a> <a title="نشرة_الظهيرة" target="_blank" href="https://www.tiktok.com/tag/%D9%86%D8%B4%D8%B1%D8%A9_%D8%A7%D9%84%D8%B8%D9%87%D9%8A%D8%B1%D8%A9?refer=embed">#نشرة_الظهيرة</a> <a title="انباء" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%86%D8%A8%D8%A7%D8%A1?refer=embed">#انباء</a> <a title="وكالة_الانباء_النرويجية" target="_blank" href="https://www.tiktok.com/tag/%D9%88%D9%83%D8%A7%D9%84%D8%A9_%D8%A7%D9%84%D8%A7%D9%86%D8%A8%D8%A7%D8%A1_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC%D9%8A%D8%A9?refer=embed">#وكالة_الانباء_النرويجية</a> <a title="عناوين_الصحف" target="_blank" href="https://www.tiktok.com/tag/%D8%B9%D9%86%D8%A7%D9%88%D9%8A%D9%86_%D8%A7%D9%84%D8%B5%D8%AD%D9%81?refer=embed">#عناوين_الصحف</a> <a title="خبرية" target="_blank" href="https://www.tiktok.com/tag/%D8%AE%D8%A8%D8%B1%D9%8A%D8%A9?refer=embed">#خبرية</a> <a title="اذاعة_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%B0%D8%A7%D8%B9%D8%A9_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#اذاعة_النرويج</a> <a title="اذاعة_النرويج_بالعربي" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%B0%D8%A7%D8%B9%D8%A9_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC_%D8%A8%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A?refer=embed">#اذاعة_النرويج_بالعربي</a> <a title="راديو_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%B1%D8%A7%D8%AF%D9%8A%D9%88_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#راديو_النرويج</a> <a title="راديو_النرويج_بالعربي" target="_blank" href="https://www.tiktok.com/tag/%D8%B1%D8%A7%D8%AF%D9%8A%D9%88_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC_%D8%A8%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A?refer=embed">#راديو_النرويج_بالعربي</a> <a title="راديو_صوت_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%B1%D8%A7%D8%AF%D9%8A%D9%88_%D8%B5%D9%88%D8%AA_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#راديو_صوت_النرويج</a> <a title="الحقيقة" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%AD%D9%82%D9%8A%D9%82%D8%A9?refer=embed">#الحقيقة</a> <a title="الحقيقية" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%AD%D9%82%D9%8A%D9%82%D9%8A%D8%A9?refer=embed">#الحقيقية</a> <a title="العربية" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9?refer=embed">#العربية</a> <a title="اهم_الاخبار_في_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%87%D9%85_%D8%A7%D9%84%D8%A7%D8%AE%D8%A8%D8%A7%D8%B1_%D9%81%D9%8A_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#اهم_الاخبار_في_النرويج</a> <a title="duognorge" target="_blank" href="https://www.tiktok.com/tag/duognorge?refer=embed">#duognorge</a> <a title="du_og_norge" target="_blank" href="https://www.tiktok.com/tag/du_og_norge?refer=embed">#du_og_norge</a> <a title="انت_والنرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%86%D8%AA_%D9%88%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#انت_والنرويج</a> <a title="انت_والنروج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%86%D8%AA_%D9%88%D8%A7%D9%84%D9%86%D8%B1%D9%88%D8%AC?refer=embed">#انت_والنروج</a> <a title="صباح_الخير_اوسلو" target="_blank" href="https://www.tiktok.com/tag/%D8%B5%D8%A8%D8%A7%D8%AD_%D8%A7%D9%84%D8%AE%D9%8A%D8%B1_%D8%A7%D9%88%D8%B3%D9%84%D9%88?refer=embed">#صباح_الخير_اوسلو</a> <a title="اوروك" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%88%D8%B1%D9%88%D9%83?refer=embed">#اوروك</a> <a title="اوروك_الاعلامية" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%88%D8%B1%D9%88%D9%83_%D8%A7%D9%84%D8%A7%D8%B9%D9%84%D8%A7%D9%85%D9%8A%D8%A9?refer=embed">#اوروك_الاعلامية</a> <a title="منظمة_اوروك" target="_blank" href="https://www.tiktok.com/tag/%D9%85%D9%86%D8%B8%D9%85%D8%A9_%D8%A7%D9%88%D8%B1%D9%88%D9%83?refer=embed">#منظمة_اوروك</a> <a title="منظمة_اوروك_الاعلامية_المستقلة" target="_blank" href="https://www.tiktok.com/tag/%D9%85%D9%86%D8%B8%D9%85%D8%A9_%D8%A7%D9%88%D8%B1%D9%88%D9%83_%D8%A7%D9%84%D8%A7%D8%B9%D9%84%D8%A7%D9%85%D9%8A%D8%A9_%D8%A7%D9%84%D9%85%D8%B3%D8%AA%D9%82%D9%84%D8%A9?refer=embed">#منظمة_اوروك_الاعلامية_المستقلة</a> <a title="uruk" target="_blank" href="https://www.tiktok.com/tag/uruk?refer=embed">#uruk</a> <a title="urukmedia" target="_blank" href="https://www.tiktok.com/tag/urukmedia?refer=embed">#urukmedia</a> <a title="uruk_media" target="_blank" href="https://www.tiktok.com/tag/uruk_media?refer=embed">#uruk_media</a> <a title="الشرطة_النرويجية" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%B4%D8%B1%D8%B7%D8%A9_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC%D9%8A%D8%A9?refer=embed">#الشرطة_النرويجية</a> <a title="رئيس_الوزراء_النرويجي" target="_blank" href="https://www.tiktok.com/tag/%D8%B1%D8%A6%D9%8A%D8%B3_%D8%A7%D9%84%D9%88%D8%B2%D8%B1%D8%A7%D8%A1_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC%D9%8A?refer=embed">#رئيس_الوزراء_النرويجي</a> <a title="اوسلو_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%88%D8%B3%D9%84%D9%88_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#اوسلو_النرويج</a> <a title="صحفي_نرويجي" target="_blank" href="https://www.tiktok.com/tag/%D8%B5%D8%AD%D9%81%D9%8A_%D9%86%D8%B1%D9%88%D9%8A%D8%AC%D9%8A?refer=embed">#صحفي_نرويجي</a> <a title="الاعلام_الالكتروني" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%A7%D8%B9%D9%84%D8%A7%D9%85_%D8%A7%D9%84%D8%A7%D9%84%D9%83%D8%AA%D8%B1%D9%88%D9%86%D9%8A?refer=embed">#الاعلام_الالكتروني</a> <a title="اعلامي" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%B9%D9%84%D8%A7%D9%85%D9%8A?refer=embed">#اعلامي</a> <a title="اعلاميات" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%B9%D9%84%D8%A7%D9%85%D9%8A%D8%A7%D8%AA?refer=embed">#اعلاميات</a> <a title="نشرة_الاخبار" target="_blank" href="https://www.tiktok.com/tag/%D9%86%D8%B4%D8%B1%D8%A9_%D8%A7%D9%84%D8%A7%D8%AE%D8%A8%D8%A7%D8%B1?refer=embed">#نشرة_الاخبار</a> <a title="نشرة_الظهيرة" target="_blank" href="https://www.tiktok.com/tag/%D9%86%D8%B4%D8%B1%D8%A9_%D8%A7%D9%84%D8%B8%D9%87%D9%8A%D8%B1%D8%A9?refer=embed">#نشرة_الظهيرة</a> <a title="انباء" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%86%D8%A8%D8%A7%D8%A1?refer=embed">#انباء</a> <a title="وكالة_الانباء_النرويجية" target="_blank" href="https://www.tiktok.com/tag/%D9%88%D9%83%D8%A7%D9%84%D8%A9_%D8%A7%D9%84%D8%A7%D9%86%D8%A8%D8%A7%D8%A1_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC%D9%8A%D8%A9?refer=embed">#وكالة_الانباء_النرويجية</a> <a title="عناوين_الصحف" target="_blank" href="https://www.tiktok.com/tag/%D8%B9%D9%86%D8%A7%D9%88%D9%8A%D9%86_%D8%A7%D9%84%D8%B5%D8%AD%D9%81?refer=embed">#عناوين_الصحف</a> <a title="خبرية" target="_blank" href="https://www.tiktok.com/tag/%D8%AE%D8%A8%D8%B1%D9%8A%D8%A9?refer=embed">#خبرية</a> <a title="اذاعة_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%B0%D8%A7%D8%B9%D8%A9_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#اذاعة_النرويج</a> <a title="اذاعة_النرويج_بالعربي" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D8%B0%D8%A7%D8%B9%D8%A9_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC_%D8%A8%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A?refer=embed">#اذاعة_النرويج_بالعربي</a> <a title="راديو_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%B1%D8%A7%D8%AF%D9%8A%D9%88_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#راديو_النرويج</a> <a title="راديو_النرويج_بالعربي" target="_blank" href="https://www.tiktok.com/tag/%D8%B1%D8%A7%D8%AF%D9%8A%D9%88_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC_%D8%A8%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A?refer=embed">#راديو_النرويج_بالعربي</a> <a title="راديو_صوت_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%B1%D8%A7%D8%AF%D9%8A%D9%88_%D8%B5%D9%88%D8%AA_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#راديو_صوت_النرويج</a> <a title="الحقيقة" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%AD%D9%82%D9%8A%D9%82%D8%A9?refer=embed">#الحقيقة</a> <a title="حقيقة_الاخبار" target="_blank" href="https://www.tiktok.com/tag/%D8%AD%D9%82%D9%8A%D9%82%D8%A9_%D8%A7%D9%84%D8%A7%D8%AE%D8%A8%D8%A7%D8%B1?refer=embed">#حقيقة_الاخبار</a> <a title="norske_nyheter" target="_blank" href="https://www.tiktok.com/tag/norske_nyheter?refer=embed">#norske_nyheter</a> <a title="nyheter" target="_blank" href="https://www.tiktok.com/tag/nyheter?refer=embed">#nyheter</a> <a title="العربية" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9?refer=embed">#العربية</a> <a title="اهم_الاخبار_في_النرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%87%D9%85_%D8%A7%D9%84%D8%A7%D8%AE%D8%A8%D8%A7%D8%B1_%D9%81%D9%8A_%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#اهم_الاخبار_في_النرويج</a> <a title="duognorge" target="_blank" href="https://www.tiktok.com/tag/duognorge?refer=embed">#duognorge</a> <a title="du_og_norge" target="_blank" href="https://www.tiktok.com/tag/du_og_norge?refer=embed">#du_og_norge</a> <a title="انت_والنرويج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%86%D8%AA_%D9%88%D8%A7%D9%84%D9%86%D8%B1%D9%88%D9%8A%D8%AC?refer=embed">#انت_والنرويج</a> <a title="انت_والنروج" target="_blank" href="https://www.tiktok.com/tag/%D8%A7%D9%86%D8%AA_%D9%88%D8%A7%D9%84%D9%86%D8%B1%D9%88%D8%AC?refer=embed">#انت_والنروج</a> <a target="_blank" title="♬ الصوت الأصلي - اذاعة صوت النرويج" href="https://www.tiktok.com/music/الصوت-الأصلي-7356988261837851425?refer=embed">♬ الصوت الأصلي - اذاعة صوت النرويج</a> </section> </blockquote> <script async src="https://www.tiktok.com/embed.js"></script>'
                          );
                        } else if (phrase.left.startsWith('https')) {
                          print(phrase);
                          return TextButton(
                              onPressed: () {
                                _launchUrl(Uri.parse(phrase.left));
                              },
                              child: Text(
                                textAlign: TextAlign.right,
                                phrase.right.trim(),
                                style: GoogleFonts.rubik().copyWith(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ));
                        } else {
                          return  Text(
                            phrase.left.toString().trim()
                          );
                        }
                      }).toList(),
                    ),
                    Row(children: [
                      Container(
                        height: 90,
                        width: Get.width * 0.43 ,
                        // color: Colors.grey.shade100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Theme.of(context).brightness == ThemeMode.light?
                            lightColorScheme.onPrimaryContainer : darkColorScheme.surfaceVariant
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20 ,vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text((norwayNew.next?.left as List<String?>)[1]??"", textAlign: TextAlign.center,
                            maxLines: 3,overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                      ),
                      SizedBox(width: 4,),
                      Container(
                        height: 90,
                        width: Get.width * 0.43 ,
                        // color: Colors.grey.shade100,
                        padding: EdgeInsets.symmetric(horizontal: 20 ,vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Theme.of(context).brightness == ThemeMode.light?
                          lightColorScheme.surfaceVariant : darkColorScheme.surfaceVariant
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text((norwayNew.prev?.left as List<String?>)[1]??"", textAlign: TextAlign.center,
                              maxLines: 3,overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                      )
                    ],mainAxisAlignment: MainAxisAlignment.center,),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Container(width: 3,),
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
                                    Share.share(
                                        'check out norway arabic new on ${norwayNew.link}');
                                  },
                                  child: Icon(Icons.share_outlined));
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
                                    child: Image.asset(
                                        'assets/images/twitter.png'),
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
