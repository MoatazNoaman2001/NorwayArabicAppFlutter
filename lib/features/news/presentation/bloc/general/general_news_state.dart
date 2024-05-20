part of 'general_news_bloc.dart';

@immutable
sealed class NewsState {}

final class NewsInitial extends NewsState {}
final class NewsLoading extends NewsState {}
final class SwiperNewsLoading extends NewsState {}
final class GeneralNewsLoading extends NewsState {}
final class ApplicationNewsLoading extends NewsState {}
final class OnBoardNewsLoading extends NewsState {}
final class PoliticalNewsLoading extends NewsState {}
final class LocalNewsLoading extends NewsState {}
final class SportNewsLoading extends NewsState {}
final class NewsListSuccess extends NewsState {
  final List<NorwayNew> norways;
  NewsListSuccess(this.norways);
}
final class NewsListFailure extends NewsState {
  final String msg;
  NewsListFailure(this.msg);
}
final class ApplicationNewListSuccess extends NewsState {
  final List<NorwayNew> norways;
  ApplicationNewListSuccess(this.norways);
}
final class ApplicationNewListFailure extends NewsState {
  final String msg;
  ApplicationNewListFailure(this.msg);
}

final class SwiperNewsSuccess extends NewsListSuccess{
  SwiperNewsSuccess(super.norways);
}
final class SwiperNewsFailure extends NewsListFailure{
  SwiperNewsFailure(super.msg);
}

final class GeneralNewsSuccess extends NewsListSuccess{
  GeneralNewsSuccess(super.norways);
}
final class GeneralNewsFailure extends NewsListFailure{
  GeneralNewsFailure(super.msg);
}

final class OnBoardNewsSuccess extends NewsListSuccess{
  OnBoardNewsSuccess(super.norways);
}
final class OnBoardNewsFailure extends NewsListFailure{
  OnBoardNewsFailure(super.msg);
}

final class PoliticalNewsSuccess extends NewsListSuccess{
  PoliticalNewsSuccess(super.norways);
}
final class PoliticalNewsFailure extends NewsListFailure{
  PoliticalNewsFailure(super.msg);
}

final class LocalNewsSuccess extends NewsListSuccess{
  LocalNewsSuccess(super.norways);
}
final class LocalNewsFailure extends NewsListFailure{
  LocalNewsFailure(super.msg);
}


final class SportNewsSuccess extends NewsListSuccess{
  SportNewsSuccess(super.norways);
}
final class SportNewsFailure extends NewsListFailure{
  SportNewsFailure(super.msg);
}


