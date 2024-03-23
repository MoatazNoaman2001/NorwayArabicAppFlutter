import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:data_store/data_store_repository.dart';
import 'package:fpdart/fpdart.dart';

class LocalDataStore implements DataStore{
  final _storage = const FlutterSecureStorage();
  final lang_key = "LanguageCode";
  final theme_key = "isNight";

  @override
  Future<Either<String , String>> get lang async{
    try{
      final all = await _storage.readAll(aOptions: _getAndroidOptions());
      final selected = all.entries.where((element) => element.key == lang_key);
      if(selected.isEmpty){
        return Either.right('');
      }
      return Either.right(selected.first.value);
    }catch(e){
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

  // IOSOptions _getIOSOptions() => IOSOptions(
  //   accountName: _getAccountName(),
  // );
  // String? _getAccountName() =>
  //     _accountNameController.text.isEmpty ? null : _accountNameController.text;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
    // sharedPreferencesName: 'Test2',
    // preferencesKeyPrefix: 'Test'
  );

  @override
  Future<Either<String, String>> get nightTheme async{
    try{
      final all = await _storage.readAll(aOptions: _getAndroidOptions());
      final selected = all.entries.where((element) => element.key == theme_key);
      if(selected.isEmpty){
        return Either.right('');
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
}