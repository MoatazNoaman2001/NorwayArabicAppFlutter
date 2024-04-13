import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:norway_flutter_app/core/constants.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/details/details_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TiktokContainer extends StatefulWidget {
  final String url;

  const TiktokContainer({super.key, required this.url});

  @override
  State<TiktokContainer> createState() => _TiktokContainerState();
}

class _TiktokContainerState extends State<TiktokContainer> {
  late WebViewController controller;
  bool isTV = false;

  @override
  void initState() {
    context.read<DetailsBloc>().add(
        GetTiktokEmbed(widget.url)
    );
    super.initState();
    isDeviceIsTv();
  }

  void isDeviceIsTv() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    isTV = androidInfo.systemFeatures.contains('android.software.leanback');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailsBloc, DetailsState>(
      listener: (context, state) {
        if (state is GetTiktokEmbedSuccess){

        }
      },
      builder: (context, state) {
        if(state is GetTiktokEmbedLoading){
          return Container(
            height: 380,
            width: 240,
            child: Shimmer.fromColors(child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ), baseColor: Colors.transparent, highlightColor: Colors.black12),
          );
        }else if (state is GetTiktokEmbedSuccess) {
          controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {
                Constants.makeToast('started');
              },
              onPageFinished: (String url) {
                Constants.makeToast('finished');
              },
              onWebResourceError: (WebResourceError error) {
                print('flutter webview error: ' + error.description);
              },
              onNavigationRequest: (request) {
                if (request.url.startsWith('https://www.tiktok.com/')) {
                  return NavigationDecision.navigate;
                }
                return NavigationDecision.prevent;
              },
            ))
            ..loadHtmlString(state.tiktokVid.html!);
          return Container(
              height: 300,
              width: 500,
              child: WebViewWidget(controller: controller));
        }else {
          var bloc = BlocProvider.of<DetailsBloc>(context);
          if (bloc.tiktokVid != null ){
            controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {
                  Constants.makeToast('started');
                },
                onPageFinished: (String url) {
                  Constants.makeToast('finished');
                },
                onWebResourceError: (WebResourceError error) {
                  print('flutter webview error: ' + error.toString());
                },
                onNavigationRequest: (request) {
                  if (request.url.startsWith('https://www.tiktok.com/')) {
                    return NavigationDecision.navigate;
                  }
                  return NavigationDecision.prevent;
                },
              ))
              ..loadHtmlString(bloc.tiktokVid!.html!);
            return Container(
                height: 300,
                width: 500,
                child: WebViewWidget(controller: controller));
          }else{
            return SizedBox.shrink();
          }
        }
      },
    );
  }
}
