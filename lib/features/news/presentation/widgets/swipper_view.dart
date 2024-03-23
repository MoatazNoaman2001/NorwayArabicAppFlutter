import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../bloc/general/general_news_bloc.dart';

class SwiperWid extends StatelessWidget {
  const SwiperWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is SwiperNewsSuccess){
            Constants.makeToast('Swiper Received');

          }else if(state is SwiperNewsLoading){
            Constants.makeToast('Swiper Loading');

          }else if (state is SwiperNewsFailure){
            Constants.makeToast('Swiper Failure');

          }
        },
        builder: (context, state) {
          if (state is SwiperNewsLoading) {
            return const SwiperLoadingState();
          } else if (state is SwiperNewsSuccess) {
            return SwiperSuccessState(norways: state.norways);
          }else if (state is SwiperNewsFailure){
            return Center(
              child: Text('error : ${state.msg}'),
            );
          }else {
            var bloc= BlocProvider.of<NewsBloc>(context);
            if (bloc.swiperList.isNotEmpty)
              return SwiperSuccessState(norways: bloc.swiperList);
            return SwiperLoadingState();
          }
        },
      ),
    );
  }
}


class SwiperLoadingState extends StatelessWidget {
  const SwiperLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Container(
          width: 220,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
          ),
        ),
        baseColor: Colors.white12,
        highlightColor: Colors.white30
    );
  }
}

class SwiperSuccessState extends StatelessWidget {
  final List<NorwayNew> norways;
  const SwiperSuccessState({super.key , required this.norways});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: InfiniteCarousel.builder(
        itemCount: norways.length,
        itemExtent: 120,
        anchor: 0.0,
        velocityFactor: 0.2,
        onIndexChanged: (index) {},
        controller: InfiniteScrollController(),
        axisDirection: Axis.horizontal,
        loop: true,
        itemBuilder: (context, itemIndex, realIndex) {
          return Container(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
              child:
              Column(
                children: [
                  // Flexible(
                  //   child:CachedNetworkImage(
                  //     imageUrl: norways[itemIndex >= norways.length? itemIndex - norways.length: itemIndex].image,
                  //     placeholderFadeInDuration: Durations.medium3,
                  //     imageBuilder: (context, imageProvider) => Container(
                  //       decoration: BoxDecoration(
                  //         image: DecorationImage(
                  //           image: imageProvider,
                  //           fit: BoxFit.cover,),
                  //       ),
                  //     ),
                  //     progressIndicatorBuilder: (context, url, progress) =>
                  //         Container(
                  //           child: LinearProgressIndicator(value: progress.progress,),
                  //         ),
                  //     errorWidget: (context, url, error) =>
                  //         Image.asset('assets/images/head_logo.jpeg'),
                  //   ),
                  // ),
                  // Flexible(
                  //     child: Text(norways[itemIndex >= norways.length? itemIndex - norways.length: itemIndex].title)
                  // )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

