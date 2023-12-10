import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gradients_reborn/flutter_gradients_reborn.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;

 


void main() {
  // var result = await firestore.collection('user').doc('jAwpP79Mg55elKzKXhqY').get();
  // print(result);
  runApp(MaterialApp(home: textApp())
  );
}

class textApp extends StatefulWidget  {
  const textApp({super.key});
  
  @override
  State<textApp> createState() => _textAppState();
}

class _textAppState extends State<textApp> {

  final _contentEditController = TextEditingController();
  String _emotionResponse = ""; // API 응답을 저장할 변수
  List<String> _multipleChoiceList =[];
  List<String> _emotionResponseList = [
   
  ];
  List<Color> feelings = [
    //Color.fromARGB(255, 68, 123, 224),
  ];

  final Gradient _gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      
      // Color(0xffECACB8),
    ],
  );
  var basefeelings = {
    '뿌듯': Color(0xffE8F8C8),
    '슬픔': Color(0xff78BFE8),
    '기쁨' : Color(0xffECACB8),
    '피곤' : Color(0xffCBD2FD),
    '아쉬움': Color(0xff9ED6C0),
    '기대' : Color(0xfd84ffff)
  };

  var emotions_dict = {
  'a': '행복',
  'b': '기대',
  'c': '신뢰',
  'd': '즐거움',
  'e': '만족',
  'f': '기쁨',
  'g': '안도',
  'h': '감사',
  'i': '슬픔',
  'j': '분노',
  'k': '혐오',
  'l': '실망',
  'm': '우울',
  'n': '불안',
  'o': '불만',
  'p': '외로움',
  'q': '공포',
  'r': '놀람',
  's': '감정없음'
  };
  
  var now = DateTime.now();
  var year = DateFormat('yyy').format(DateTime.now());
  var month = DateFormat('MMM').format(DateTime.now());
  var day = DateFormat('M / d / E').format(DateTime.now());


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffffffff),
                Color(0xffffffff),
                Color(0xffc8ffeb),
                Color(0xffbbeaff)
              ]),
          boxShadow: [],
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: const Icon(Icons.arrow_back_ios,color: Color(0xff606060),)),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text('Flutter Circular Menu'),
              actions: [TextButton(onPressed: (){
                Navigator.pop(
                    context,
                    _gradient
                );

              },
                  child: Text('완료',style: TextStyle(color: Color(0xff606060),))
              )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                  children: <Widget>[
                    date(),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: _gradient,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 3.0,
                            blurRadius: 7.0,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < feelings.length; i++)
                            Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.fromLTRB(10,10,10,10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    feelings[i],
                                    feelings[i],
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 2.0,
                                    blurRadius: 7.0,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // 개별 감정 구슬
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 30, 30, 10),
                      child: TextField(
                        controller: _contentEditController,
                        decoration: InputDecoration(
                          hintText: '오늘 하루를 구슬에 담아보세요.',
                          focusedBorder: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          

                          printColorPalette();
                          
                          var userInput = _contentEditController.text; // 텍스트 필드에서 텍스트 가져오기
                          String prompt = 'Q: ' + userInput + '\nA: '; // 사용자 입력을 포함한 프롬프트 생성

                          try {
                            var value = await extractEmotion(prompt);
                            //_multipleChoiceList = value; // 상태 갱신
                            // _emotionResponseList = value.split(',')
                            // .map((e) => e.trim())
                            // .map((e) => "'$e'")
                            // .toList();


                            _multipleChoiceList = value.split(',').map((e) => e.trim()).toList();
                            _emotionResponseList = _multipleChoiceList.map((item) => emotions_dict[item] ?? '').toList();
                            _emotionResponse = _emotionResponseList.join(', ');

                            await addColorsToList(feelings);
                            await addColorsToList(_gradient.colors);
                            
                            setState(() {
                              // 여기서 상태 업데이트
                              // 필요한 모든 상태 변경을 여기서 수행
                              
                            });

                            print(feelings);
                          } catch (e) {
                            print(e);
                          }
                          
                          
                        },
                        child: Text('구슬 생성하기', style: TextStyle(color: Colors.deepPurple))
                    ),
                    Text(_emotionResponse, // 화면에 API 응답 출력
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          // '수정하기' 버튼이 눌렸을 때 실행할 로직
                          // 예: Firestore 데이터 수정, 상태 업데이트 등
                        },
                        child: Text('감정 수정하기', style: TextStyle(color: Colors.blue))
                      ),
                    ),

                    // Text(_emotionResponseList.toString(), // 화면에 API 응답 출력
                    //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ]
              ),
            )
        )
    );
  }

  void printColorPalette() async {
    CollectionReference colorPalette = FirebaseFirestore.instance.collection('user/jAwpP79Mg55elKzKXhqY/color_palette');
    CollectionReference diary = FirebaseFirestore.instance.collection('user/jAwpP79Mg55elKzKXhqY/diary');

    // 컬렉션의 문서들을 조회합니다.
    QuerySnapshot querySnapshot = await colorPalette.get();
    QuerySnapshot querySnapshot2 = await diary.get();

    // 각 문서의 데이터를 프린트합니다.
    for (var doc in querySnapshot.docs) {
      print(doc.data());
    }
    for (var doc in querySnapshot2.docs) {
      print(doc.data());
    }
    print('------------------');

    var documentData = querySnapshot2.docs[0].data() as Map<String, dynamic>;
    var emotions = documentData['emotion'] as Map<String, dynamic>;
    var extractedEmotions = emotions['extractedEmotions'];

    print(extractedEmotions);

  }

  Future<void> addColorsToList(List<Color> feelings) async {
    print('------------------');
  CollectionReference emotionsCollection = FirebaseFirestore.instance.collection('user/jAwpP79Mg55elKzKXhqY/color_palette');

  QuerySnapshot snapshot = await emotionsCollection.get();
  for (var doc in snapshot.docs) {
    
    print(doc.data());

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    print('Firestore emotion: ${data['emotion']}, _emotionResponseList: $_emotionResponseList'); // 디버그 출력
    if (_emotionResponseList.contains(data['emotion'])) {
      print('data[\'color\']: ${data['color']}'); // 디버그 출력

      String colorString = data['color'];
      // "0x" 접두사 제거 후 16진수 색상 코드를 int로 변환
      int colorValue = int.parse(colorString.substring(2), radix: 16);
      feelings.add(Color(colorValue));

      print('Color added: ${Color(colorValue)}'); // 디버그 출력
    }
  }
}


  Widget date() {
    return Container(
      margin: EdgeInsets.fromLTRB(30,16,16,50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
              onPressed: () {
                setState(() {
                  now = now.subtract(Duration(days:1));
                  year = DateFormat('yyy').format(now);
                  month = DateFormat('MMM').format(now);
                  day = DateFormat('M / d / E').format(now);
                });
              },
              icon: const Icon(Icons.arrow_back_ios)),
          Expanded(
              child: Column(
                children: [
                  Text(
                    year,
                    style: TextStyle(
                      fontFamily: 'Julius',
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    month.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Julius',
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    day.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Julius',
                      fontSize: 20.0,
                    ),
                  ),
                ],
              )
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  now = now.add(Duration(days:1));
                  year = DateFormat('yyy').format(now);
                  month = DateFormat('MMM').format(now);
                  day = DateFormat('M / d / E').format(now);
                });
              },
              icon: const Icon(Icons.arrow_forward_ios)),
        ],
      ),
    );
  }
}


// const apiKey = '';
const apikey = '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';
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
    headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apikey'},
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