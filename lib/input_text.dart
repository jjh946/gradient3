import 'dart:convert';
import 'apikey.dart';

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
                            _emotionResponse = value; // 상태 갱신
                            // _emotionResponseList = value.split(',')
                            // .map((e) => e.trim())
                            // .map((e) => "'$e'")
                            // .toList();
                            _emotionResponseList = value.split(',').map((e) => e.trim()).toList(); 

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
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(_emotionResponseList.toString(), // 화면에 API 응답 출력
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
    
    //print(doc.data());

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
const apiUrl = 'https://api.openai.com/v1/chat/completions';
const prompt_prefix = '''
[뿌듯, 슬픔, 기쁨, 피곤, 아쉬움, 기대], 이 감정들이 너가 찾아야 할 감정이야.
아래 지시를 따라줘.
최대한 앞서 나열한 감정만 사용해줘.
가장 크게 느껴지는 3가지의 감정만 추출하고 이유를 알려줘.
괄호를 써서 2가지 감정을 한 번에 표현하지마.
일기에서 타인이 아닌 일기를 쓰는 사람이 느끼는 감정을 3가지 추출해줘.

[예시]
Q: 오늘 아침에 일찍 일어났지만 교통체증 때문에 지각을 해서 아침부터 망쳐버렸어. 오늘 비가오는데 우산도 가져오지 않아서 비에 흠뻑 젖어서 울적해. 그래도 내일이 주말이라 다행이다
A: 피곤, 슬픔, 기대

Q. 오늘 아침에 나와 사이가 좋지않던 친구에게 회사에 최종 면접을 통과해서 너무 기쁘다는 문자를 받았어. 그는 나를 무시하고 놀렸기 때문에 조금 슬펐어. 내일은 그래도 다른 면접이 있으니 힘내자
A: 슬픔, 기대
(3개 이하의 감정만 감지된다면 3개 이하로 추출해도 됨)''';


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