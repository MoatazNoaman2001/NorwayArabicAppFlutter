

import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType , Params>{
  Future<Either <String , SuccessType>> call(Params params);
}