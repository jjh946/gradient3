import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '';
const apiUrl = 'https://api.openai.com/v1/chat/completions';
const prompt_prefix = '''
[분노, 공포, 기대, 놀람, 기쁨, 슬픔, 신뢰, 혐오, 평안, 승인, 불안, 신경쓰임, 황홀, 존경, 극심한 공포, 깜짝 놀람, 비탄, 증오, 경계, 격노, 수심, 지루함, 짜증, 관심], 이 감정들이 너가 찾아야 할 감정이야.
아래 지시를 따라줘.
최대한 앞서 나열한 감정만 사용해줘.
가장 크게 느껴지는 3가지의 감정만 추출하고 이유를 알려줘.
괄호를 써서 2가지 감정을 한 번에 표현하지마.
일기에서 타인이 아닌 일기를 쓰는 사람이 느끼는 감정을 3가지 추출해줘.
[예시]
Q: 오늘 아침에 일찍 일어났지만 교통체증 때문에 지각을 해서 아침부터 망쳐버렸어. 오늘 비가오는데 우산도 가져오지 않아서 비에 흠뻑 젖어서 울적해. 그래도 내일이 주말이라 다행이다
A: 짜증, 슬픔, 기대

Q. 오늘 아침에 나와 사이가 좋지않던 친구에게 회사에 최종 면접을 통과해서 너무 기쁘다는 문자를 받았어. 그는 나를 무시하고 놀렸기 때문에 조금 슬펐어. 내일은 그래도 다른 면접이 있으니 힘내자
A: 혐오, 슬픔, 기대
(일기를 쓴 사람은 기쁨을 느끼지 않았음)''';


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
