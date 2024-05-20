import 'package:fpdart/fpdart.dart';
import 'package:norway_flutter_app/features/news/data/models/web_pairs.dart';
import 'package:norway_flutter_app/features/news/domain/repo/news_repo.dart';

class AppPageUseCase{
  final NewsRepository repo;
  AppPageUseCase(this.repo);


  Future<Either<String , List<WebPair>>> call(String url) async{
    return repo.appPage(url);
  }
}