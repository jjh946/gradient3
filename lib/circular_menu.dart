import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import 'home.dart';

void main() {
  runApp(MaterialApp(home: addApp())
  );
}

class addApp extends StatefulWidget {
  @override
  _addAppState createState() => _addAppState();
}

class _addAppState extends State<addApp> {
  String _colorName = 'No';
  Color _color = Colors.black;
  Gradient _gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [

    ],
  );

  List colorList = [];
  List colorNameList = [];

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
            Navigator.pop(
                context
            );
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
        body: CircularMenu(
          alignment: Alignment.bottomCenter,
          backgroundWidget: background(),
          toggleButtonColor: Colors.white,
          toggleButtonIconColor: Color(0xff606060),

          items: [
            CircularMenuItem(

                color: Color(0xffE8F8C8),
                onTap: () {
                  setState(() {
                    _color = Color(0xffE8F8C8);
                    _colorName = '뿌듯';
                    _gradient.colors.add(_color);
                  });
                }),
            CircularMenuItem(

                color: Color(0xff78BFE8),
                onTap: () {
                  setState(() {
                    _color = Color(0xff78BFE8);
                    _colorName = '슬픔';
                    _gradient.colors.add(_color);
                  });
                }),
            CircularMenuItem(

                color: Color(0xffECACB8),
                onTap: () {
                  setState(() {
                    _color = Color(0xffECACB8);
                    _colorName = '기쁨';
                    _gradient.colors.add(_color);
                  });
                }),

            // CircularMenuItem(
            //
            //     color: Colors.white,
            //     onTap: () {
            //       setState(() {
            //         _color = Color(0xffECACB8);
            //         _colorName = '기쁨';
            //         _gradient.colors.add(_color);
            //       });
            //     }),
            CircularMenuItem(

                color: Color(0xffCBD2FD),
                onTap: () {
                  setState(() {
                    _color = Color(0xffCBD2FD);
                    _colorName = '피곤';
                    _gradient.colors.add(_color);
                  });
                }),
            CircularMenuItem(

                color: Color(0xff9ED6C0),
                onTap: () {
                  setState(() {
                    _color = Color(0xff9ED6C0);
                    _colorName = '아쉬움';
                    _gradient.colors.add(_color);
                  });
                })
          ],
        ),
      ),
    );

  }

  Widget background(){

    return Builder(
        builder: (context) {
          return Center(
            child: Column(
              children: [

                Container(
                    margin: EdgeInsets.fromLTRB(0, 180, 0, 35),
                    child: Text('     오늘은 어떤 감정들을 느꼈나요?',
                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                    )
                ),
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
              ],
            ),
          );
        }
    );
  }
}