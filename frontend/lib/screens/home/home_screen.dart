import 'package:flutter/material.dart';
import 'package:frontend/common/constants.dart';
import 'package:go_router/go_router.dart';

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
  final TextEditingController _nameController = TextEditingController();

  // UI 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: /* const */ Text("MBTI 유형 검사")),
      body: Center(
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
            SizedBox(
              width: 300,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '이름',
                  hintText: '이름을 입력하세요.',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),

            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();

                    if(name.isEmpty) {
                      // 이름이 비어있을 경우 비어있음에 대한 안내 후 돌려보내기 ~
                      return;
                    }

                    // 검사 화면으로 이동 (이름전달)
                    context.go('/test', extra:name);
                  },
                  child: Text('검사 시작하기', style: TextStyle(fontSize: 16),)),
            ),
            /*
            div 와 성격이 같은 SizedBox 를 이용해서
            이전 결과 보기 버튼 생성할 수 있다.
            굳이 SizedBox 를 사용하여 버튼을 감쌀 필요 없지만
            상태관리나 디자인을 위해서 SizedBox 로 감싼다음 버튼을 작성하는 것도 방법이다.
            */
          ],
        ),
      ),
    );
  }
}
