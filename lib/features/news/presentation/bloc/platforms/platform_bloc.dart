import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/constants.dart';
import '../../../data/models/web_pairs.dart';
import '../../../domain/usecases/platforms_usecase.dart';

part 'platform_event.dart';
part 'platform_state.dart';

class PlatformBloc extends Bloc<PlatformEvent, PlatformState> {
  final PlatformListUseCase platformListUseCase;
  List<WebPair> platforms = [];
  PlatformBloc({required this.platformListUseCase}) : super(PlatformInitial()) {
    on<GetPlatFromList>((event, emit) async{
      emit(PlatformLoading());
      var res = await platformListUseCase();
      return res.fold((l) => emit(PlatformFailure(l.msg)), (r) {
        platforms = r;
        emit(PlatformSuccess());
      });
    },);
  }
}
