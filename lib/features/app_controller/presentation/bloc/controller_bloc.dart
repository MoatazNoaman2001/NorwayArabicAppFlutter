import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/Get_lang_use_case.dart';
import '../../domain/Get_theme_use_case.dart';
import '../../domain/change_lang_use_case.dart';
import '../../domain/change_theme_use_case.dart';

part 'controller_event.dart';

part 'controller_state.dart';

class ControllerBloc extends Bloc<ControllerEvent, ControllerState> {
  final ChangeLanguageUseCase changeLanguageUseCase;
  final GetLanguageUseCase getLanguageUseCase;
  final GetThemeUseCase getThemeUseCase;
  final ChangeThemeUseCase changeThemeUseCase;

  bool theme = false;

  ControllerBloc(
      {required this.changeLanguageUseCase,
      required this.getLanguageUseCase,
      required this.changeThemeUseCase,
      required this.getThemeUseCase})
      : super(ControllerInitial()) {
    on<LanguageChange>((event, emit) async {
      final res = await changeLanguageUseCase(event.lang);
      return res.fold(
          (l) => emit(LangFailure(l)), (r) => emit(LangSetSuccess(r)));
    });

    on<LanguageGet>(
      (event, emit) async {
        final res = await getLanguageUseCase();
        return res.fold(
            (l) => emit(LangFailure(l)), (r) => emit(LangGetSuccess(r)));
      },
    );

    on<ThemeChange>((event, emit) async {
      theme = event.theme == "0"? false : true;
      final res = await changeThemeUseCase(event.theme);
      return res.fold(
              (l) => emit(ThemeFailure(l)), (r) => emit(ThemeSetSuccess(r)));
    });

    on<ThemeGet>((event, emit) async {
        final res = await getLanguageUseCase();
        return res.fold((l) => emit(ThemeFailure(l)), (r)
        {
          theme = r == "0"? false : true;
          emit(ThemeGetSuccess(r));
        });
      },
    );
  }
}
