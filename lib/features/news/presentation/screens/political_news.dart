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
import 'package:norway_flutter_app/translations/locale_keys.g.dart';
import '../../data/models/norway_new.dart';
import 'package:norway_flutter_app/core/constants.dart';

class PoliticalNews extends StatefulWidget {
  final String url;

  const PoliticalNews({super.key, required this.url});

  @override
  State<PoliticalNews> createState() => _PoliticalNewsState(url);
}

class _PoliticalNewsState extends State<PoliticalNews> {
  final String url;

  _PoliticalNewsState(this.url);

  final ConnectivityController connectivityController =
  ConnectivityController();
  List<NorwayNew> norways = [];

  @override
  void initState() {
    super.initState();
    connectivityController.init();
    context.read<NewsBloc>().add(
        GetPoliticalNorwayNewsList(
            url, []
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.Political.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
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
                  if (state is PoliticalNewsSuccess) {} else
                  if (state is PoliticalNewsFailure) {
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
                  }
                },
                builder: (context, state) {
                  if (state is PoliticalNewsSuccess) {
                    return PoliticalNewsSuccessView(url: url,);
                  } else {
                    return PoliticalNewsLoadingView();
                  }
                },
              )
            ],
          ),
        ),
      )


     );
  }
}

class PoliticalNewsLoadingView extends StatelessWidget {
  const PoliticalNewsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Column(children: [
          LinearProgressIndicator(
            borderRadius:
            BorderRadius.all(Radius.circular(8)),
          ),
        ]),
      ),
    );;
  }
}

class PoliticalNewsSuccessView extends StatelessWidget {
  final String url;

  const PoliticalNewsSuccessView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<NewsBloc>(context);
    var controller = ScrollController(
      onAttach: (position) {},
    );
    controller.addListener(() {
      if (controller.position.atEdge) {
        bool isTop = controller.position.pixels == 0;
        if (isTop) {} else {
          context
              .read<NewsBloc>()
              .add(GetPoliticalNorwayNewsList(url, []));
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
          .height,
      child: Column(
        children: [
          // ListView(),
          Expanded(
              child: ListView.builder(
                controller: controller,
                padding:
                const EdgeInsets.only(right: 8, left: 8),
                itemCount: bloc.political_norways.length,
                itemBuilder: (context, index) {
                  return NewsCardRecycleItem(
                    norwayNew: bloc.political_norways.toList()[index],
                    callback: () {
                      Navigator.of(context).pushNamed(
                          '/details', arguments: bloc.political_norways.toList()[index]);
                    },
                  );
                },
              ))
        ],
      ),
    );
  }
}

