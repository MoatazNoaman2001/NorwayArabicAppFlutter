import 'package:fpdart/fpdart.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import 'package:norway_flutter_app/features/news/data/models/tiktok.dart';
import 'package:norway_flutter_app/features/news/data/models/web_pairs.dart';
import '../repo/news_repo.dart';

class GetTiktokEmbedUseCase{
  final NewsRepository newsRepository;
  GetTiktokEmbedUseCase(this.newsRepository);

  Future<Either<Failure,  TiktokVid>> call(String url) async{
    return await newsRepository.getTiktokEmbed(url);
  }
}