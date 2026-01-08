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
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadSaveUser();
    });
  }

  /*
  * 로그인한 상태에서 검사 시작하기 버튼을 클릭했을 때,
  * _validateName() 기능이 _nameController.text 접근하여 클라이언트가 작성한 데이터좀 확인해볼까~~
  *
  * _nameController 이름은 개발자가 지정하는 변수 명칭일 뿐
  * 소비자의 이름을 제어하기 위해 명칭 controller 와 name 을 추가하여 생성
  *
  * 로그인한 상태에서는 GuestSection 이 렌더링 되지 않음
  * _nameController 가 초기화 되지 않은 상태
  * _nameController = null 도 아닌 undefined.text 로 오류 발생
  *
  * _nameController.text.trim()
  * */
  bool _validateName() {

    // 로그인 한 경우에는 소비자가 input 창에 본인의 이름을 작성했는지 검증할  필요가 없으므로
    if(context.read<AuthProvider>().isLoggedIn){
      return true; // 바로 통과~! 반환
    }

    // 게스트인 경우에만 _nameController = 소비자가 작성한 명칭이 들어있는 공간에 접근
    String name = _nameController.text.trim();

    // 1. 빈 값 체크
    if (name.isEmpty) {
      setState(() {
        _errorText = '이름을 입력해주세요.';
      });
      return false;
    }

    // 2. 글자 수 체크 (2글자 미만)
    if (name.length < 2) {
      setState(() {
        _errorText = '이름은 최소 2글자 이상이어야 합니다.';
      });
      return false;
    }

    // 3. 한글/영문 이외 특수문자나 숫자 포험 체크 여부(정규식)
    // 만약 숫자도 허용하려면 r'^[가-힣-a-zA-Z0-9]+$' 로 변경
    // 만약 숫자도 허용하려면 r'^[가-힣a-zA-Z0-9]+$' - : 어디서부터 어디까지
    // 가-힣 가에서부터 힣까지 힇에서 a까지는 잘못된 문법 정규식 동작 안함
    if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        _errorText = '한글 또는 영문만 입력 가능합니다\n(특수문자, 숫자 불가).';
      });
      return false;
    }

    // 통과 시 에러 메세지 비움
    setState(() {
      _errorText = null;
    });
    return true;
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("로그아웃"),
        content: Text("로그아웃 하시겠습니까?"),
        actions: [
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
                      GuestSection(
                        abc : _nameController,
                        eText : _errorText,
                        onErrorChanged : (error) => setState(() =>  _errorText = error)
                      )
                    else
                      UserSection(),
                    SizedBox(height: 20),
                    // 검사 시작하기 버튼은 게스트 모드, 유저 모드 관계없이 누구나 볼 수 있어야 함
                    // 게스트는 유저 이름 입력하고 검사 시작할 수 있다.
                    // 유저는 로그인한 유저 이름으로 검사 시작할 수 있다.
                    /*
                    The following JSNoSuchMethodError was thrown while handling a gesture:
                    TypeError: Cannot read properties of undefined (reading 'text')
                    When the exception was thrown, this was the stack:
                    package:frontend/screens/home/home_screen.dart 38:40                              [_validateName]

                     _nameController 문제 생김

                     */
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_validateName()) {
                            String name = _nameController.text.trim();
                            context.go('/test', extra: name);
                          }
                        },
                        child: Text(
                          '검사 시작하기',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    // if else 와 관계없이 누구나 검사를 시작하는 버튼을 클릭할 수 있어야한다.
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
