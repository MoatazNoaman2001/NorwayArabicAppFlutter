import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:norway_flutter_app/features/app_controller/domain/Get_theme_use_case.dart';
import 'package:norway_flutter_app/features/app_controller/domain/change_theme_use_case.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/platforms/platform_bloc.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/platfroms_scr.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/screens/setting.dart';
import 'package:norway_flutter_app/features/streams/data/repo/youtube_repo_impl.dart';
import 'package:norway_flutter_app/features/streams/data/youtube_parser_impl.dart';
import 'package:norway_flutter_app/features/streams/presenation/bloc/youtube_stream_bloc.dart';
import 'package:norway_flutter_app/features/streams/presenation/screens/select_stream_type.dart';
import 'package:norway_flutter_app/translations/codegen_loader.g.dart';
import 'package:norway_flutter_app/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:norway_flutter_app/features/app_controller/domain/Get_lang_use_case.dart';
import 'package:norway_flutter_app/features/app_controller/domain/change_lang_use_case.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/bloc/controller_bloc.dart';
import 'package:norway_flutter_app/features/news/data/news_parser_impl.dart';
import 'package:norway_flutter_app/features/news/data/repo/new_repository_impl.dart';
import 'package:norway_flutter_app/features/news/domain/usecases/get_news_details.dart';
import 'package:norway_flutter_app/features/news/domain/usecases/get_news_list.dart';
import 'package:norway_flutter_app/features/news/domain/usecases/get_swiper_news_list.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/details/details_bloc.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/general/general_news_bloc.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/general_news.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/local_news.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/new_details.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/onboard.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/political_news.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/sport_news.dart';
import 'core/constants.dart';
import 'package:data_store/data_store_repository.dart';
import 'core/theme/color_schemes.g.dart';
import 'features/app_controller/presentation/screens/init_app.dart';
import 'features/app_controller/presentation/screens/select_language.dart';
import 'features/news/domain/usecases/platforms_usecase.dart';
import 'features/streams/presenation/screens/audio_stream_screen.dart';
import 'features/streams/presenation/screens/video_stream_screen.dart';
import 'core/streams/audio_hadler.dart';

// MyAudioHandler audioHandler = MyAudioHandler();
void main() async {
  // HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        //./.
        create: (context) => ControllerBloc(
          changeLanguageUseCase: ChangeLanguageUseCase(LocalDataStore()),
          getLanguageUseCase: GetLanguageUseCase(LocalDataStore()),
          getThemeUseCase: GetThemeUseCase(LocalDataStore()),
          changeThemeUseCase: ChangeThemeUseCase(LocalDataStore()),
        ),
      ),
      BlocProvider(
        create: (context) => NewsBloc(
            getNewsListUseCase:
                GetNewsListUseCase(NewsRepositoryImpl(NewsParserImpl())),
            getSwiperNewsListUseCase:
                GetSwiperNewsListUseCase(NewsRepositoryImpl(NewsParserImpl()))),
      ),
      BlocProvider(
        create: (context) => DetailsBloc(
            getNewsDetailsUseCase:
                GetNewsDetailsUseCase(NewsRepositoryImpl(NewsParserImpl()))),
      ),
      BlocProvider(
        create: (context) => PlatformBloc(
            platformListUseCase:
                PlatformListUseCase(NewsRepositoryImpl(NewsParserImpl()))),
      ),
      BlocProvider(
        create: (context) => YoutubeStreamBloc(
            youtubeRepoImpl: YoutubeRepoImpl(YoutubeParserImpl())),
      )
    ],
    child: MyApp(),
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    context.read<ControllerBloc>().add(ThemeGet());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ControllerBloc, ControllerState>(
      listener: (context, state) {
        if (state is ThemeGetSuccess) {
          setState(() {
            if (state.theme != "0") {
              _themeMode = ThemeMode.dark;
            } else {
              _themeMode = ThemeMode.light;
            }
          });
        } else if (state is ThemeSetSuccess) {
          setState(() {
            var bloc = BlocProvider.of<ControllerBloc>(context);
            if (bloc.theme != false) {
              _themeMode = ThemeMode.dark;
            } else {
              _themeMode = ThemeMode.light;
            }
          });
        }
      },
      builder: (context, state) {
        return EasyLocalization(
            supportedLocales: [Locale('en'), Locale('ar'), Locale('no')],
            path: 'assets/translations',
            assetLoader: CodegenLoader(),
            fallbackLocale: state is LangGetSuccess? Locale(state.lang)  :Locale('en'),
            child: MyAppMainEntry(thememode: _themeMode,));
      },
    );
  }
}

class MyAppMainEntry extends StatelessWidget {
  final ThemeMode thememode;
  const MyAppMainEntry({super.key , required this.thememode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme:
      ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: thememode,
      initialRoute: '/',
      routes: {
        '/': (context) => InitiateApp(),
        '/select_language': (context) => SelectLanguage(),
        '/home': (context) =>
        const MyHomePage(),
        '/political': (context) =>
            PoliticalNews(url: Constants.newsUrls[2]),
        '/local': (context) => LocalNews(url: Constants.newsUrls[3]),
        '/sport': (context) => SportNews(url: Constants.newsUrls[4]),
        '/details': (context) => const NewDetails(),
        '/platform': (context) => PlatformScreen(),
        '/setting': (context) => SettingScreen(),
        '/select_stream': (context) => SelectStreamType(),
        '/audio_stream': (context) => AudioStreamScreen(),
        '/video_stream': (context) => VideoStreamScreen(),
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  //
  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPageIndex = 0;
  int drawerSelect = -1;
  final screens = [
    GeneralNews(url: Constants.newsUrls[0]),
    OnBoard(url: Constants.newsUrls[1]),
  ];

  void _navigateToSelectStream() {
    Navigator.of(context).pushNamed('/select_stream');
  }

  @override
  Widget build(BuildContext context) {
    Color fabBackColor;
    if (Theme.of(context).brightness == Brightness.light)
      fabBackColor = lightColorScheme.onPrimaryContainer;
    else
      fabBackColor = darkColorScheme.onPrimaryContainer;

    String general = 'General'.tr();
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (int value) {
          setState(() {
            // context.read<NewsBloc>().add(
            //     GetNorwayNewsList(Constants.generalNewsUrl[value], [])
            // );
            selectedPageIndex = value;
          });
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home_filled),
            icon: Icon(Icons.home_outlined),
            label: LocaleKeys.general.tr(),
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.article_rounded),
            icon: Icon(Icons.article_outlined),
            label: LocaleKeys.onBoard.tr(),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(LocaleKeys.title.tr()),
        centerTitle: true,
        elevation: 4,
      ),
      drawer: NavigationDrawer(
        selectedIndex: drawerSelect,
        onDestinationSelected: (value) {
          switch (value) {
            case 0:
              Navigator.of(context).pushNamed('/political');
              break;
            case 1:
              Navigator.of(context).pushNamed('/local');
              break;
            case 2:
              Navigator.of(context).pushNamed('/sport');
              break;
            case 3:
              _launchUrl(Uri.parse(
                  "https://www.youtube.com/playlist?list=PLehaaLsoPPRinl-P5ibncWU3TbrHwjPzP"));
              break;
            case 4:
              _launchUrl(Uri.parse("https://soundcloud.com/norwayvoice"));
              break;
            case 5:
              Navigator.of(context).pushNamed('/platform');
              break;
            case 6:
              Navigator.of(context).pushNamed('/setting');
              break;
          }
        },
        children: [
          ListTile(
            dense: true,
            title: Text(
              LocaleKeys.News.tr(),
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          NavigationDrawerDestination(
              icon: Icon(Icons.handshake_outlined),
              selectedIcon: Icon(Icons.handshake),
              label: Text(LocaleKeys.Political.tr())),
          NavigationDrawerDestination(
              icon: Icon(Icons.newspaper_outlined),
              selectedIcon: Icon(Icons.newspaper),
              label: Text(LocaleKeys.Local.tr())),
          NavigationDrawerDestination(
              icon: Icon(Icons.sports_football_outlined),
              selectedIcon: Icon(Icons.sports_football),
              label: Text(LocaleKeys.Sport.tr())),
          Divider(),
          ListTile(
            dense: true,
            title: Text(
              LocaleKeys.Platforms.tr(),
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          NavigationDrawerDestination(
              icon: Image.asset(
                'assets/images/youtube_outline.png',
                height: 24,
                width: 24,
                color: Colors.grey,
              ),
              label: Text(LocaleKeys.Youtube.tr())),
          NavigationDrawerDestination(
              icon: Image.asset(
                'assets/images/snapchat.png',
                height: 24,
                width: 24,
                color: Colors.grey,
              ),
              label: Text(LocaleKeys.SnapChat.tr())),
          NavigationDrawerDestination(
              icon: Image.asset(
                'assets/images/cross-platform.png',
                height: 24,
                width: 24,
                color: Colors.grey,
              ),
              label: Text(LocaleKeys.Platforms.tr())),
          Divider(),
          SizedBox(
            height: 270,
          ),
          NavigationDrawerDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: Text(LocaleKeys.Settings.tr())),
        ],
      ),
      body: screens[selectedPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToSelectStream,
        backgroundColor: fabBackColor,
        tooltip: 'Increment',
        child: Container(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            'assets/images/sime_logo.png',
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}

class ConnectivityController {
  ValueNotifier<bool> isConnected = ValueNotifier(false);

  Future<void> init() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    isInternetConnected(result);
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isInternetConnected(result);
    });
  }

  bool isInternetConnected(ConnectivityResult? result) {
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      isConnected.value = true;
      return true;
    }
    return false;
  }
}
