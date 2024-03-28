import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/presentation/widgets/new_card_rcycle_item.dart';
import 'package:norway_flutter_app/main.dart';
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
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {
        } else {
          makeToast('current page is: ${bloc.pageNum[0]}');
          bloc.pageNum[0] = bloc.pageNum[0] + 1;
          context.read<NewsBloc>().add(GetGeneralNorwayNewsList(
              '$url/page/${bloc.pageNum[0]}/', norways));
        }
      }
    });
    return SingleChildScrollView(
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
              SwiperWid(),
              SizedBox(
                height: 10,
              ),
              BlocConsumer<NewsBloc, NewsState>(
                listener: (context, state) {
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
                },
                builder: (context, state) {
                  if (state is GeneralNewsLoading &&
                      bloc.general_norways.isEmpty) {
                    return GeneralNewsLoading();
                  } else if (state is GeneralNewsSuccess ||
                      (state is GeneralNewsLoading &&
                          bloc.general_norways.isNotEmpty)) {
                    if (isTV){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height * 0.205),
                        child: Column(
                          children: [
                            Expanded(
                                child:GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 3),
                                    itemCount: bloc.general_norways.length,
                                    padding: EdgeInsets.only(right: 8 , left: 8),
                                    itemBuilder: (context, index) {
                                      return NewsCardRecycleItem(
                                        norwayNew: bloc.general_norways.toList()[index],
                                        callback: () {
                                          makeToast('clicked');
                                          Navigator.of(context).pushNamed('/details',
                                              arguments: bloc.general_norways.toList()[index]);
                                        },
                                      );
                                    },
                                )

                            )
                          ],
                        ),
                      );
                    }else
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).size.height * 0.205),
                      child: Column(
                        children: [
                          Expanded(
                              child: ListView.builder(
                            controller: controller,
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(right: 4, left: 4),
                            itemCount: bloc.general_norways.length,
                            itemBuilder: (context, index) {
                              return NewsCardRecycleItem(
                                norwayNew: bloc.general_norways.toList()[index],
                                callback: () {
                                  makeToast('clicked');
                                  Navigator.of(context).pushNamed('/details',
                                      arguments: bloc.general_norways.toList()[index]);
                                },
                              );
                            },
                          ))
                        ],
                      ),
                    );
                  } else {
                    if (bloc.general_norways.isNotEmpty) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.height * 0.205),
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                              controller: controller,
                              padding: const EdgeInsets.only(right: 4, left: 4),
                              itemCount: bloc.general_norways.length,
                              itemBuilder: (context, index) {
                                return NewsCardRecycleItem(
                                  norwayNew: bloc.general_norways.toList()[index],
                                  callback: () {
                                    Navigator.of(context).pushNamed('/details',
                                        arguments: bloc.general_norways.toList()[index]);
                                  },
                                );
                              },
                            ))
                          ],
                        ),
                      );
                    } else {
                      return GeneralNewsLoading();
                    }
                  }
                },
              )
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
  }
}

class GeneralNewsLoading extends StatelessWidget {
  const GeneralNewsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).size.height * 0.2045),
        child: Column(children: [
          LinearProgressIndicator(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            minHeight: 8,
          ),
          Expanded(
              child: ListView.builder(
            padding: EdgeInsets.only(right: 4, left: 4),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    padding: EdgeInsets.all(4),
                    color: Colors.white70,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
                  ),
                  baseColor: Colors.white12,
                  highlightColor: Colors.white24);
            },
          ))
        ]),
      ),
    );
    ;
  }
}
