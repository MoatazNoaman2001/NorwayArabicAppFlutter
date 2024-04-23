import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/core/theme/color_schemes.g.dart';
import 'package:norway_flutter_app/features/news/data/models/web_pairs.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/platforms/platform_bloc.dart';

class ContactUSScreen extends StatefulWidget {
  const ContactUSScreen({super.key});

  @override
  State<ContactUSScreen> createState() => _ContactUSScreenState();
}

class _ContactUSScreenState extends State<ContactUSScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlatformBloc>().add(ContactUSList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('للاتصال بنا'),
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
        margin: EdgeInsets.all(30),
        child: BlocConsumer<PlatformBloc, PlatformState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is ContactUSLoading) {
              return ContactUSLoading();
            } else if (state is ContactUSSuccess) {
              return ContactUsSuccess(contents: state.contents);
            } else if (state is ContactUSFailure) {
              return ContactUSLoading();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class ContactUSLoading extends StatelessWidget {
  const ContactUSLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Center(
          child: Shimmer.fromColors(
              child: Card(),
              baseColor: Colors.transparent,
              highlightColor: Colors.black12),
        ),
      ),
    );
  }
}

class ContactUsSuccess extends StatelessWidget {
  final List<WebPair> contents;

  const ContactUsSuccess({super.key, required this.contents});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: contents.length,
          itemBuilder: (context, index) {
            if (contents[index].right.isEmpty || contents[index].left.isEmpty)
              return SizedBox.shrink();
            if (contents[index].right.contains('http')) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl: contents[index].right,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: imageProvider,
                              // fit: BoxFit.fill
                            )),
                      );
                    },
                    progressIndicatorBuilder: (context, url, progress) {
                      return Center(
                        child:
                            CircularProgressIndicator(value: progress.progress),
                      );
                    },
                  ),
                  Text(
                    contents[index].left,
                    style: GoogleFonts.cairo().copyWith(fontSize: 16),
                  )
                ],
              );
            } else {
              return Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    contents[index].right,
                    style: GoogleFonts.rubik().copyWith(
                        color: lightColorScheme.primary, fontSize: 16),
                  ),
                  Text(':'),
                  TextButton(
                      onPressed: () {
                        _launchUrl(Uri.parse(contents[index].left));
                      },
                      onLongPress: () async {
                        await Clipboard.setData(
                            ClipboardData(text: contents[index].left));
                      },
                      child: Text(
                        contents[index].left,
                        style: GoogleFonts.rubik().copyWith(fontSize: 16),
                      ))
                ],
              );
            }
          },
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
