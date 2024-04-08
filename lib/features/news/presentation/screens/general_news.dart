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

class GeneralNews extends StatefulWidget {
  final String url;

  const GeneralNews({super.key, required this.url});

  @override
  State<GeneralNews> createState() => _GeneralNewsState(url);
}

class _GeneralNewsState extends State<GeneralNews> {
  final String url;
  bool isTV = false;

  _GeneralNewsState(this.url);

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
            bloc.pageNum[0] = bloc.pageNum[0] + 1;
            context.read<NewsBloc>().add(GetGeneralNorwayNewsList(
                '$url/page/${bloc.pageNum[0]}/', norways));
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
                  if (value) {
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
                  if (state is SwiperNewsLoading || state is GeneralNewsLoading)
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
                if (state is GeneralNewsSuccess) {
                } else if (state is GeneralNewsFailure) {
                  var snack = SnackBar(
                    content: const Text('would you like to retry'),
                    duration: Duration(hours: 1),
                    action: SnackBarAction(
                      onPressed: () {
                        context
                            .read<NewsBloc>()
                            .add(GetGeneralNorwayNewsList(url, norways));
                      },
                      label: "ok",
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snack);

                  Constants.makeToast('could not get list ${state.msg}');
                }
              }, builder: (context, state) {
                if (state is GeneralNewsSuccess ||
                    state is GeneralNewsFailure) {
                    bloc.loadingPage = false;

                }
                if (state is GeneralNewsLoading &&
                    bloc.general_norways.isEmpty) {
                  return GeneralNewsLoading(
                    isTV: isTV,
                  );
                } else if (state is GeneralNewsSuccess ||
                    (state is GeneralNewsLoading &&
                        bloc.general_norways.isNotEmpty)) {
                  return GeneralListSuccessView(
                    n: bloc.general_norways.toList(),
                    url: url,
                    isTv: isTV,
                    parentController: parent_controller,
                  );
                } else if (bloc.general_norways.isNotEmpty) {
                  return GeneralListSuccessView(
                    n: bloc.general_norways.toList(),
                    url: url,
                    isTv: isTV,
                    parentController: parent_controller,
                  );
                } else {
                  return GeneralNewsLoading(
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
    context.read<NewsBloc>().add(GetGeneralNorwayNewsList(url, []));
    context.read<NewsBloc>().add(GetSwiperNorwayNewsList());
    isDeviceIsTv();
  }

  void isDeviceIsTv() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isTV = androidInfo.systemFeatures.contains('android.software.leanback');
  }
}

class GeneralNewsLoading extends StatelessWidget {
  final bool isTV;

  const GeneralNewsLoading({super.key, required this.isTV});

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

class GeneralListSuccessView extends StatefulWidget {
  final List<NorwayNew> n;
  final ScrollController parentController;
  final String url;
  final bool isTv;

  const GeneralListSuccessView(
      {super.key,
        required this.n,
        required this.url,
        required this.isTv,
        required this.parentController});

  @override
  State<GeneralListSuccessView> createState() => _GeneralListSuccessViewState();
}

class _GeneralListSuccessViewState extends State<GeneralListSuccessView> {


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
            bloc.pageNum[0] = bloc.pageNum[0] + 1;
            context.read<NewsBloc>().add(
                GetGeneralNorwayNewsList('${widget.url}/page/${bloc.pageNum[0]}/', widget.n));
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
    return Column(
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
                crossAxisCount: widget.isTv || width > height ? 2 : 1,
                shrinkWrap: true,
                controller: controller,
                childAspectRatio: widget.isTv ? 1 : 1.2,
                physics: BouncingScrollPhysics(),
                children: bloc.general_norways.map((e) {
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
    );
  }
}
