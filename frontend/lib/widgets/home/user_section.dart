import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserSection extends StatefulWidget {
  const UserSection({super.key});

  @override
  State<UserSection> createState() => _UserSectionState();
}

class _UserSectionState extends State<UserSection> {
  final TextEditingController _nameController = TextEditingController();

  String? _errorText; // 에러 메세지를 담을 변수 ? = 변수 공간에 null 들어갈 수 있다.

  // 유효성 검사 함수
  // 기능 중에 일부라도 문법상 문제가 생기면 기능 자체가 작동 중지
  bool _validateName() {
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

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName =
        authProvider.user?.userName; // ? -> 없으면 에러 뜨기보다는 null 형태로 상태 유지
    return Column(
      children: [
        // 000 님
        SizedBox(child: Text('$userName님')),
        SizedBox(
          child: Text("내 주변 10km 다른 유저의 MBTI 확인하기"),
        )

      ],
    );
  }
}
