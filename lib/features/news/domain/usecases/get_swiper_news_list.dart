import 'package:fpdart/fpdart.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import '../repo/news_repo.dart';

class GetSwiperNewsListUseCase{
  final NewsRepository newsRepository;
  GetSwiperNewsListUseCase(this.newsRepository);

  Future<Either<Failure , List<NorwayNew>>> call() {
    return newsRepository.getNewsBanar();
  }
}