import 'package:fpdart/fpdart.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import '../repo/news_repo.dart';

class GetNewsListUseCase{
  final NewsRepository newsRepository;
  GetNewsListUseCase(this.newsRepository);

  Future<Either<Failure , List<NorwayNew>>> call(String url) async{
    return await newsRepository.getNewsList(url);
  }
}