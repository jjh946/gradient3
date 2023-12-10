import 'home.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
final firestore = FirebaseFirestore.instance;

void main() => runApp(const ColorPickerDemo());

class ColorPickerDemo extends StatefulWidget {
  const ColorPickerDemo({super.key});

  @override
  _ColorPickerDemoState createState() => _ColorPickerDemoState();
}

class _ColorPickerDemoState extends State<ColorPickerDemo> {
  late ThemeMode themeMode;
  List<DocumentSnapshot> paletteData = []; // Firestore 데이터를 저장할 리스트

  @override
  void initState() {
    super.initState();
    themeMode = ThemeMode.light;
    loadPaletteData(); // 데이터 로드
  }

    // Firestore에서 데이터를 로드하는 함수
  void loadPaletteData() async {
    var collection = FirebaseFirestore.instance.collection('user/jAwpP79Mg55elKzKXhqY/color_palette');
    var querySnapshot = await collection.get();
    setState(() {
      paletteData = querySnapshot.docs;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'ColorPicker',
      theme: ThemeData.from(colorScheme: const ColorScheme.highContrastLight())
          .copyWith(scaffoldBackgroundColor: Colors.grey[50]),
      darkTheme:
      ThemeData.from(colorScheme: const ColorScheme.highContrastDark()),
      themeMode: themeMode,
      home: ColorPickerPage(
        themeMode: (ThemeMode mode) {
          setState(() {
            themeMode = mode;
          });
        },
      ),
    );
  }
}

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key, required this.themeMode});
  final ValueChanged<ThemeMode> themeMode;

  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  late Color screenPickerColor; // Color for picker shown in Card on the screen.
  late Color dialogPickerColor; // Color for picker in dialog using onChanged
  late Color dialogSelectColor; // Color for picker using color select dialog.
  late bool isDark;
  late Color tiredColor;
  late Color extpectedColor;
  late Color shameColor;
  late Color gratefulColor;
  late Color trustColor;
  late Color surpriseColor;
  late Color angryColor;

  // Define some custom colors for the custom picker segment.
  // The 'guide' color values are from
  // https://material.io/design/color/the-color-system.html#color-theme-creation
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
  <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

  @override
  void initState() {
    screenPickerColor = const Color(0xFF78BFE8);
    dialogPickerColor = const Color(0xffECACB8);
    dialogSelectColor = const Color(0xFFE8F8C8);
    tiredColor = const Color(0xFFCBD2FD);
    extpectedColor = const Color(0xfd84ffff);
    shameColor = const Color(0xff9ED6C0);
    gratefulColor = const Color(0xFFFFFF00);
    trustColor = const Color(0xFF088A08);
    surpriseColor = const Color(0xFFFF00FF);
    angryColor = const Color(0xFFB40404);
    isDark = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homeApp()),
          );
        }, icon: const Icon(Icons.arrow_back_ios,color: Color(0xff606060),)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('나의 감정 팔레트 설정', style: TextStyle(color: Color(0xff393939)),),
        centerTitle: true,
        actions: [
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        children: <Widget>[
          const SizedBox(height: 16),
          // Pick color in a dialog.

          ListTile(
            title: const Text('뿌듯'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(dialogSelectColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(dialogSelectColor)}',
            ),
            trailing: ColorIndicator(
                width: 44,
                height: 44,
                borderRadius: 22,
                color: dialogSelectColor,
                elevation: 1,
                onSelectFocus: false,
                onSelect: () async {
                  // Wait for the dialog to return color selection result.
                  final Color newColor = await showColorPickerDialog(
                    // The dialog needs a context, we pass it in.
                    context,
                    // We use the dialogSelectColor, as its starting color.
                    dialogSelectColor,
                    title: Text('ColorPicker',
                        style: Theme.of(context).textTheme.titleLarge),
                    width: 40,
                    height: 40,

                    borderRadius: 4,
                    wheelDiameter: 165,
                    enableOpacity: true,
                    showColorCode: true,
                    colorCodeHasColor: false,
                    pickersEnabled: <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                    },
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: false,
                      pasteButton: false,
                      longPressMenu: true,
                    ),
                    actionButtons: const ColorPickerActionButtons(
                      okButton: true,
                      closeButton: true,
                      dialogActionButtons: false,
                    ),
                    transitionBuilder: (BuildContext context,
                        Animation<double> a1,
                        Animation<double> a2,
                        Widget widget) {
                      final double curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: widget,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 320, maxWidth: 320),
                  );
                  // We update the dialogSelectColor, to the returned result
                  // color. If the dialog was dismissed it actually returns
                  // the color we started with. The extra update for that
                  // below does not really matter, but if you want you can
                  // check if they are equal and skip the update below.
                  String newColorString = newColor.toString();
                  newColorString = newColorString.substring(10,16);
                  newColorString = "0xff" + newColorString;    
                  try{
                    CollectionReference colorPaletteCollection = firestore.collection('user').doc('jAwpP79Mg55elKzKXhqY').collection('color_palette');

                    print("SNAPSHOT: start");
                    QuerySnapshot querySnapshot = await colorPaletteCollection.where('emotion', isEqualTo: '뿌듯').get();
                    // print full snapshot
                    print("SNAPSHOT: ${querySnapshot.docs}");
                    for (QueryDocumentSnapshot document in querySnapshot.docs) {
                          String documentId = document.id;
                          print("documentId: " + documentId);
                          await colorPaletteCollection.doc(documentId).update({
                            'color': newColorString
                          });
                    };} catch (e) {
                      print("error: " + e.toString());
                    }


                  setState(() {
                    dialogSelectColor = newColor;
                  });
                }),
          ),
          ListTile(
            title: const Text('슬픔'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(screenPickerColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(screenPickerColor)}',
            ),
            trailing: ColorIndicator(
                width: 44,
                height: 44,
                borderRadius: 22,
                color: screenPickerColor,
                elevation: 1,
                onSelectFocus: false,
                onSelect: () async {
                  // Wait for the dialog to return color selection result.
                  final Color newColor = await showColorPickerDialog(
                    // The dialog needs a context, we pass it in.
                    context,
                    // We use the dialogSelectColor, as its starting color.
                    screenPickerColor,
                    title: Text('ColorPicker',
                        style: Theme.of(context).textTheme.titleLarge),
                    width: 40,
                    height: 40,

                    borderRadius: 4,
                    wheelDiameter: 165,
                    enableOpacity: true,
                    showColorCode: true,
                    colorCodeHasColor: false,
                    pickersEnabled: <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                    },
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: false,
                      pasteButton: false,
                      longPressMenu: true,
                    ),
                    actionButtons: const ColorPickerActionButtons(
                      okButton: true,
                      closeButton: true,
                      dialogActionButtons: false,
                    ),
                    transitionBuilder: (BuildContext context,
                        Animation<double> a1,
                        Animation<double> a2,
                        Widget widget) {
                      final double curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: widget,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 320, maxWidth: 320),
                  );
                  // We update the dialogSelectColor, to the returned result
                  // color. If the dialog was dismissed it actually returns
                  // the color we started with. The extra update for that
                  // below does not really matter, but if you want you can
                  // check if they are equal and skip the update below.
                  setState(() {
                    screenPickerColor = newColor;
                  });
                }),
          ),

          // Show the selected color.
          ListTile(
            title: const Text('기쁨'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(dialogPickerColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(dialogPickerColor)}',
            ),
            trailing: ColorIndicator(
                width: 44,
                height: 44,
                borderRadius: 22,
                color: dialogPickerColor,
                elevation: 1,
                onSelectFocus: false,
                onSelect: () async {
                  // Wait for the dialog to return color selection result.
                  final Color newColor = await showColorPickerDialog(
                    // The dialog needs a context, we pass it in.
                    context,
                    // We use the dialogSelectColor, as its starting color.
                    dialogPickerColor,
                    title: Text('ColorPicker',
                        style: Theme.of(context).textTheme.titleLarge),
                    width: 40,
                    height: 40,

                    borderRadius: 4,
                    wheelDiameter: 165,
                    enableOpacity: true,
                    showColorCode: true,
                    colorCodeHasColor: false,
                    pickersEnabled: <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                    },
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: false,
                      pasteButton: false,
                      longPressMenu: true,
                    ),
                    actionButtons: const ColorPickerActionButtons(
                      okButton: true,
                      closeButton: true,
                      dialogActionButtons: false,
                    ),
                    transitionBuilder: (BuildContext context,
                        Animation<double> a1,
                        Animation<double> a2,
                        Widget widget) {
                      final double curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: widget,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 320, maxWidth: 320),
                  );
                  // We update the dialogSelectColor, to the returned result
                  // color. If the dialog was dismissed it actually returns
                  // the color we started with. The extra update for that
                  // below does not really matter, but if you want you can
                  // check if they are equal and skip the update below.
                  setState(() {
                    dialogPickerColor = newColor;
                  });
                }),
          ),


          //tiredColor
          ListTile(
            title: const Text('피곤'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(tiredColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(tiredColor)}',
            ),
            trailing: ColorIndicator(
                width: 44,
                height: 44,
                borderRadius: 22,
                color: tiredColor,
                elevation: 1,
                onSelectFocus: false,
                onSelect: () async {
                  // Wait for the dialog to return color selection result.
                  final Color newColor = await showColorPickerDialog(
                    // The dialog needs a context, we pass it in.
                    context,
                    // We use the dialogSelectColor, as its starting color.
                    tiredColor,
                    title: Text('ColorPicker',
                        style: Theme.of(context).textTheme.titleLarge),
                    width: 40,
                    height: 40,

                    borderRadius: 4,
                    wheelDiameter: 165,
                    enableOpacity: true,
                    showColorCode: true,
                    colorCodeHasColor: false,
                    pickersEnabled: <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                    },
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: false,
                      pasteButton: false,
                      longPressMenu: true,
                    ),
                    actionButtons: const ColorPickerActionButtons(
                      okButton: true,
                      closeButton: true,
                      dialogActionButtons: false,
                    ),
                    transitionBuilder: (BuildContext context,
                        Animation<double> a1,
                        Animation<double> a2,
                        Widget widget) {
                      final double curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: widget,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 320, maxWidth: 320),
                  );
                  // We update the dialogSelectColor, to the returned result
                  // color. If the dialog was dismissed it actually returns
                  // the color we started with. The extra update for that
                  // below does not really matter, but if you want you can
                  // check if they are equal and skip the update below.
                  String newColorString = newColor.toString();
                  newColorString = newColorString.substring(10,16);
                  newColorString = "0xff" + newColorString;    
                  try{
                    CollectionReference colorPaletteCollection = firestore.collection('user').doc('jAwpP79Mg55elKzKXhqY').collection('color_palette');

                    print("SNAPSHOT: start");
                    QuerySnapshot querySnapshot = await colorPaletteCollection.where('emotion', isEqualTo: '피곤').get();
                    // print full snapshot
                    print("SNAPSHOT: ${querySnapshot.docs}");
                    for (QueryDocumentSnapshot document in querySnapshot.docs) {
                          String documentId = document.id;
                          print("documentId: " + documentId);
                          await colorPaletteCollection.doc(documentId).update({
                            'color': newColorString
                          });
                    };} catch (e) {
                      print("error: " + e.toString());
                    }


                  setState(() {
                    tiredColor = newColor;
                  });
                }),
          ),

          //expecteColor
          ListTile(
            title: const Text('기대'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(extpectedColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(extpectedColor)}',
            ),
            trailing: ColorIndicator(
                width: 44,
                height: 44,
                borderRadius: 22,
                color: extpectedColor,
                elevation: 1,
                onSelectFocus: false,
                onSelect: () async {
                  // Wait for the dialog to return color selection result.
                  final Color newColor = await showColorPickerDialog(
                    // The dialog needs a context, we pass it in.
                    context,
                    // We use the dialogSelectColor, as its starting color.
                    extpectedColor,
                    title: Text('ColorPicker',
                        style: Theme.of(context).textTheme.titleLarge),
                    width: 40,
                    height: 40,

                    borderRadius: 4,
                    wheelDiameter: 165,
                    enableOpacity: true,
                    showColorCode: true,
                    colorCodeHasColor: false,
                    pickersEnabled: <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                    },
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: false,
                      pasteButton: false,
                      longPressMenu: true,
                    ),
                    actionButtons: const ColorPickerActionButtons(
                      okButton: true,
                      closeButton: true,
                      dialogActionButtons: false,
                    ),
                    transitionBuilder: (BuildContext context,
                        Animation<double> a1,
                        Animation<double> a2,
                        Widget widget) {
                      final double curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: widget,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 320, maxWidth: 320),
                  );
                  // We update the dialogSelectColor, to the returned result
                  // color. If the dialog was dismissed it actually returns
                  // the color we started with. The extra update for that
                  // below does not really matter, but if you want you can
                  // check if they are equal and skip the update below.
                  String newColorString = newColor.toString();
                  newColorString = newColorString.substring(10,16);
                  newColorString = "0xff" + newColorString;    
                  try{
                    CollectionReference colorPaletteCollection = firestore.collection('user').doc('jAwpP79Mg55elKzKXhqY').collection('color_palette');

                    print("SNAPSHOT: start");
                    QuerySnapshot querySnapshot = await colorPaletteCollection.where('emotion', isEqualTo: '기대').get();
                    // print full snapshot
                    print("SNAPSHOT: ${querySnapshot.docs}");
                    for (QueryDocumentSnapshot document in querySnapshot.docs) {
                          String documentId = document.id;
                          print("documentId: " + documentId);
                          await colorPaletteCollection.doc(documentId).update({
                            'color': newColorString
                          });
                    };} catch (e) {
                      print("error: " + e.toString());
                    }


                  setState(() {
                    extpectedColor = newColor;
                  });
                }),
          ),
        
          //shameColor
          ListTile(
            title: const Text('아쉬움'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(shameColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(shameColor)}',
            ),
            trailing: ColorIndicator(
                width: 44,
                height: 44,
                borderRadius: 22,
                color: shameColor,
                elevation: 1,
                onSelectFocus: false,
                onSelect: () async {
                  // Wait for the dialog to return color selection result.
                  final Color newColor = await showColorPickerDialog(
                    // The dialog needs a context, we pass it in.
                    context,
                    // We use the dialogSelectColor, as its starting color.
                    shameColor,
                    title: Text('ColorPicker',
                        style: Theme.of(context).textTheme.titleLarge),
                    width: 40,
                    height: 40,

                    borderRadius: 4,
                    wheelDiameter: 165,
                    enableOpacity: true,
                    showColorCode: true,
                    colorCodeHasColor: false,
                    pickersEnabled: <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                    },
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: false,
                      pasteButton: false,
                      longPressMenu: true,
                    ),
                    actionButtons: const ColorPickerActionButtons(
                      okButton: true,
                      closeButton: true,
                      dialogActionButtons: false,
                    ),
                    transitionBuilder: (BuildContext context,
                        Animation<double> a1,
                        Animation<double> a2,
                        Widget widget) {
                      final double curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: widget,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 320, maxWidth: 320),
                  );
                  // We update the dialogSelectColor, to the returned result
                  // color. If the dialog was dismissed it actually returns
                  // the color we started with. The extra update for that
                  // below does not really matter, but if you want you can
                  // check if they are equal and skip the update below.
                  String newColorString = newColor.toString();
                  newColorString = newColorString.substring(10,16);
                  newColorString = "0xff" + newColorString;    
                  try{
                    CollectionReference colorPaletteCollection = firestore.collection('user').doc('jAwpP79Mg55elKzKXhqY').collection('color_palette');

                    print("SNAPSHOT: start");
                    QuerySnapshot querySnapshot = await colorPaletteCollection.where('emotion', isEqualTo: '아쉬움').get();
                    // print full snapshot
                    print("SNAPSHOT: ${querySnapshot.docs}");
                    for (QueryDocumentSnapshot document in querySnapshot.docs) {
                          String documentId = document.id;
                          print("documentId: " + documentId);
                          await colorPaletteCollection.doc(documentId).update({
                            'color': newColorString
                          });
                    };} catch (e) {
                      print("error: " + e.toString());
                    }


                  setState(() {
                    shameColor = newColor;
                  });
                }),
          ),

          //gratefulColor
          ListTile(
            title: const Text('감사'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(gratefulColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(gratefulColor)}',
            ),
            trailing: ColorIndicator(
                width: 44,
                height: 44,
                borderRadius: 22,
                color: gratefulColor,
                elevation: 1,
                onSelectFocus: false,
                onSelect: () async {
                  // Wait for the dialog to return color selection result.
                  final Color newColor = await showColorPickerDialog(
                    // The dialog needs a context, we pass it in.
                    context,
                    // We use the dialogSelectColor, as its starting color.
                    gratefulColor,
                    title: Text('ColorPicker',
                        style: Theme.of(context).textTheme.titleLarge),
                    width: 40,
                    height: 40,

                    borderRadius: 4,
                    wheelDiameter: 165,
                    enableOpacity: true,
                    showColorCode: true,
                    colorCodeHasColor: false,
                    pickersEnabled: <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                    },
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: false,
                      pasteButton: false,
                      longPressMenu: true,
                    ),
                    actionButtons: const ColorPickerActionButtons(
                      okButton: true,
                      closeButton: true,
                      dialogActionButtons: false,
                    ),
                    transitionBuilder: (BuildContext context,
                        Animation<double> a1,
                        Animation<double> a2,
                        Widget widget) {
                      final double curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: widget,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 320, maxWidth: 320),
                  );
                  // We update the dialogSelectColor, to the returned result
                  // color. If the dialog was dismissed it actually returns
                  // the color we started with. The extra update for that
                  // below does not really matter, but if you want you can
                  // check if they are equal and skip the update below.
                  String newColorString = newColor.toString();
                  newColorString = newColorString.substring(10,16);
                  newColorString = "0xff" + newColorString;    
                  try{
                    CollectionReference colorPaletteCollection = firestore.collection('user').doc('jAwpP79Mg55elKzKXhqY').collection('color_palette');

                    print("SNAPSHOT: start");
                    QuerySnapshot querySnapshot = await colorPaletteCollection.where('emotion', isEqualTo: '감사').get();
                    // print full snapshot
                    print("SNAPSHOT: ${querySnapshot.docs}");
                    for (QueryDocumentSnapshot document in querySnapshot.docs) {
                          String documentId = document.id;
                          print("documentId: " + documentId);
                          await colorPaletteCollection.doc(documentId).update({
                            'color': newColorString
                          });
                    };} catch (e) {
                      print("error: " + e.toString());
                    }


                  setState(() {
                    gratefulColor = newColor;
                  });
                }),
          ),

          //trustColor
          ListTile(
            title: const Text('신뢰'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(trustColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(trustColor)}',
            ),
            trailing: ColorIndicator(
                width: 44,
                height: 44,
                borderRadius: 22,
                color: trustColor,
                elevation: 1,
                onSelectFocus: false,
                onSelect: () async {
                  // Wait for the dialog to return color selection result.
                  final Color newColor = await showColorPickerDialog(
                    // The dialog needs a context, we pass it in.
                    context,
                    // We use the dialogSelectColor, as its starting color.
                    trustColor,
                    title: Text('ColorPicker',
                        style: Theme.of(context).textTheme.titleLarge),
                    width: 40,
                    height: 40,

                    borderRadius: 4,
                    wheelDiameter: 165,
                    enableOpacity: true,
                    showColorCode: true,
                    colorCodeHasColor: false,
                    pickersEnabled: <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                    },
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: false,
                      pasteButton: false,
                      longPressMenu: true,
                    ),
                    actionButtons: const ColorPickerActionButtons(
                      okButton: true,
                      closeButton: true,
                      dialogActionButtons: false,
                    ),
                    transitionBuilder: (BuildContext context,
                        Animation<double> a1,
                        Animation<double> a2,
                        Widget widget) {
                      final double curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: widget,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 320, maxWidth: 320),
                  );
                  // We update the dialogSelectColor, to the returned result
                  // color. If the dialog was dismissed it actually returns
                  // the color we started with. The extra update for that
                  // below does not really matter, but if you want you can
                  // check if they are equal and skip the update below.
                  String newColorString = newColor.toString();
                  newColorString = newColorString.substring(10,16);
                  newColorString = "0xff" + newColorString;    
                  try{
                    CollectionReference colorPaletteCollection = firestore.collection('user').doc('jAwpP79Mg55elKzKXhqY').collection('color_palette');

                    print("SNAPSHOT: start");
                    QuerySnapshot querySnapshot = await colorPaletteCollection.where('emotion', isEqualTo: '신뢰').get();
                    // print full snapshot
                    print("SNAPSHOT: ${querySnapshot.docs}");
                    for (QueryDocumentSnapshot document in querySnapshot.docs) {
                          String documentId = document.id;
                          print("documentId: " + documentId);
                          await colorPaletteCollection.doc(documentId).update({
                            'color': newColorString
                          });
                    };} catch (e) {
                      print("error: " + e.toString());
                    }


                  setState(() {
                    trustColor = newColor;
                  });
                }),
          ),

          //surpriseColor
          ListTile(
            title: const Text('놀람'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(surpriseColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(surpriseColor)}',
            ),
            trailing: ColorIndicator(
                width: 44,
                height: 44,
                borderRadius: 22,
                color: surpriseColor,
                elevation: 1,
                onSelectFocus: false,
                onSelect: () async {
                  // Wait for the dialog to return color selection result.
                  final Color newColor = await showColorPickerDialog(
                    // The dialog needs a context, we pass it in.
                    context,
                    // We use the dialogSelectColor, as its starting color.
                    surpriseColor,
                    title: Text('ColorPicker',
                        style: Theme.of(context).textTheme.titleLarge),
                    width: 40,
                    height: 40,

                    borderRadius: 4,
                    wheelDiameter: 165,
                    enableOpacity: true,
                    showColorCode: true,
                    colorCodeHasColor: false,
                    pickersEnabled: <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                    },
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: false,
                      pasteButton: false,
                      longPressMenu: true,
                    ),
                    actionButtons: const ColorPickerActionButtons(
                      okButton: true,
                      closeButton: true,
                      dialogActionButtons: false,
                    ),
                    transitionBuilder: (BuildContext context,
                        Animation<double> a1,
                        Animation<double> a2,
                        Widget widget) {
                      final double curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: widget,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 320, maxWidth: 320),
                  );
                  // We update the dialogSelectColor, to the returned result
                  // color. If the dialog was dismissed it actually returns
                  // the color we started with. The extra update for that
                  // below does not really matter, but if you want you can
                  // check if they are equal and skip the update below.
                  String newColorString = newColor.toString();
                  newColorString = newColorString.substring(10,16);
                  newColorString = "0xff" + newColorString;    
                  try{
                    CollectionReference colorPaletteCollection = firestore.collection('user').doc('jAwpP79Mg55elKzKXhqY').collection('color_palette');

                    print("SNAPSHOT: start");
                    QuerySnapshot querySnapshot = await colorPaletteCollection.where('emotion', isEqualTo: '놀람').get();
                    // print full snapshot
                    print("SNAPSHOT: ${querySnapshot.docs}");
                    for (QueryDocumentSnapshot document in querySnapshot.docs) {
                          String documentId = document.id;
                          print("documentId: " + documentId);
                          await colorPaletteCollection.doc(documentId).update({
                            'color': newColorString
                          });
                    };} catch (e) {
                      print("error: " + e.toString());
                    }


                  setState(() {
                    surpriseColor = newColor;
                  });
                }),
          ),

          //angryColor
          ListTile(
            title: const Text('분노'),
            subtitle: Text(
              // ignore: lines_longer_than_80_chars
              '${ColorTools.materialNameAndCode(angryColor, colorSwatchNameMap: colorsNameMap)} '
                  'aka ${ColorTools.nameThatColor(angryColor)}',
            ),
            trailing: ColorIndicator(
                width: 44,
                height: 44,
                borderRadius: 22,
                color: angryColor,
                elevation: 1,
                onSelectFocus: false,
                onSelect: () async {
                  // Wait for the dialog to return color selection result.
                  final Color newColor = await showColorPickerDialog(
                    // The dialog needs a context, we pass it in.
                    context,
                    // We use the dialogSelectColor, as its starting color.
                    angryColor,
                    title: Text('ColorPicker',
                        style: Theme.of(context).textTheme.titleLarge),
                    width: 40,
                    height: 40,

                    borderRadius: 4,
                    wheelDiameter: 165,
                    enableOpacity: true,
                    showColorCode: true,
                    colorCodeHasColor: false,
                    pickersEnabled: <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                    },
                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                      copyButton: false,
                      pasteButton: false,
                      longPressMenu: true,
                    ),
                    actionButtons: const ColorPickerActionButtons(
                      okButton: true,
                      closeButton: true,
                      dialogActionButtons: false,
                    ),
                    transitionBuilder: (BuildContext context,
                        Animation<double> a1,
                        Animation<double> a2,
                        Widget widget) {
                      final double curvedValue =
                          Curves.easeInOutBack.transform(a1.value) - 1.0;
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, curvedValue * 200, 0.0),
                        child: Opacity(
                          opacity: a1.value,
                          child: widget,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                    constraints: const BoxConstraints(
                        minHeight: 480, minWidth: 320, maxWidth: 320),
                  );
                  // We update the dialogSelectColor, to the returned result
                  // color. If the dialog was dismissed it actually returns
                  // the color we started with. The extra update for that
                  // below does not really matter, but if you want you can
                  // check if they are equal and skip the update below.
                  String newColorString = newColor.toString();
                  newColorString = newColorString.substring(10,16);
                  newColorString = "0xff" + newColorString;    
                  try{
                    CollectionReference colorPaletteCollection = firestore.collection('user').doc('jAwpP79Mg55elKzKXhqY').collection('color_palette');

                    print("SNAPSHOT: start");
                    QuerySnapshot querySnapshot = await colorPaletteCollection.where('emotion', isEqualTo: '분노').get();
                    // print full snapshot
                    print("SNAPSHOT: ${querySnapshot.docs}");
                    for (QueryDocumentSnapshot document in querySnapshot.docs) {
                          String documentId = document.id;
                          print("documentId: " + documentId);
                          await colorPaletteCollection.doc(documentId).update({
                            'color': newColorString
                          });
                    };} catch (e) {
                      print("error: " + e.toString());
                    }


                  setState(() {
                    angryColor = newColor;
                  });
                }),
          ),
          // Theme mode toggle

        ],
      ),
    );
  }
}