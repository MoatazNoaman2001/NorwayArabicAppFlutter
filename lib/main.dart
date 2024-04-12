import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:norway_flutter_app/features/app_controller/domain/Get_play_in_background_use_case.dart';
import 'package:norway_flutter_app/features/app_controller/domain/Get_theme_use_case.dart';
import 'package:norway_flutter_app/features/app_controller/domain/change_play_in_background_use_case.dart';
import 'package:norway_flutter_app/features/app_controller/domain/change_theme_use_case.dart';
import 'package:norway_flutter_app/features/news/domain/usecases/get_contact_us.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/platforms/platform_bloc.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/about_us_screen.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/fb_videos_screen.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/platfroms_scr.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/screens/setting.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/youtube_list_screen.dart';
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
import 'features/news/domain/usecases/aboutus_usecase.dart';
import 'features/news/domain/usecases/platforms_usecase.dart';
import 'features/news/presentation/screens/contact_us.dart';
import 'features/streams/presenation/screens/audio_stream_screen.dart';
import 'features/streams/presenation/screens/video_stream_screen.dart';

Future<void> main() async {
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
          get_playInBackGroundUseCase:
              GetPlayInBackGroundUseCase(LocalDataStore()),
          changePlayInBackGroundUseCase:
              ChangePlayInBackGroundUseCase(LocalDataStore()),
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
                PlatformListUseCase(NewsRepositoryImpl(NewsParserImpl())),
            aboutUsListUseCase:
                AboutUsListUseCase(NewsRepositoryImpl(NewsParserImpl())),
          contactUsUseCase: ContactUsUseCase(NewsRepositoryImpl(NewsParserImpl()))

        ),
      ),
      BlocProvider(
        create: (context) => YoutubeStreamBloc(
            youtubeRepoImpl: YoutubeRepoImpl(YoutubeParserImpl())),
      )
    ],
    child: EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar'), Locale('no')],
        path: 'assets/translations',
        assetLoader: CodegenLoader(),
        fallbackLocale: Locale('ar'),
        startLocale: Locale('ar'),
        child: MyApp()),
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
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => InitiateApp(),
        '/select_language': (context) => SelectLanguage(),
        '/home': (context) => MyHomePage(),
        '/onBoard': (context) => OnBoard(url: Constants.newsUrls[1]),
        '/political': (context) => PoliticalNews(url: Constants.newsUrls[2]),
        '/local': (context) => LocalNews(url: Constants.newsUrls[3]),
        '/sport': (context) => SportNews(url: Constants.newsUrls[4]),
        '/youtube_list_screen' : (context) => YoutubeListScreen(selected: 0),
        '/contact_us' : (context) => ContactUSScreen(),
        '/fb_screen': (context) => FbVideosScreen(),
        '/aboutUs': (context) => AboutUsScreen(),
        '/details': (context) => NewDetails(),
        '/platform': (context) => PlatformScreen(),
        '/setting': (context) => SettingScreen(),
        '/select_stream': (context) => SelectStreamType(),
        '/audio_stream': (context) => AudioStreamScreen(),
        '/video_stream': (context) => VideoStreamScreen(),
      },
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
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
    SelectStreamType(),
    PlatformScreen()
  ];

  void _navigateToSelectStream() {
    Navigator.of(context).pushNamed('/select_stream');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color fabBackColor;
    if (Theme.of(context).brightness == Brightness.light)
      fabBackColor = lightColorScheme.onPrimaryContainer;
    else
      fabBackColor = darkColorScheme.onPrimaryContainer;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        animationDuration: Duration(milliseconds: 200),
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (int value) {
          setState(() {
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
              enabled: false,
              icon: Icon(null),
              label: LocaleKeys.LiveStream.tr()),
          NavigationDestination(
              selectedIcon: Image.asset(
                'assets/images/cross-platform.png',
                height: 24,
                width: 24,
                color: Colors.black,
              ),
              icon: Image.asset(
                'assets/images/cross-platform.png',
                height: 24,
                width: 24,
                color: Colors.grey,
              ),
              label: LocaleKeys.Platforms.tr()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      appBar: AppBar(
        title: Text(
          LocaleKeys.title.tr(),
          // "مؤسسة صوت النرويج الاعلامية",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      drawer: NavigationDrawer(
        selectedIndex: drawerSelect,
        onDestinationSelected: (value) {
          switch (value) {
            case 0:
              Navigator.of(context).pushNamed('/onBoard');
            case 1:
              Navigator.of(context).pushNamed('/political');
              break;
            case 2:
              Navigator.of(context).pushNamed('/local');
              break;
            case 3:
              Navigator.of(context).pushNamed('/sport');
              break;
            case 4:
              Navigator.of(context).pushNamed('/youtube_list_screen');
              // _launchUrl(Uri.parse(
              //     "https://www.youtube.com/playlist?list=PLehaaLsoPPRinl-P5ibncWU3TbrHwjPzP"));
              // break;
            case 5:
              _launchUrl(Uri.parse("https://soundcloud.com/norwayvoice"));
              break;
            case 6:
              Navigator.of(context).pushNamed('/aboutUs');
              break;
            case 7:
              Navigator.of(context).pushNamed('/contact_us');
              break;
            case 8:
              Navigator.of(context).pushNamed('/setting');
              break;
          }
          selectedPageIndex = value;
        },
        children: [
          ListTile(
            dense: true,
            title: Text(
              LocaleKeys.News.tr(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
          NavigationDrawerDestination(
              icon: Icon(Icons.article_outlined),
              selectedIcon: Icon(Icons.article_rounded),
              label: Text(LocaleKeys.onBoard.tr())),
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
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
          Divider(),
          NavigationDrawerDestination(
              selectedIcon: Icon(Icons.people),
              icon: Icon(Icons.people_alt_outlined),
              label: Text(LocaleKeys.AboutUs.tr())),
          NavigationDrawerDestination(
              selectedIcon: Icon(Icons.contact_phone_rounded),
              icon: Icon(Icons.contact_phone_outlined),
              label: Text('للاتصال بنا')),
          SizedBox(
            height: 180,
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
        // backgroundColor: fabBackColor,
        backgroundColor: darkColorScheme.onPrimaryContainer,
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
