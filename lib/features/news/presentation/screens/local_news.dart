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
import 'package:norway_flutter_app/features/news/presentation/widgets/new_card_rcycle_item.dart';
import 'package:norway_flutter_app/main.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../data/models/norway_new.dart';
import 'package:norway_flutter_app/core/constants.dart';

class LocalNews extends StatefulWidget {
  final String url;

  const LocalNews({super.key, required this.url});

  @override
  State<LocalNews> createState() => _LocalNewsState(url);
}

class _LocalNewsState extends State<LocalNews> {
  final String url;
  bool isTV = false;

  _LocalNewsState(this.url);

  final ConnectivityController connectivityController =
      ConnectivityController();
  List<NorwayNew> norways = [];

  @override
  void initState() {
    super.initState();
    connectivityController.init();
    context.read<NewsBloc>().add(GetLocalNorwayNewsList(url, []));
    isDeviceIsTv();
  }

  void isDeviceIsTv() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isTV = androidInfo.systemFeatures.contains('android.software.leanback');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.Local.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: connectivityController.isConnected,
              builder: (context, value, child) {
                if (value || isTV) {
                  return SizedBox(

                  );
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
                if (state is LocalNewsSuccess) {
                } else if (state is LocalNewsFailure) {
                  var snack = SnackBar(
                    content: const Text('would you like to retry'),
                    duration: Duration(hours: 1),
                    action: SnackBarAction(
                      onPressed: () {
                        context.read<NewsBloc>().add(
                            GetPoliticalNorwayNewsList(url, norways));
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
                final bloc = BlocProvider.of<NewsBloc>(context);
                if (state is LocalNewsSuccess ||
                    state is LocalNewsFailure) {
                  bloc.loadingPage = false;
                }
                if (state is LocalNewsLoading &&
                    bloc.local_norways.isEmpty) {
                  return LocalNewLoadingView();
                } else if (state is LocalNewsSuccess ||
                    (state is LocalNewsLoading &&
                        bloc.local_norways.isNotEmpty)) {
                  return LocalNewSuccessView(
                    url: url,
                    isTV: isTV,
                  );
                } else if (state is LocalNewsFailure) {
                  return LocalNewLoadingView();
                } else {
                  return LocalNewLoadingView();
                }
              },
            )
          ],
        ));
  }
}

class LocalNewLoadingView extends StatelessWidget {
  const LocalNewLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height * 0.15),
        child: Column(children: [
          LinearProgressIndicator(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ]),
      ),
    );
  }
}

class LocalNewSuccessView extends StatelessWidget {
  final String url;
  final bool isTV;

  const LocalNewSuccessView({super.key, required this.url, required this.isTV});

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
            bloc.pageNum[3] = bloc.pageNum[3] + 1;
            context.read<NewsBloc>().add(
                GetLocalNorwayNewsList('$url/page/${bloc.pageNum[3]}/', []));
          } else {}
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
              crossAxisCount:
              isTV || width > height ? 2 : 1,
              shrinkWrap: true,
              controller: controller,
              childAspectRatio: isTV ? 1.5 : 1.2,
              physics: BouncingScrollPhysics(),
              children: bloc.local_norways.map((e) {
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
