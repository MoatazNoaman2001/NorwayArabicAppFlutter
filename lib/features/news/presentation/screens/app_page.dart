import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/platforms/platform_bloc.dart';
import 'package:norway_flutter_app/features/news/presentation/widgets/app_page_failure.dart';
import 'package:norway_flutter_app/features/news/presentation/widgets/app_page_loading.dart';
import 'package:norway_flutter_app/features/news/presentation/widgets/app_page_success.dart';

class AppPageScreen extends StatefulWidget {
  const AppPageScreen({super.key});

  @override
  State<AppPageScreen> createState() => _AppPageScreenState();
}

class _AppPageScreenState extends State<AppPageScreen> {
  late ScaffoldMessengerState snackbar;

  @override
  void initState() {
    super.initState();
    context.read<PlatformBloc>().add(GetAppPageList());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    snackbar = ScaffoldMessenger.of(context);
  }
  @override
  void dispose() {
    super.dispose();
    snackbar.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var platform_bloc = BlocProvider.of<PlatformBloc>(context);
    return Container(
      height: Get.height,
      width: Get.width,
      child: BlocConsumer<PlatformBloc, PlatformState>(
        listener: (context, state) {
          print('state : ${state.toString()} , app_page_content: ' + platform_bloc.appPageContent.join(', '));
          if (state is AppPageFailure){
            snackbar.showSnackBar(SnackBar(
              content: Text('Error loading data'),
              duration: Duration(hours: 1),
              action: SnackBarAction(
                label: 'retry',
                onPressed: () {
                  context.read<PlatformBloc>().add(GetAppPageList());
                  snackbar.dispose();
                },
              ),
            ));
            // Get.snackbar('error', 'error in loading, seems network issues', onTap: (snack) {
            //
            // },).show();
          }
        },
        builder: (context, state) {
          if (state is AppPageSuccess || platform_bloc.appPageContent.isNotEmpty)
            return AppPageSuccessScreen(plts: platform_bloc.appPageContent,);
          else if(state is AppPageFailure){
            return AppPageFailureScreen(error_msg: state.msg);
          }else if (state is AppPageLoading){
            return AppPageLoadingScreen();
          }else
            return SizedBox.shrink();
        },
      ),
    );
  }
}
