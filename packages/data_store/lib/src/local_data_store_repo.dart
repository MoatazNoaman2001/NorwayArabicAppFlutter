import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:data_store/data_store_repository.dart';
import 'package:fpdart/fpdart.dart';

class LocalDataStore implements DataStore{
  final _storage = const FlutterSecureStorage();
  final lang_key = "LanguageCode";
  final theme_key = "isNight";
  final play_in_background = "PlayInBackGround";

  @override
  Future<Either<String , String>> get lang async{
    try{
      final selected = await _storage.read(key: lang_key);
      if(selected == null || selected.isEmpty){
        return Either.right('');
      }
      return Either.right(selected);
    }catch(e){
      if (kDebugMode) {
        print('exception of loading language : ${e.toString()}');
      }
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String , bool>> updateLang(String lang) async {
    try{
      await _storage.write(key: lang_key, value: lang);
      return Either.right(true);
    }catch(e){
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> get nightTheme async{
    try{
      final all = await _storage.readAll();
      final selected = all.entries.where((element) => element.key == theme_key);
      if(selected.isEmpty){
        return Either.right('0');
      }
      return Either.right(selected.first.value);
    }catch(e){
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> updateTheme(String lang) async {
    try {
      await _storage.write(key: theme_key, value: lang);
      return Either.right(true);
    } catch (e) {
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> get playInBackGround async{
    try{
      final all = await _storage.readAll();
      final selected = all.entries.where((element) => element.key == play_in_background);
      if(selected.isEmpty){
        return Either.right('1');
      }
      return Either.right(selected.first.value);
    }catch(e){
      return Either.left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> updatePlayInBackGround(String value) async{
    try{
      await _storage.write(key: play_in_background, value: value);
      return right(true);
    }catch(e){
      return left(e.toString());
    }
  }
}