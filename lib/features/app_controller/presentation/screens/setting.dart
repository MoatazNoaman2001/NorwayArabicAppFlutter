import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/bloc/controller_bloc.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/bloc/controller_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();

  static State<SettingScreen> of(BuildContext context) =>
      context.findAncestorStateOfType<State<SettingScreen>>()!;
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ControllerBloc>().add(ThemeGet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الاعدادات'),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        padding: EdgeInsets.only(right: 8, left: 8),
        child: BlocConsumer<ControllerBloc, ControllerState>(
          listener: (context, state) {
            var bloc = BlocProvider.of<ControllerBloc>(context);
            Constants.makeToast(bloc.theme.toString());
            if (state is ThemeGetSuccess) {
              // Constants.makeToast(state.theme);
            } else if (state is ThemeSetSuccess) {
              Constants.makeToast(state.state.toString());
            }
          },
          builder: (context, state) {
            var bloc = BlocProvider.of<ControllerBloc>(context);
            return Card(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 16, left: 16, top: 4),
                    child: Row(
                      children: [
                        Text('Night Mode'),
                        Spacer(),
                        Switch(
                          value: bloc.theme,
                          onChanged: (value) {
                            Theme.of(context).brightness == Brightness.dark;
                            setState(() {
                              bloc.theme = !bloc.theme;
                            });
                            context
                                .read<ControllerBloc>()
                                .add(ThemeChange(value == false ? "0" : "1"));
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
