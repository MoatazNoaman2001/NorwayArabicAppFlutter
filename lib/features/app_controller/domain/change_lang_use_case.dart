

import 'package:fpdart/src/either.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/core/useCases/usecase.dart';
import 'package:data_store/data_store_repository.dart';

class ChangeLanguageUseCase implements UseCase<bool , String>{
  final DataStore dataStore;

  ChangeLanguageUseCase(this.dataStore);

  @override
  Future<Either<String, bool>> call(String lang) async{
    return await dataStore.updateLang(lang);
  }


}