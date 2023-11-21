import 'package:flutter/material.dart';

import 'colorpicker.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_gradients_reborn/flutter_gradients_reborn.dart';
import 'circular_menu.dart';

void main() {
  runApp(MaterialApp(home: homeApp()));
}


class homeApp extends StatefulWidget {
  @override
  _homeAppState createState() => _homeAppState();
}

class _homeAppState extends State<homeApp> {

  var now = DateTime.now();
  var year = DateFormat('yyy').format(DateTime.now());
  var month = DateFormat('MMM').format(DateTime.now());

  int getDaysInMonth(year, month) {  // 월별 일수 계산
    int yearNum;
    int monthNum;
    yearNum = int.parse(year);
    switch(month) {
      case 'Jan': monthNum = 1; break;
      case 'Feb': monthNum = 2; break;
      case 'Mar': monthNum = 3; break;
      case 'Apr': monthNum = 4; break;
      case 'May': monthNum = 5; break;
      case 'Jun': monthNum = 6; break;
      case 'Jul': monthNum = 7; break;
      case 'Aug': monthNum = 8; break;
      case 'Sep': monthNum = 9; break;
      case 'Oct': monthNum = 10; break;
      case 'Nov': monthNum = 11; break;
      case 'Dec': monthNum = 12; break;
      default: monthNum = 1; break;
    }
    return DateTime(yearNum, monthNum + 1, 0).day;
  }

  //String _currentMonth = DateFormat.yMMM().format(DateTime(2023, 12, 14));
  //DateTime _targetDateTime = DateTime(2023, 12, 14);

  List gradientList = [
    FlutterGradients.magicLake(),
    FlutterGradients.flyingLemon(),
    FlutterGradients.forestInei(),
    FlutterGradients.freshMilk(),
    FlutterGradients.freshOasis(),
    FlutterGradients.frozenBerry(),
    FlutterGradients.frozenDreams(),
    FlutterGradients.frozenHeat(),
    FlutterGradients.fruitBlend(),
    FlutterGradients.gagarinView(),
    FlutterGradients.gentleCare(),
    FlutterGradients.grassShampoo(),
    LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Colors.white.withOpacity(0.0), // empty bead
      ],
    ),
  ];

  addGradient(a, i) {
    setState(() {
      gradientList[i] = a;
    });
  }
  deleteGradient() {
    setState(() {
      gradientList.removeLast();
    });
  }

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
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Builder(
                builder: (context) {
                  return FloatingActionButton(
                    onPressed: (){
                      //_navigateAndDisplaySelection(context);
                    },
                    elevation: 0,
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xff606060),
                    hoverColor: Colors.redAccent,
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white54,
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Icon(Icons.add, size: 40,),
                    ),
                  );
                }
            ),
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    print('static hahaha');
                  },
                  icon: const Icon(
                    Icons.bar_chart,
                    color: Color(0xff606060),
                  )),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text('Flutter Circular Menu'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: Color(0xff606060),
                    ),
                    onPressed: () {
                      deleteGradient();
                    }),
                IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: Color(0xff606060),
                    ),
                    onPressed: () {
                      //addGradient(FlutterGradients.seaStrike());
                    }),
                IconButton(
                    icon: Icon(
                      Icons.palette_outlined,
                      color: Color(0xff606060),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ColorPickerDemo()),
                      );
                    }),
              ],
            ),
            body:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  shitcalendar(),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: makeGridView4(),
                  ),
                ]
            )

        )
    );
  }
/*
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => addApp()),
    ).then((value){
      if (value!=null){
        addGradient(value);}
    }
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.

  }
*/
  Widget shitcalendar() {
    return Container(
      margin: EdgeInsets.only(
        top: 30.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
              onPressed: () {
                setState(() {
                  int subtractMonths = 1;
                  now = DateTime(now.year, now.month - subtractMonths, now.day);
                  year = DateFormat('yyy').format(now);
                  month = DateFormat('MMM').format(now);
                });
              },
              icon: const Icon(Icons.arrow_back_ios)),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    year,
                    style: TextStyle(
                      fontFamily: 'Julius',
                      fontSize: 40.0,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    month.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Julius',
                      fontSize: 40.0,
                    ),
                  ),
                ],
              )
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  int addMonths = 1;
                  now = DateTime(now.year, now.month + addMonths, now.day);
                  year = DateFormat('yyy').format(now);
                  month = DateFormat('MMM').format(now);
                });
              },
              icon: const Icon(Icons.arrow_forward_ios)),
        ],
      ),
    );

    //
  }

  Widget makeGridView4() {
    return GridView.extent(
      //scrollDirection: Axis.vertical,
        shrinkWrap: true,
        maxCrossAxisExtent: 80.0,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.2,
        children: List.generate(getDaysInMonth(year, month), (index) {
          return GestureDetector(

            onTap: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('$month / ${index+1} ex)기쁨 뿌듯'),
                      content: Text('구슬 정보를 수정하거나 삭제합니다.\n삭제시 빈 구슬로 저장됩니다!'),
                      actions: [
                        TextButton(
                          child: Text('수정'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => addApp(data: '${index+1}'),
                              ),
                            );
                            print('Received data: ${result[0]}, ${result[1]}');
                            if (result!=null){
                              addGradient(result[0], int.parse(result[1])-1);
                            }
                          },
                        ),
                        TextButton(
                          child: Text('삭제'),
                          onPressed: () {
                            setState(() {
                              gradientList[index] = LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.white.withOpacity(0.0), // empty bead
                                ],
                              );
                            });
                            Navigator.of(context).pop();
                            },
                        ),
                      ],
                    );},
              );},
              child: Expanded(
                child: Container(
                  width: 50,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient:
                        index >= gradientList.length ?
                            LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.white.withOpacity(0.0), // empty bead
                              ],
                            )
                            : gradientList[index],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2.0,
                        blurRadius: 7.0,
                        offset: Offset(2, 2), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              )
          );
        }),
    );
  }
}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Close the screen and return "Yep!" as the result.
                  Navigator.pop(context, 'Yep!');
                },
                child: const Text('Yep!'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Close the screen and return "Nope." as the result.
                  Navigator.pop(context, 'Nope.');
                },
                child: const Text('Nope.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}