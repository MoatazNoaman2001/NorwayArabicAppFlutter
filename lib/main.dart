import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:norway_flutter_app/features/app_controller/domain/Get_theme_use_case.dart';
import 'package:norway_flutter_app/features/app_controller/domain/change_theme_use_case.dart';
import 'package:norway_flutter_app/features/news/presentation/bloc/platforms/platform_bloc.dart';
import 'package:norway_flutter_app/features/news/presentation/screens/platfroms_scr.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/screens/setting.dart';
import 'package:norway_flutter_app/features/streams/presenation/audio_stream_screen.dart';
import 'package:norway_flutter_app/features/streams/presenation/select_stream_type.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:norway_flutter_app/features/app_controller/domain/Get_lang_use_case.dart';
import 'package:norway_flutter_app/features/app_controller/domain/change_lang_use_case.dart';
import 'package:norway_flutter_app/features/app_controller/presentation/bloc/controller_bloc.dart';
import 'package:norway_flutter_app/features/news/data/news_parser_impl.dart';
import 'package:norway_flutter_app/features/news/data/repo/new_repository_impl.dart';
import 'package:norway_flutter_app/features/news/domain/repo/news_repo.dart';
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
import 'features/news/data/models/norway_new.dart';
import 'features/news/domain/usecases/platforms_usecase.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
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
          var bloc = BlocProvider.of<ControllerBloc>(context);
          setState(() {
            if (state.theme != "0") {
              _themeMode = ThemeMode.dark;
            } else {
              _themeMode = ThemeMode.light;
            }
          });
        }
      },
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          themeMode: _themeMode,
          darkTheme:
              ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
          initialRoute: '/',
          routes: {
            '/': (context) => InitiateApp(),
            '/select_language': (context) => SelectLanguage(),
            '/home': (context) =>
                const MyHomePage(title: "اذاعة النرويج بالعربية"),
            '/political': (context) =>
                PoliticalNews(url: Constants.newsUrls[2]),
            '/local': (context) => LocalNews(url: Constants.newsUrls[3]),
            '/sport': (context) => SportNews(url: Constants.newsUrls[4]),
            '/details': (context) => const NewDetails(),
            '/platform': (context) => PlatformScreen(),
            '/setting': (context) => SettingScreen(),
            '/select_stream': (context) => SelectStreamType(),
            '/audio_stream': (context) => AudioStreamScreen(),
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectedPageIndex = 0;
  int drawerSelect = -1;
  final screens = [
    GeneralNews(url: Constants.newsUrls[0]),
    OnBoard(url: Constants.newsUrls[1]),
  ];

  // final Map<String , List<NorwayNew>> newrayMap = {};
  // final ConnectivityController connectivityController = ConnectivityController();

  @override
  void initState() {
    super.initState();
    // connectivityController.init();
    // context.read<NewsBloc>().add(
    //     GetNorwayNewsList(Constants.generalNewsUrl[0], [])
    // );
  }

  void _incrementCounter() {
    Navigator.of(context).pushNamed('/select_stream');
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
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (int value) {
          setState(() {
            // context.read<NewsBloc>().add(
            //     GetNorwayNewsList(Constants.generalNewsUrl[value], [])
            // );
            selectedPageIndex = value;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home_filled),
            icon: Icon(Icons.home_outlined),
            label: "منوعات",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.article_rounded),
            icon: Icon(Icons.article_outlined),
            label: "تحقيقات",
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                  "https://www.youtube.com/watch?v=xGuKRoqcDqo&list=PLehaaLsoPPRgt7ryrzWthomamIaun121_"));
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
              "الاخبار",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          NavigationDrawerDestination(
              icon: Icon(Icons.handshake_outlined),
              selectedIcon: Icon(Icons.handshake),
              label: Text('سياسية')),
          NavigationDrawerDestination(
              icon: Icon(Icons.newspaper_outlined),
              selectedIcon: Icon(Icons.newspaper),
              label: Text('محلية')),
          NavigationDrawerDestination(
              icon: Icon(Icons.sports_football_outlined),
              selectedIcon: Icon(Icons.sports_football),
              label: Text('رياضية')),
          Divider(),
          ListTile(
            dense: true,
            title: Text(
              "منصاتنا",
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
              label: Text('يوتيوب')),
          NavigationDrawerDestination(
              icon: Image.asset(
                'assets/images/snapchat.png',
                height: 24,
                width: 24,
                color: Colors.grey,
              ),
              label: Text('سناب شات')),
          NavigationDrawerDestination(
              icon: Image.asset(
                'assets/images/cross-platform.png',
                height: 24,
                width: 24,
                color: Colors.grey,
              ),
              label: Text('باقي المنصات')),
          Divider(),
          NavigationDrawerDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: Text('باقي المنصات')),
        ],
      ),
      body: screens[selectedPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
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
