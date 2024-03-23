

import 'package:fpdart/src/either.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/core/useCases/usecase.dart';
import 'package:data_store/data_store_repository.dart';

class ChangeThemeUseCase implements UseCase<bool , String>{
  final DataStore dataStore;

  ChangeThemeUseCase(this.dataStore);

  @override
  Future<Either<String, bool>> call(String themeMode) async{
    return await dataStore.updateTheme(themeMode);
  }


}