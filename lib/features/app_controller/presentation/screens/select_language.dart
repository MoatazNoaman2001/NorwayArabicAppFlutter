import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/bloc/controller_bloc.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: BlocConsumer<ControllerBloc, ControllerState>(
        listener: (context, state) {
          if (state is LangSetSuccess) {
            Navigator.of(context).popAndPushNamed('/home');
          } else if (state is LangFailure) {
            Constants.makeToast('failed to save language! : ${state.msg}');
          }
        },
        builder: (context, state) {
          return Center(
              child: Column(
            children: [
              Spacer(),
              Image.asset(
                "assets/images/simple_logo.png",
                width: 260,
                height: 300,
              ),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        context
                            .read<ControllerBloc>()
                            .add(LanguageChange('no'));
                      },
                      child: Text('Norsk')),
                  const SizedBox(
                    width: 4,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context
                            .read<ControllerBloc>()
                            .add(LanguageChange('ar'));
                      },
                      child: Text('العربية')),
                  const SizedBox(
                    width: 4,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context
                            .read<ControllerBloc>()
                            .add(LanguageChange('en'));
                      },
                      child: Text('English')),
                  Spacer(),
                ],
              ),
              Spacer()
            ],
          ));
        },
      ),
    ));
  }
}
