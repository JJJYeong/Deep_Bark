// lib/main.dart
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart'; // 카카오 SDK import 추가
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// 화면 import
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/scan_result_screen.dart';
import 'screens/dog_encyclopedia_screen.dart';
import 'screens/breed_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/language_settings_screen.dart';
import 'screens/main_screen.dart'; // 새로운 메인 화면 추가

// 서비스 import
import 'services/auth_service.dart';
import 'services/locale_provider.dart';
import 'services/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 카카오 SDK 초기화 (네이티브 앱 키로 교체 필요)
  KakaoSdk.init(nativeAppKey: 'f72cc05a22c1e94081315d79eb930c42');

  // AuthService 초기화 및 현재 사용자 확인
  final authService = AuthService();
  await authService.checkCurrentUser();

  // 언어 설정 로드
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider.value(value: localeProvider),
      ],
      child: MyApp(authService: authService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AuthService authService;

  MyApp({required this.authService});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: '멍멍스캔',
          theme: ThemeData(
            primarySwatch: Colors.brown,
            fontFamily: 'NotoSansKR',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          locale: localeProvider.locale,  // 현재 로케일 설정
          supportedLocales: [
            Locale('ko', ''), // 한국어
            Locale('en', ''), // 영어
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,  // 사용자 정의 번역
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          initialRoute: '/', // 초기 화면을 스플래시 화면으로 설정
          routes: {
            '/': (context) => SplashScreen(), // 루트 경로를 SplashScreen으로 설정
            '/login': (context) => LoginScreen(),
            '/signup': (context) => SignupScreen(),
            '/home': (context) => HomeScreen(),
            '/main': (context) => MainScreen(), // 메인 탭 화면 추가
            '/result': (context) => ScanResultScreen(),
            '/encyclopedia': (context) => DogEncyclopediaScreen(),
            '/breed_detail': (context) => BreedDetailScreen(),
            '/profile': (context) => ProfileScreen(),
            '/language_settings': (context) => LanguageSettingsScreen(),
          },
        );
      },
    );
  }
}
