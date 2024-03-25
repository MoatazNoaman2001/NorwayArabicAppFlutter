import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/bloc/controller_bloc.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الاعدادات'),
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
                    var bloc = BlocProvider.of<ControllerBloc>(context);
                    // Constants.makeToast(bloc.theme.toString());
                    if (state is ThemeGetSuccess) {
                      Constants.makeToast(state.theme);
                    } else if (state is ThemeSetSuccess) {
                      Constants.makeToast('theme is set successfully');
                    } else if (state is ThemeFailure) {
                      Constants.makeToast('failed');
                    }
                  },
                  builder: (context, state) {
                    var bloc = BlocProvider.of<ControllerBloc>(context);
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
                    var bloc = BlocProvider.of<ControllerBloc>(context);
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
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                BlocConsumer<ControllerBloc, ControllerState>(
                  listener: (context, state) {

                  },
                  builder: (context, state) {
                    return Padding(
                        padding: const EdgeInsets.only(
                            right: 22, left: 22, top: 10, bottom: 10),
                        child: DropdownMenu<String>(
                          dropdownMenuEntries: [
                            DropdownMenuEntry<String>(value: 'ar', label: 'العربية'),
                            DropdownMenuEntry<String>(value: 'en', label: 'English'),
                            DropdownMenuEntry<String>(value: 'no', label: 'Nersik')
                          ],
                          width: MediaQuery.of(context).size.width
                           - MediaQuery.of(context).size.width * 0.19,
                          label: Text(LocaleKeys.Language.tr() , style: GoogleFonts.rubik(),),
                          initialSelection: lang,
                          inputDecorationTheme: InputDecorationTheme(
                            hintFadeDuration: Durations.extralong4,
                            hintStyle: GoogleFonts.rubik(),
                            labelStyle: GoogleFonts.rubik(),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            filled: true,
                          ),
                          onSelected: (value) {
                            context.read<ControllerBloc>().add(
                              LanguageChange(value!)
                            );
                            context.setLocale(Locale(value));
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


