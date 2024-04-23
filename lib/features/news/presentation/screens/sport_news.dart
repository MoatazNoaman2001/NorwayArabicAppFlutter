import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/general/general_news_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/local_news.dart';
import 'package:norway_flutter_app/features/news/presentation/widgets/new_card_rcycle_item.dart';
import 'package:norway_flutter_app/main.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/norway_new.dart';
import 'package:norway_flutter_app/core/constants.dart';

class SportNews extends StatefulWidget {
  final String url;

  const SportNews({super.key, required this.url});

  @override
  State<SportNews> createState() => _SportNewsState(url);
}

class _SportNewsState extends State<SportNews> {
  final String url;
  bool isTv = false;

  _SportNewsState(this.url);

  final ConnectivityController connectivityController =
      ConnectivityController();
  List<NorwayNew> norways = [];

  @override
  void initState() {
    super.initState();
    connectivityController.init();
    context.read<NewsBloc>().add(
        GetSportNorwayNewsList(
            url,[]
        )
    );
    isDeviceIsTv();
  }

  void isDeviceIsTv() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isTv = androidInfo.systemFeatures.contains('android.software.leanback');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.Sport.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: connectivityController.isConnected,
                builder: (context, value, child) {
                  if (value || isTv) {
                    return SizedBox.shrink();
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
                listener: (context, state) {
                  if (state is SportNewsSuccess) {
                  } else if (state is SportNewsFailure) {
                    var snack = SnackBar(
                      content: const Text('would you like to retry'),
                      duration: Duration(hours: 1),
                      action: SnackBarAction(
                        onPressed: () {
                          context
                              .read<NewsBloc>()
                              .add(GetPoliticalNorwayNewsList(url, norways));
                        },
                        label: "ok",
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);

                    Constants.makeToast(
                        'could not get list ${state.msg}');
                  }
                },
                builder: (context, state) {
                  var bloc = BlocProvider.of<NewsBloc>(context);
                  if (state is SportNewsSuccess || state is SportNewsFailure){
                    bloc.loadingPage = false;
                  }
                  if (state is SportNewsLoading && bloc.sport_norways.isEmpty) {
                    return SportNewLoadingView();
                  } else if (state is SportNewsSuccess || (state is SportNewsLoading && bloc.sport_norways.isNotEmpty)) {
                    return SportNewSuccessView(url: url , isTV: isTv,);
                  } else if (state is SportNewsFailure) {
                    return SportNewLoadingView();
                  } else {
                    return SportNewLoadingView();
                  }
                },
              )
            ],
          ),
        )
    );
  }
}

class SportNewLoadingView extends StatelessWidget {
  const SportNewLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height * 0.25),
        child: Column(children: [
          LinearProgressIndicator(
            borderRadius:
            BorderRadius.all(Radius.circular(8)),
          ),
        ]),
      ),
    );
  }
}

class SportNewSuccessView extends StatelessWidget {
  final String url;
  final bool isTV;
  const SportNewSuccessView({super.key, required this.url, required this.isTV});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<NewsBloc>(context);
    var controller = ScrollController(
      onAttach: (position) {},
    );
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
        } else {
          if (bloc.loadingPage == false) {
            bloc.loadingPage = true;
            bloc.pageNum[4] = bloc.pageNum[4] + 1;
            context.read<NewsBloc>().add(GetSportNorwayNewsList(
                '$url/page/${bloc.pageNum[4]}/', []));
          }else {

          }
        }
      }
    });
    return OrientationBuilder(
        builder: (context, orientation) {
          var width =  MediaQuery.of(context).size.width;
          var height =  MediaQuery.of(context).size.height;
          print(orientation.toString() + 'width: ${MediaQuery.of(context).size.width},height: ${MediaQuery.of(context).size.height}');
          return Container(
            width: width,
            height: height - (height *( width > height? 0.22 : 0.15)),
            child: GridView.count(
                padding: EdgeInsets.symmetric(horizontal: 8),
                crossAxisCount: isTV || width > height ? 2 : MediaQuery.of(context).size.shortestSide < 600? 1 : 2,
                shrinkWrap: true,
                controller: controller,
                childAspectRatio: isTV ? 1.5 : 1.2,
                physics: BouncingScrollPhysics(),
                children: bloc.sport_norways.map((e) {
                  return NewsCardRecycleItem(
                    norwayNew: e,
                    callback: () {
                      Navigator.of(context)
                          .pushNamed('/details', arguments: e);
                    },
                  );
                }).toList()),
          );
        }
    );
  }
}

