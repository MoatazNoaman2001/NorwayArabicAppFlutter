import 'package:fpdart/fpdart.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/features/news/data/models/web_pairs.dart';

import 'models/norway_new.dart';

abstract interface class NorwaySiteParser{

  Future<List<NorwayNew>> getNewsList(String url);
  Future<NorwayNew> getNewDetails(String url);
  Future<List<NorwayNew>> banarNews();
  Future<List<WebPair>> platforms();
  Future<List<WebPair>> aboutUs();
}