import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/platforms/platform_bloc.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/platforms/platform_bloc.dart';
import 'package:norway_flutter_app/features/news/presentation/widgets/about_us_success.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';

import '../widgets/about_us_loading.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlatformBloc>().add(GetAboutUSList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.AboutUs.tr()),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: BlocConsumer<PlatformBloc, PlatformState>(
          listener: (context, state) {
            var bloc = BlocProvider.of<PlatformBloc>(context);
            if (state is AboutUsLoading) {
              print("loading about us");
            } else if (state is AboutUSSuccess) {
              print("success about us : ${bloc.aboutUs.join('\n')}");
            }
          },
          builder: (context, state) {
            var bloc = BlocProvider.of<PlatformBloc>(context);

            if (state is AboutUsLoading && bloc.aboutUs.isEmpty)
              return AboutUsLoadingWidget();
            else if (state is AboutUSSuccess) {
              return AboutUsSuccessWidget(pairs: bloc.aboutUs);
            } else if (state is AboutUsLoading && bloc.aboutUs.isNotEmpty) {
              return AboutUsSuccessWidget(pairs: bloc.aboutUs);
            }else if (state is AboutUSFailure && bloc.aboutUs.isNotEmpty) {
              return AboutUsSuccessWidget(pairs: bloc.aboutUs);
            }  else if (state is AboutUSFailure && bloc.aboutUs.isEmpty) {
              return AboutUsLoadingWidget();
            }else{
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
