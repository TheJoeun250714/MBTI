import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:provider/provider.dart';

/*
로그인한 유저 이름이 테스트로 넘어가는지 확인
signup
스크린 생성
main route  추가
 */
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  bool _validateName() {
    /* TODO 3-1: 입력값 가져오기 및 공백 제거 */
    // - _nameController.text로 입력값 가져오기
    // - trim() 메서드로 앞뒤 공백 제거
    String name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorText = '이름을 입력해주세요.';
      });
      return false;
    }

    if (name.length < 2) {
      setState(() {
        _errorText = '이름은 최소 2글자 이상이어야 합니다.';
      });
      return false;
    }
    if (!RegExp(r'^[가-힣a-zA-Z]+$').hasMatch(name)) {
      setState(() {
        _errorText = '한글 또는 영문만 입력 가능합니다\n(특수문자, 숫자 불가).';
      });
      return false;
    }

    setState(() {
      _errorText = null;
    });
    return true;
  }

  Future<void> _handleLogin() async {
    if(!_validateName()) return;

    setState((){
      _isLoading = true;
    });
    try{
      String name = _nameController.text.trim();
      final user = await ApiService.login(name);

      if(mounted) {
        await context.read<AuthProvider>().login(user);

        // 2번 ScaffoldMessenger.of   context  showSnackBar() ${user.userName}님, 환영합니다.
        ScaffoldMessenger.of(context).showSnackBar(
          // Google 에서 만든 디자인과 디자인 세부설정이 작성되어 있는 SnackBar.dart 클래스 파일
          // SnackBar 를 만들 때
          // 필수로 사용했으면 하는 속성
          // 선택적으로 사용했으면 하는 속성
          // content 라는 속성은 필수로 사용했으면 좋겠다는 속성
          // 이 속성에는 클라이언트들이 어떤 바인지 확인할 수 있는 텍스트나 아이콘이 있었으면 좋겠다.
          // Text()의 경우에도 Google 에서 예쁘게 중간은 가는 디자인을 설정한 Text.dart 파일
          // 어느정도 디자인을 할 수 있는 상급 개발자가 되고 나면 Google에서 제공하는 디자인을 사용하는 것이 아니라
          // 회사 내부 규정대로 만들어놓은 회사이름_Text() / DarkThemeText.dart 와 같은 파일을 만들어
          // 사용할 수 있으므로 content: 개발자가 사용하고자 하는 UI 기반 클래스 작성해라
          SnackBar(
            content: Text('${user.userName}님 환영합니다.'),
            duration:Duration(seconds:2)
          )
        );
        // 로그인 후 이동하고자 하는 화면 이동
        context.go("/");

      }
    } catch (e){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* TODO 4-1: AppBar 구현 */
      // - title: Text('로그인')
      // - leading: 뒤로가기 IconButton
      //   - icon: Icon(Icons.arrow_back)
      //   - onPressed: () => context.go('/')
      appBar: AppBar(
        title: Text('로그인'),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 100, color: Colors.blue),
                SizedBox(height: 30),
                Text(
                  'MBTI 검사를 위해\n로그인해주세요',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _nameController,

                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: '이름을 입력해주세요.',
                      border: OutlineInputBorder(),
                      errorText: _errorText,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (RegExp(r'[0-9]').hasMatch(value)) {
                          _errorText = '숫자는 입력할 수 없습니다.';
                        } else if (RegExp(r'[^가-힣a-zA-Z]').hasMatch(value)) {
                          _errorText = '한글과 영어만 입력 가능합니다.';
                        } else {
                          _errorText = null;
                        }
                      });
                    },
                  ),
                ),

                SizedBox(height: 30),

                /* TODO 5-7: 로그인 버튼 구현 */
                // - SizedBox로 width: 300, height: 50 지정
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('로그인하기'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
