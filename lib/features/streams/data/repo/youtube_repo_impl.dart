import 'package:fpdart/src/either.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/features/streams/data/youtube_parser.dart';
import 'package:norway_flutter_app/features/streams/domain/repo/youtube_repo.dart';

class YoutubeRepoImpl implements YoutubeRepo{
  final YoutubeParser youtubeParser;

  YoutubeRepoImpl(this.youtubeParser);

  @override
  Future<Either<Failure, String>> get youtubelink async {
    try{
      return right(await youtubeParser.LiveStreamLink);
    }catch (e){
      return left(Failure(e.toString()));
    }
  }

}