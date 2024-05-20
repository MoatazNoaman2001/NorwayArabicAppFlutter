import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/core/theme/color_schemes.g.dart';
import 'package:norway_flutter_app/features/news/presentation/widgets/new_card_rcycle_item.dart';
import 'package:norway_flutter_app/main.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/norway_new.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

import '../bloc/general/general_news_bloc.dart';
import '../widgets/swipper_view.dart';

class ApplicationNews extends StatefulWidget {
  final String url;

  const ApplicationNews({super.key, required this.url});

  @override
  State<ApplicationNews> createState() => _ApplicationNewsState(url);
}

class _ApplicationNewsState extends State<ApplicationNews> {
  final String url;
  bool isTV = false;

  _ApplicationNewsState(this.url);

  final ConnectivityController connectivityController =
      ConnectivityController();
  List<NorwayNew> norways = [];

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<NewsBloc>(context);
    var controller = ScrollController(
      onAttach: (position) {},
    );
    var parent_controller = ScrollController(
      onAttach: (position) {},
    );
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
          parent_controller.animateTo(0.0,
              duration: Duration(milliseconds: 200), curve: Curves.ease);
        } else {
          if (bloc.loadingPage == false) {
            bloc.loadingPage = true;
            bloc.pageNum[5] = bloc.pageNum[5] + 1;
            context.read<NewsBloc>().add(GetApplicationNewsList(
                '$url/page/${bloc.pageNum[5]}/', norways));
          }
        }
      }

      final current_pos = controller.offset;
      var topindex = current_pos ~/ (MediaQuery.of(context).size.width / 0.75);
      print(topindex);
      if (topindex != 0)
        parent_controller.animateTo(120.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
    });
    return SingleChildScrollView(
      controller: parent_controller,
      child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: connectivityController.isConnected,
                builder: (context, value, child) {
                  if (value || isTV) {
                    return Center();
                  } else {
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              color: Colors.grey.shade800,
                              child: const Text(
                                'No Internet Connection',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
              BlocConsumer<NewsBloc, NewsState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is ApplicationNewsLoading || state is SwiperNewsLoading)
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        minHeight: 8,
                      ),
                    );
                  else
                    return SizedBox.shrink();
                },
              ),
              SwiperWid(),
              SizedBox(
                height: 10,
              ),
              BlocConsumer<NewsBloc, NewsState>(listener: (context, state) {
                if (state is ApplicationNewListSuccess || state is ApplicationNewListFailure) {
                  bloc.loadingPage = false;
                }
                if (state is ApplicationNewListSuccess) {} else if (state is ApplicationNewListFailure) {
                  var snack = SnackBar(
                    content: const Text('would you like to retry'),
                    duration: Duration(hours: 1),
                    action: SnackBarAction(
                      onPressed: () {
                        context
                            .read<NewsBloc>()
                            .add(GetApplicationNewsList(url, norways));
                      },
                      label: "ok",
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snack);

                  Constants.makeToast('could not get list ${state.msg}');
                }
              }, builder: (context, state) {
                if (state is ApplicationNewsLoading && bloc.application_news.isEmpty) {
                  return ApplicationNewsLoadingScreen(
                    isTV: isTV,
                  );
                } else if (state is ApplicationNewListSuccess ||
                    (state is ApplicationNewsLoading &&
                        bloc.application_news.isNotEmpty)) {
                  return ApplicationNewsSuccessScreen(
                    n: bloc.application_news.toList(),
                    url: url,
                    isTv: isTV,
                    parentController: parent_controller,
                  );
                } else if (bloc.application_news.isNotEmpty) {
                  return ApplicationNewsSuccessScreen(
                    n: bloc.application_news.toList(),
                    url: url,
                    isTv: isTV,
                    parentController: parent_controller,
                  );
                } else {
                  return ApplicationNewsLoadingScreen(
                    isTV: isTV,
                  );
                }
              })
            ],
          )),
    );
  }

  void makeToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1);
  }

  @override
  void initState() {
    super.initState();
    connectivityController.init();
    context.read<NewsBloc>().add(GetApplicationNewsList(url, []));
    context.read<NewsBloc>().add(GetSwiperNorwayNewsList());
    isDeviceIsTv();
  }

  void isDeviceIsTv() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isTV = androidInfo.systemFeatures.contains('android.software.leanback');
  }
}

class ApplicationNewsLoadingScreen extends StatelessWidget {
  final bool isTV;

  const ApplicationNewsLoadingScreen({super.key, required this.isTV});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height * 0.2045),
        child: Column(children: [
          Expanded(
              child: GridView.count(
                  crossAxisCount: isTV ? 2 : 1,
                  padding: EdgeInsets.only(right: 4, left: 4),
                  children: List.generate(10, (index) {
                    return Shimmer.fromColors(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          padding: EdgeInsets.all(4),
                          color: Colors.white70,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                        ),
                        baseColor: Colors.transparent,
                        highlightColor: Colors.white12);
                  })))
        ]),
      ),
    );
    ;
  }
}

class ApplicationNewsSuccessScreen extends StatefulWidget {
  final List<NorwayNew> n;
  final ScrollController parentController;
  final String url;
  final bool isTv;

  const ApplicationNewsSuccessScreen(
      {super.key,
        required this.n,
        required this.url,
        required this.isTv,
        required this.parentController});

  @override
  State<ApplicationNewsSuccessScreen> createState() => _ApplicationNewsSuccessScreenState();
}

class _ApplicationNewsSuccessScreenState extends State<ApplicationNewsSuccessScreen> {


  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<NewsBloc>(context);

    var controller = ScrollController();
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
          widget.parentController.animateTo(0.0,
              duration: Duration(milliseconds: 200), curve: Curves.ease);
        } else {
          if (bloc.loadingPage == false) {
            setState(() {
              bloc.loadingPage = true;
            });
            bloc.pageNum[5] = bloc.pageNum[5] + 1;
            context.read<NewsBloc>().add(
                GetApplicationNewsList('${widget.url}/page/${bloc.pageNum[5]}/', widget.n));
          }
        }
      }

      final current_pos = controller.offset;
      var topindex = current_pos ~/ (MediaQuery.of(context).size.width / 0.75);
      print(topindex);
      if (topindex != 0)
        widget.parentController.animateTo(120.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
    });
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        children: [
          OrientationBuilder(builder: (context, orientation) {
            var width = MediaQuery.of(context).size.width;
            var height = MediaQuery.of(context).size.height;
            print(orientation.toString() +
                'width: ${MediaQuery.of(context).size.width},height: ${MediaQuery.of(context).size.height}');
            return Container(
              width: width,
              height: height - (height * (width > height ? 0.22 : 0.15)),
              child: GridView.count(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  crossAxisCount: widget.isTv || width > height ? 2 : MediaQuery.of(context).size.shortestSide < 600? 1 : 2,
                  shrinkWrap: true,
                  controller: controller,
                  childAspectRatio: widget.isTv ? 1.5 : 1.2,
                  physics: BouncingScrollPhysics(),
                  children: bloc.application_news.map((e) {
                    return NewsCardRecycleItem(
                      norwayNew: e,
                      callback: () {
                        Navigator.of(context).pushNamed('/details', arguments: e);
                      },
                    );
                  }).toList()),
            );
          }),
          if (bloc.loadingPage)
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('loading', style: GoogleFonts.rubik())
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
