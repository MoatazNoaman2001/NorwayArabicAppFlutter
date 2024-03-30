import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../data/models/norway_new.dart';
import '../../data/models/web_pairs.dart';

abstract interface class NewsRepository{
  Future<Either<Failure , List<NorwayNew>>> getNewsList(String url);
  Future<Either<Failure , NorwayNew>> getNewsDetails(String url);
  Future<Either<Failure , List<NorwayNew>>> getNewsBanar();
  Future<Either<Failure , List<WebPair>>> platforms();
  Future<Either<Failure, List<WebPair>>> aboutUs();
}