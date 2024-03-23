

import 'package:fpdart/src/either.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/core/useCases/usecase.dart';
import 'package:data_store/data_store_repository.dart';

class GetThemeUseCase{
  final DataStore dataStore;

  GetThemeUseCase(this.dataStore);

  Future<Either<String, String>> call() async{
    return await dataStore.nightTheme;
  }
}