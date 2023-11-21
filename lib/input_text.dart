import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter_gradients_reborn/flutter_gradients_reborn.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(home: textApp())
  );
}

class textApp extends StatefulWidget {
  const textApp({super.key});

  @override
  State<textApp> createState() => _textAppState();
}

class _textAppState extends State<textApp> {
  final _contentEditController = TextEditingController();
  final Gradient _gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
    ],
  );
  var feelings = [
    FlutterGradients.magicLake(),
    FlutterGradients.flyingLemon(),
  ];


  var now = DateTime.now();
  var year = DateFormat('yyy').format(DateTime.now());
  var month = DateFormat('MMM').format(DateTime.now());
  var day = DateFormat('M / d / E').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    print(day);
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
                Navigator.pop(context);
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
                                gradient: feelings[i],
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
                        onPressed: () {
                          var text = _contentEditController.text; // 일기 내용 저장
                        },

                        child: Text('구슬 생성하기', style: TextStyle(color: Colors.deepPurple,))
                    ),
                  ]
              ),
            )
        )
    );
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