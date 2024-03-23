import 'package:fpdart/fpdart.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import '../repo/news_repo.dart';

class GetNewsDetailsUseCase{
  final NewsRepository newsRepository;
  GetNewsDetailsUseCase(this.newsRepository);

  Future<Either<Failure , NorwayNew>> call(String url) {
    return newsRepository.getNewsDetails(url);
  }
}