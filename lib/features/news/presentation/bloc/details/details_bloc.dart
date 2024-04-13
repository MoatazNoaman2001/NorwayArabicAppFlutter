import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/data/models/tiktok.dart';
import 'package:norway_flutter_app/features/news/domain/usecases/get_news_details.dart';

import '../../../data/models/norway_new.dart';
import '../../../domain/usecases/get_tiktok_embed.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final GetNewsDetailsUseCase getNewsDetailsUseCase;
  final GetTiktokEmbedUseCase getTiktokEmbedUseCase;
  NorwayNew? norwayNew;
  TiktokVid? tiktokVid;
  DetailsBloc({required this.getNewsDetailsUseCase, required this.getTiktokEmbedUseCase}) : super(DetailsInitial()) {
    on<GetNewDetails>((event, emit) async {
      emit(DetailsLoading());
      final res = await getNewsDetailsUseCase(event.url);
      return res.fold((l) => emit(DetailsFailure(l.msg)), (r) {
        norwayNew = r;
        emit(DetailsSuccess(r));
      });
    });

    on<GetTiktokEmbed>((event, emit) async{
      emit(GetTiktokEmbedLoading());
      var res = await getTiktokEmbedUseCase(event.url);
      return res.fold((l) => emit(GetTiktokEmbedFailure(l.msg)), (r) {
        tiktokVid= r;
        emit(GetTiktokEmbedSuccess(r));
      });
    },);
  }
}
