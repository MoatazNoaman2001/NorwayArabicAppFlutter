import 'package:fpdart/fpdart.dart';


abstract class DataStore{
  Future<Either<String , String>>get lang;
  Future<Either<String , bool>> updateLang(String lang);

  Future<Either<String , String>>get nightTheme;
  Future<Either<String , bool>> updateTheme(String theme);


  Future<Either<String , String>>get playInBackGround;
  Future<Either<String , bool>> updatePlayInBackGround(String value);
}