import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '';
const apiUrl = 'https://api.openai.com/v1/chat/completions';
const prompt_prefix = '''


감정 목록:
a) 행복
b) 기대
c) 신뢰
d) 즐거움
e) 만족
f) 기쁨
g) 안도
h) 감사
i) 슬픔
j) 분노
k) 혐오
l) 실망
m) 우울
n) 불안
o) 불만
p) 외로움
q) 공포
r) 놀람
s) 감정없음
- 지금부터 너는 감정 목록에 있는 감정이 내가 제공하는 텍스트에서 판단되는지 대답할거야.
- 사실을 나열한 일기와 같이 감정이 포함되어있지 않다고 판단되면 's'라고 대답해야해. s는 단독으로만 사용가능해
- 주어진 일기에서 일기를 쓴 사람이 크게 느낀 2가지의 감정을 추출해줘.
- 감정목록 내부에 존재하는 감정 키워드 중에서 주어진 일기에 알맞은 감정 2개를 객관식으로, a~s중 2개를 선택해 답변해줘. 
- 답변은 아래 예시를 꼭 따라서 예시처럼 대답해줘.

[예시]
Q: 오늘 아침부터 코딩하느라 힘들었다. 날씨도 좋지 않아서 우울하지만 곧 종강이니까 괜찮아.
A: o, m, b

Q: 오늘은 토요일이다. 그리고 12월이다.
A: s

''';


Future<String> extractEmotion(String prompt) async{
  final res = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'},
    body: jsonEncode({
      "model": "gpt-4",
      "messages": [
        {"role": "system", "content": prompt_prefix},
        {"role": "user", "content": prompt}
      ]
    }),
  );
  Map<String, dynamic> new_res = jsonDecode(utf8.decode(res.bodyBytes));
  print(new_res);

  return new_res['choices'][0]['message']['content'];
}

void main(){
  // runApp(const MyApp());
  String prompt = '''Q. 오늘 코딩을 했다. 착잡했다. 피고해서 그만하고 싶다. 집에 가고싶다
A: ''';
  Future<String> data = extractEmotion(prompt);
  data.then((value) {
    print(value);
  });
}



//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(
//       title: 'ChatGPT Test',
//       theme: ThemeData()
//     )
//   }
// }
