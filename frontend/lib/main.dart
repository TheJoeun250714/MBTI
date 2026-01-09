import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/common/env_config.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/screens/history/result_detail_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/screens/map/map_screen.dart';
import 'package:frontend/screens/signup/signup_screen.dart';
import 'package:frontend/screens/result/result_screen.dart';
import 'package:frontend/screens/test/test_screen.dart';
import 'package:frontend/screens/types/mbti_types_screen.dart';
import 'package:frontend/services/network_service.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경별 .env 파일 로드
  // 개발 : .env.development
  // 배포 : .env.product
  // 로컬 : .env.local
  //      .env.load(파일이름 : "프로젝트에 존재하는 파일이름")
  await dotenv.load(fileName: ".env.development");

  // 개발 중 상황 확인을 위해 환경 정보 출력
  if(EnvConfig.isDevelopment) EnvConfig.printEnvInfo();

  /*
  자료형? = 공간 내부가 텅텅 비어있는데, undefined 호출하여 에러를 발생하는 것이 아니라
        null = 비어있음 상태 처리로 에러 발생시키지 않는 안전 타입
        ex)  String? 변경가능한 데이터를 보관할 수 있는 공간 명칭;

  공간명칭! = NULL 단언 연산자  이 공간은 절대로 null 아님을 보장하는 표기
              개발자가 null이 아니라고 강제 선언
              위험한 연산자이지만 현재는 사용할 것
              // null 이면 빈 문자열 반환하는 방법이 있어요 휴먼
              static String get kakaoMAPKey => dotenv.env['KAKAO_MAP_KEY'] ?? '';

              빈 값이나 강제 대체값 처리 보다는 가져와야하는 키를 무사히 불러올 수 있도록 로직 작성

       ?? null이면 기본값      name ?? '기본프로필이미지.png'
       ?. null이면 null 반환   name?.length    이름이 비어있으면 null
   */

  AuthRepository.initialize(appKey: EnvConfig.kakaoMapKey);

  runApp(const MyApp());

}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/map', builder: (context, state) => const MapScreen()),
    // 2. 지도 경로 스크린 추가 /map
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/test',
      builder: (context, state) {
        final userName = state.extra as String;
        return TestScreen(userName: userName);
      },
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        final result = state.extra as Result;
        return ResultScreen(result: result);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) {
        final userName = state.extra as String;
        return ResultDetailScreen(userName: userName);
      },
    ),
    GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
    GoRoute(path: '/types', builder: (context, state) => MbtiTypesScreen()),
  ],
);

// MyApp Stateless -> Stateful  mounted ok
// context -> 최상위에서 사용하지 않음 -> HomeScreen으로 이동하여 사용하는 것이 맞음
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],

      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }
}



