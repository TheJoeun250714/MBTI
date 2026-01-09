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
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName =
        authProvider.user?.userName; // ? -> 없으면 에러 뜨기보다는 null 형태로 상태 유지
    return Column(
      children: [
        // 000 님
        SizedBox(child: Text('$userName님')),
        // 3. /map 내 위치 지도 보기 로 잠시 사용
        SizedBox(
        //  child: Text("내 주변 10km 다른 유저의 MBTI 확인하기"),
          child: ElevatedButton(onPressed: () =>context.go('/map'), child: Text("내 위치 지도 보기")),
        )
      ],
    );
  }
}
