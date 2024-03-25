import 'package:fpdart/fpdart.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';

abstract interface class YoutubeRepo{
  Future<Either<Failure , String>> get youtubelink;
}