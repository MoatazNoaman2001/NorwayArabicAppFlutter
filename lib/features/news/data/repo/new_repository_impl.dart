import 'package:fpdart/src/either.dart';

import 'package:norway_flutter_app/core/error/Failure.dart';

import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import 'package:norway_flutter_app/features/news/data/models/web_pairs.dart';
import 'package:norway_flutter_app/features/news/data/news_parser/news_parser_impl.dart';

import '../../domain/repo/news_repo.dart';
import '../models/tiktok.dart';
import '../news_parser/news_parser.dart';

class NewsRepositoryImpl implements NewsRepository{
  final NorwaySiteParser parser;
  NewsRepositoryImpl(this.parser);

  @override
  Future<Either<Failure, List<NorwayNew>>> getNewsList(String url
      ) async {
    try{
      var res = await parser.getNewsList(url);
      return right(res);
    } catch(e){
      print('error in call parser: ' + e.toString());
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NorwayNew>>> getNewsBanar() async{
    try{
      return right(await parser.banarNews());
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NorwayNew>> getNewsDetails(String url) async{
    try{
      return right(await parser.getNewDetails(url));
    }catch(e){
      print('error in call: ' + e.toString());
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WebPair>>> platforms() async{
    try{
      return right(await parser.platforms());
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WebPair>>> aboutUs() async{
    try{
      return right(await parser.aboutUs());
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WebPair>>> contactUs() async{
    try{
      return right(await parser.contactUs());
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TiktokVid>> getTiktokEmbed(String url) async{
    try{
      return right(await parser.getTiktokEmbed(url));
    }catch (e){
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<String, List<WebPair>>> appPage(String url) async{
    try{
      return right(await parser.appPage(url));
    }catch(e){
      return left(e.toString());
    }
  }

}