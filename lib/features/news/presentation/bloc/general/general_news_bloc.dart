import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/domain/usecases/get_swiper_news_list.dart';

import '../../../data/models/norway_new.dart';
import '../../../domain/usecases/get_news_list.dart';
import 'package:fpdart/fpdart.dart';

part 'general_news_event.dart';
part 'general_news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
    final GetNewsListUseCase getNewsListUseCase;
    final GetSwiperNewsListUseCase getSwiperNewsListUseCase;
    final List<NorwayNew> general_norways = [];
    final List<NorwayNew> onboard_norways = [];
    List<NorwayNew> swiperList = [];
    final List<NorwayNew> political_norways = [];
    final List<NorwayNew> local_norways = [];
    final List<NorwayNew> sport_norways = [];
    final List<int> pageNum = [1,1,1,1,1];
  NewsBloc({required this.getNewsListUseCase, required this.getSwiperNewsListUseCase}) : super(NewsInitial()) {
    on<GetSwiperNorwayNewsList>((event, emit) async{
      emit(SwiperNewsLoading());
      Constants.makeToast('try to Fetch data');
      var res = await getSwiperNewsListUseCase();
      Constants.makeToast('data fetched');
      return res.fold((l) => emit(SwiperNewsFailure(l.msg)), (r) {
        swiperList = r;
        return emit(SwiperNewsSuccess(r));
      });
    },);
    on<GetGeneralNorwayNewsList>((event, emit) async {
      emit(GeneralNewsLoading());
      final res = await getNewsListUseCase(event.url);
      return res.fold((l) => emit(SwiperNewsFailure(l.msg)),(r) {
        general_norways.addAll(r);
        emit(GeneralNewsSuccess(general_norways));
      });
    });

    on<GetOnBoardNorwayNewsList>((event, emit) async {
      emit(OnBoardNewsLoading());
      final res = await getNewsListUseCase(event.url);
      return res.fold((l) => emit(OnBoardNewsFailure(l.msg)),(r) {
        onboard_norways.addAll(r);
        pageNum[1] = pageNum[1]++;
        emit(OnBoardNewsSuccess(onboard_norways));
      });
    });
    on<GetPoliticalNorwayNewsList>((event, emit) async {
      emit(PoliticalNewsLoading());
      final res = await getNewsListUseCase(event.url);
      return res.fold((l) => emit(PoliticalNewsFailure(l.msg)),(r) {
        political_norways.addAll(r);
        pageNum[2]=pageNum[2]++;
        emit(PoliticalNewsSuccess(political_norways));
      });
    });

    on<GetLocalNorwayNewsList>((event, emit) async {
      emit(LocalNewsLoading());
      final res = await getNewsListUseCase(event.url);
      return res.fold((l) => emit(LocalNewsFailure(l.msg)),(r) {
        local_norways.addAll(r);
        pageNum[3]=pageNum[3]++;
        emit(LocalNewsSuccess(local_norways));
      });
    });

    on<GetSportNorwayNewsList>((event, emit) async {
      emit(SportNewsLoading());
      final res = await getNewsListUseCase(event.url);
      return res.fold((l) => emit(SportNewsFailure(l.msg)),(r) {
        sport_norways.addAll(r);
        pageNum[4]=pageNum[4]++;
        emit(SportNewsSuccess(sport_norways));
      });
    });
  }
}
