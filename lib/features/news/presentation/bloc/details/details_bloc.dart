import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/domain/usecases/get_news_details.dart';

import '../../../data/models/norway_new.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final GetNewsDetailsUseCase getNewsDetailsUseCase;
  DetailsBloc({required this.getNewsDetailsUseCase}) : super(DetailsInitial()) {
    on<GetNewDetails>((event, emit) async {
      emit(DetailsLoading());
      final res = await getNewsDetailsUseCase(event.url);
      return res.fold((l) => emit(DetailsFailure(l.msg)), (r) {
        emit(DetailsSuccess(r));
      });
    });
  }
}
