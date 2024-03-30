import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/general/general_news_bloc.dart';
import 'package:norway_flutter_app/features/news/presentation/widgets/new_card_rcycle_item.dart';
import 'package:norway_flutter_app/main.dart';
import '../../data/models/norway_new.dart';
import 'package:norway_flutter_app/core/constants.dart';

class OnBoard extends StatefulWidget {
  final String url;

  const OnBoard({super.key, required this.url});

  @override
  State<OnBoard> createState() => _OnBoardState(url);
}

class _OnBoardState extends State<OnBoard> {
  final String url;

  _OnBoardState(this.url);

  final ConnectivityController connectivityController =
  ConnectivityController();
  List<NorwayNew> norways = [];

  @override
  void setState(VoidCallback fn) {}

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey[800]!;
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width,
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
                            color: Theme.of(context).brightness == Brightness.dark? Colors.white30 : Colors.white70,
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
                if (state is OnBoardNewsSuccess) {

                } else if (state is OnBoardNewsFailure) {
                  print('onboard error msg: ${state.msg}');
                  var snack = SnackBar(
                    content: const Text('would you like to retry'),
                    duration: Duration(seconds: 6),
                    action: SnackBarAction(
                      onPressed: () {
                        context.read<NewsBloc>().add(
                            GetOnBoardNorwayNewsList(url, norways)
                        );
                      },
                      label: "ok",
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                }
              },
              builder: (context, state) {
                var bloc = BlocProvider.of<NewsBloc>(context);
                if ( state is OnBoardNewsSuccess || state is OnBoardNewsFailure){
                  bloc.loadingPage = false;
                }
                if (state is OnBoardNewsLoading && bloc.onboard_norways.isEmpty) {
                  return SingleChildScrollView(
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height -
                          (MediaQuery
                              .of(context)
                              .size
                              .height * 0.25),
                      child: Column(children: [
                        LinearProgressIndicator(
                          borderRadius:
                          BorderRadius.all(Radius.circular(8)),
                        ),
                      ]),
                    ),
                  );
                } else if (state is OnBoardNewsSuccess ||
                    (state is OnBoardNewsLoading &&
                        bloc.onboard_norways.isNotEmpty)) {
                  return OnBoardSuccessView(n: bloc.onboard_norways.toList(), url: url);
                } else if (state is OnBoardNewsFailure) {
                  if (bloc.onboard_norways.isNotEmpty) {
                    return OnBoardSuccessView(n: bloc.onboard_norways.toList(),
                        url: url);
                  } else {
                    return SingleChildScrollView(
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height -
                            (MediaQuery
                                .of(context)
                                .size
                                .height * 0.25),
                        child: Column(children: [
                          LinearProgressIndicator(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8)),
                          ),
                        ]),
                      ),
                    );
                  }
                } else {
                  if (bloc.onboard_norways.isNotEmpty) {
                    return OnBoardSuccessView(n: bloc.onboard_norways.toList(),
                        url: url);
                  } else {
                    return SingleChildScrollView(
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height -
                            (MediaQuery
                                .of(context)
                                .size
                                .height * 0.25),
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
              },
            )
          ],
        ),
      ),
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
    context.read<NewsBloc>().add(GetOnBoardNorwayNewsList(url, []));
  }
}

class OnBoardSuccessView extends StatelessWidget {
  final List<NorwayNew> n;
  final String url;

  const OnBoardSuccessView({super.key, required this.n, required this.url});

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
            bloc.pageNum[1] = bloc.pageNum[1] + 1;
            context.read<NewsBloc>().add(GetOnBoardNorwayNewsList(
                '$url/page/${bloc.pageNum[1]}/', []));
          }else {

          }
        }
      }
    });
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height
          - (MediaQuery
              .of(context)
              .size
              .height * 0.205),
      child: Column(
        children: [
          // ListView(),
          Expanded(
              child: ListView.builder(
                controller: controller,
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                    right: 8, left: 8),
                itemCount: n.length,
                itemBuilder: (context, index) {
                  return NewsCardRecycleItem(
                    norwayNew: n[index],
                    callback: () {
                      Navigator.of(context).pushNamed(
                          '/details', arguments: n[index]);
                    },
                  );
                },
              ))
        ],
      ),
    );
  }
}



