import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/repo/youtube_repo_impl.dart';

part 'youtube_stream_event.dart';
part 'youtube_stream_state.dart';

class YoutubeStreamBloc extends Bloc<YoutubeStreamEvent, YoutubeStreamState> {
  final YoutubeRepoImpl youtubeRepoImpl;
  YoutubeStreamBloc({required this.youtubeRepoImpl}) : super(YoutubeStreamInitial()) {
    on<GetYoutubeLink>((event, emit) async {
      emit(YoutubeStreamLoading());
      var res = await youtubeRepoImpl.youtubelink;
      return res.fold((l) => emit(YoutubeStreamFailure(l.msg)), (r) {
        emit(YoutubeStreamSuccess(r));
      });
    });
  }
}
