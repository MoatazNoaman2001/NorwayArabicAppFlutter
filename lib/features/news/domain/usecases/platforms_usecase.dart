import 'package:fpdart/fpdart.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import 'package:norway_flutter_app/features/news/data/models/web_pairs.dart';
import '../repo/news_repo.dart';

class PlatformListUseCase{
  final NewsRepository newsRepository;
  PlatformListUseCase(this.newsRepository);

  Future<Either<Failure , List<WebPair>>> call() async{
    return await newsRepository.platforms();
  }
}