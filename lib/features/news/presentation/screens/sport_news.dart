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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'الرياضية',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: connectivityController.isConnected,
          builder: (context, value, child) {
            if (value) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
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
                        if (state is SportNewsLoading && bloc.sport_norways.isEmpty) {
                          return SportNewLoadingView();
                        } else if (state is SportNewsSuccess
                         || (state is SportNewsLoading && bloc.sport_norways.isNotEmpty)) {
                          return SportNewSuccessView(url: url);
                        } else if (state is SportNewsFailure) {
                          return SportNewLoadingView();
                        } else {
                          return SportNewLoadingView();
                        }
                      },
                    )
                  ],
                ),
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
        ));
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
  const SportNewSuccessView({super.key, required this.url});

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
          context
              .read<NewsBloc>()
              .add(GetPoliticalNorwayNewsList(url, bloc.sport_norways));
        }
      }
    });
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -
          (MediaQuery.of(context).size.height * 0.205),
      child: Column(
        children: [
          // ListView(),
          Expanded(
              child: ListView.builder(
                controller: controller,
                padding:
                const EdgeInsets.only(right: 8, left: 8),
                itemCount: bloc.sport_norways.length,
                itemBuilder: (context, index) {
                  return NewsCardRecycleItem(
                    norwayNew: bloc.sport_norways[index],
                    callback: () {
                      Navigator.of(context).pushNamed('/details' , arguments: bloc.sport_norways[index]);
                    },
                  );
                },
              ))
        ],
      ),
    );
  }
}

