import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_fonts/google_fonts.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/bloc/controller_bloc.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';

import '../../../../main.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();

  static State<SettingScreen> of(BuildContext context) =>
      context.findAncestorStateOfType<State<SettingScreen>>()!;
}

class _SettingScreenState extends State<SettingScreen> {
  String lang = '';

  @override
  void initState() {
    super.initState();
    context.read<ControllerBloc>().add(ThemeGet());
    context.read<ControllerBloc>().add(LanguageGet());
    context.read<ControllerBloc>().add(CouldPlayInBackGround());
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ControllerBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Settings.tr(context: context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(right: 8, left: 8, bottom: 540),
          child: Card(
            child: Column(
              children: [
                BlocConsumer<ControllerBloc, ControllerState>(
                  listener: (context, state) {
                    print('event tracked');
                  },
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.only(right: 22, left: 22, top: 8),
                      child: Row(
                        children: [
                          Text(LocaleKeys.NightMode.tr()),
                          Spacer(),
                          Switch(
                            value: bloc.theme,
                            onChanged: (value) {
                              setState(() {
                                bloc.theme = !bloc.theme;
                                context
                                    .read<ControllerBloc>()
                                    .add(ThemeChange(!bloc.theme ? "0" : "1"));
                                MyApp.of(context).changeTheme(bloc.theme? ThemeMode.dark : ThemeMode.light);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                BlocConsumer<ControllerBloc, ControllerState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 22, left: 22, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Text(LocaleKeys.Play_In_Background.tr()),
                          Spacer(),
                          Switch(
                            value: bloc.background,
                            onChanged: (value) {
                              setState(() {
                                bloc.background = !bloc.background;
                                context.read<ControllerBloc>().add(
                                  ChangePlayInBackground(bloc.background)
                                );

                              });
                              Constants.getInstanceOfRadioPlayer().stop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                BlocConsumer<ControllerBloc, ControllerState>(
                  listener: (context, state) async {
                    if (state is LangGetSuccess) {
                      setState(() {
                        lang = state.lang;
                      });
                    } else if (state is LangSetSuccess) {
                      setState(() {
                        final new_local = Locale(bloc.lang);
                        context.setLocale(new_local);
                        Get.updateLocale(new_local);
                      });
                      // final engine = WidgetsFlutterBinding.ensureInitialized();
                      // await engine.performReassemble();
                      // await EasyLocalization.ensureInitialized();
                    } else if (state is LangFailure) {
                      Constants.makeToast("Failed !: ${state.msg}");
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                        padding: const EdgeInsets.only(
                            right: 22, left: 22, top: 10, bottom: 10),
                        child: DropdownMenu<String>(
                          dropdownMenuEntries: [
                            DropdownMenuEntry<String>(
                                value: 'ar', label: 'العربية'),
                            DropdownMenuEntry<String>(
                                value: 'en', label: 'English'),
                            DropdownMenuEntry<String>(
                                value: 'no', label: 'Nersik')
                          ],
                          width: MediaQuery.of(context).size.width -
                              MediaQuery.of(context).size.width * 0.19,
                          label: Text(
                            LocaleKeys.Language.tr(),
                            style: GoogleFonts.rubik(),
                          ),
                          initialSelection: lang,
                          inputDecorationTheme: InputDecorationTheme(
                            hintFadeDuration: Durations.extralong4,
                            hintStyle: GoogleFonts.rubik(),
                            labelStyle: GoogleFonts.rubik(),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14)),
                            filled: true,
                          ),
                          onSelected: (value) {
                            // Constants.makeToast('value is $value');
                            context
                                .read<ControllerBloc>()
                                .add(LanguageChange(value!));
                            // widget.engine.
                          },
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
