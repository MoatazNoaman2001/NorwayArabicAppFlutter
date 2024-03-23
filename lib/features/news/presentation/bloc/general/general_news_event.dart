part of 'general_news_bloc.dart';

@immutable
sealed class NewsEvent {}


class GetNorwayNewsList extends NewsEvent{
  final String url;
  final List<NorwayNew> norways;

  GetNorwayNewsList(this.url, this.norways);
}

class GetSwiperNorwayNewsList extends NewsEvent{
}

class GetGeneralNorwayNewsList extends GetNorwayNewsList{
  GetGeneralNorwayNewsList(super.url, super.norways);
}

class GetOnBoardNorwayNewsList  extends GetNorwayNewsList{
  GetOnBoardNorwayNewsList(super.url, super.norways);
}

class GetPoliticalNorwayNewsList  extends GetNorwayNewsList{
  GetPoliticalNorwayNewsList(super.url, super.norways);
}

class GetLocalNorwayNewsList  extends GetNorwayNewsList{
  GetLocalNorwayNewsList(super.url, super.norways);
}
class GetSportNorwayNewsList  extends GetNorwayNewsList{
  GetSportNorwayNewsList(super.url, super.norways);
}