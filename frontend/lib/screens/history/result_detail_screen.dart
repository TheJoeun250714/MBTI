import 'package:flutter/material.dart';
import 'package:frontend/models/result_model.dart';
import 'package:frontend/services/api_service.dart';
/*
* 과제 : less로 변경하기
*
* */

class ResultDetailScreen extends StatefulWidget {
  /*
        GoRoute(
          path: '/history',
          builder: (context, state) {
            final userName = state.extra as String;
            return ResultDetailScreen( userName    : userName);
          }
      )
     /history 라는 명칭으로   ResultDetailScreen widget 화면을 보려할 때,
     메인에서 작성한 명칭의 유저 MBTI 확인하고자 하나,
     const ResultDetailScreen({super.key});  와 같이 작성할 경우에는
     기본 생성자이며, 매개변수 데이터를 전달받는 생성자가 아니기 때문에
     main.dart 에서 작성한 사용자 이름을 전달받지 못하는 상황이 발생

     자바랑 다르게 생성자를 기본생성자, 매개변수생성자 다수의 생성자를 만들 경우
     반드시 생성자마다 명칭을 다르게 설정하며
     보통은 클래스이름.기본생성자({super.key});
            클래스이름.매개변수생성자   ({super.key, required this.전달받아_사용할_변수이름});
   */
  final String userName;
  const ResultDetailScreen({super.key, required this.userName});

  @override // 화면상태와 화면에서 상태 변경을 위한 위젯을 구분하여 만든 후 사용
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  // 변수 언언 기능 선언을 주로 작성
  List<Result> results = [];
  bool isLoading = true;


  @override // 기본적으로 초기상태를 생성하며, 추가적으로 호출할 기능도 함께 작성 재사용
  void initState() {
    super.initState();
    loadResults();
  } // 변수 사용 가능 선언 가능하지만 되도록이면 화면에 해당하는 ui 작성
  // 상태 변경이 필요한 변수 사용

  // 유저이름에 따른 결과
  void loadResults() async{//  ResultDetailScreen extends StatefulWidget 선언한 userName
    // data = 지역변수 = {} 를 탈출할경우 변수의 의미가 소멸된다.
   try {
      final data = await ApiService.getResultsByUserName(widget.userName);
      setState(() {
        // results = 전역변수로  Widget build에 접근할 수 있는 변수 공간
        results = data;
        isLoading = false;
      });
    } catch (e) {
     setState(() {
       isLoading = false;
     });
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("결과를 불러오지 못했습니다."))
     );
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('result_detail_screen is working'),
      ),
    );
  }
}
