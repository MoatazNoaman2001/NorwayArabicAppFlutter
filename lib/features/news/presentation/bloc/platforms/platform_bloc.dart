import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:norway_flutter_app/features/news/domain/usecases/app_page_usecase.dart';

import '../../../../../core/constants.dart';
import '../../../data/models/web_pairs.dart';
import '../../../domain/usecases/aboutus_usecase.dart';
import '../../../domain/usecases/get_contact_us.dart';
import '../../../domain/usecases/platforms_usecase.dart';

part 'platform_event.dart';

part 'platform_state.dart';

class PlatformBloc extends Bloc<PlatformEvent, PlatformState> {
  final PlatformListUseCase platformListUseCase;
  final AboutUsListUseCase aboutUsListUseCase;
  final ContactUsUseCase contactUsUseCase;
  final AppPageUseCase appPageUseCase;
  List<WebPair> platforms = [];
  List<WebPair> aboutUs = [];
  List<WebPair> appPageContent = [];

  PlatformBloc(
      {required this.platformListUseCase,
      required this.aboutUsListUseCase,
      required this.contactUsUseCase,
      required this.appPageUseCase})
      : super(PlatformInitial()) {
    on<GetPlatFromList>(
      (event, emit) async {
        emit(PlatformLoading());
        var res = await platformListUseCase();
        return res.fold((l) => emit(PlatformFailure(l.msg)), (r) {
          platforms = r;
          emit(PlatformSuccess());
        });
      },
    );

    on<GetAboutUSList>(
      (event, emit) async {
        emit(AboutUsLoading());
        var res = await aboutUsListUseCase();
        return res.fold((l) => emit(AboutUSFailure(l.msg)), (r) {
          aboutUs = r;
          emit(AboutUSSuccess());
        });
      },
    );

    on<ContactUSList>(
      (event, emit) async {
        emit(ContactUSLoading());
        var res = await contactUsUseCase();
        return res.fold((l) => emit(ContactUSFailure(l.msg)),
            (r) => emit(ContactUSSuccess(r)));
      },
    );

    on<GetAppPageList>((event, emit) async {
      emit(AppPageLoading());
      var res = await appPageUseCase('https://norwayvoice.no/app/');
      return res.fold((l) => emit(AppPageFailure(l)), (r) {
        appPageContent = r;
        emit(AppPageSuccess());
      });
    });
  }
}
