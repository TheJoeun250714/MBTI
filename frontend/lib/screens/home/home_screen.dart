import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/widgets/home/guest_section.dart';
import 'package:frontend/widgets/home/profile_menu.dart';
import 'package:frontend/widgets/home/user_section.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
/*
lib/
├────screens/
│       └─── home_screen.dart           (메인 홈 화면 : 조립하는 역할)
│
├────widgets/
        └─── home/                      (홈 화면 전용 위젯 폴더 생성)
               ├────guest_section.dart  (로그인 전 화면)
               ├────user_section.dart   (로그인 후 화면 + 입력 로직)
               └────profile_menu.dart   (앱바 프로필 메뉴)
 */
// 상태에 따른 화면 변화가 일어날 예정
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // HomeScreen 내부에서 사용할 변수이름, 함수 이름 작성
  /*
  만약에 Input 이나 Textarea를 사용할 경우에는 사용자들이 작성한 값(value)를 읽고
  읽은 value 데이터를 가져오기 위해 기능 작성해야함
  -> dart 에서는 TextEditingController 객체를 미리 만들어놓았음

  사용방법
  1. 컨트롤러 상태를 담을 변수 공간 설정 _ private 설정을 안해도 됨
  final TextEditingController _nameController = TextEditingController();
  2. TextField 에 연결
  TextField(
     controller:_nameController  와 같은 형태로 내부에서 작성된  value를 연결

  3. 값을 가져와서 확인하거나 사용하기
  String name = _nameController.text;
   */

  // 홈화면 시작하자마자 실행할 기능들 세팅
  // git init -> git 초기세팅 처럼 init 초기 세팅
  // state 상태 변화 기능
  // initState() -> 위젯 화면을 보여줄 때 초기 상태 화면 변화하여 보여주겠다
  // ex 화면에서 backend 데이터를 가져오겠다. 로그인 상태 복원하겠다.
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadSaveUser();
    });
  }



  // UI 화면
  /*
  키보드를 화면에서 사용해야하는 경우
  화면이 가려지는 것을 방지하기 위해 스크롤 가능하게 처리
   */
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("로그아웃"),
        content: Text("로그아웃 하시겠습니까?"),
        actions: [
          //                    과제 Navigator.pop(context) -> go_router 사용한 context로 교체하기
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("로그아웃 되었습니다.")));
            },
            child: Text("로그아웃", style: TextStyle(color:Colors.red),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isLoggedIn = authProvider.isLoggedIn;
        final userName = authProvider.user?.userName;

        return Scaffold(
          appBar: AppBar(
            title: Text("MBTI 유형 검사"),
            actions: [
              // 로그인 상태에 따라 버튼 표기
              if (isLoggedIn)
                // 분리된 프로필 메뉴 위젯에
                // userName 이라는 명칭으로 userName 내부 데이터 전달
                // onLogout 이라는 명칭으로 _handleLogout 기능 전달
                ProfileMenu(userName: userName, onLogout: _handleLogout)

            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.psychology, size: 100, color: Colors.blue),
                    SizedBox(height: 30),
                    Text(
                      '나의 성격을 알아보는 ${AppConstants.totalQuestions}가지 질문',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 40),
                    if (!isLoggedIn)
                      GuestSection()
                    else
                      UserSection(),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => context.go('/types'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                          foregroundColor: Colors.black87,
                        ),
                        child: Text("MBTI 유형 보기"),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
