import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home.dart';


void main() => runApp(socialShare());

class socialShare extends StatefulWidget {
  @override
  _socialShareState createState() => _socialShareState();
}

class _socialShareState extends State<socialShare> {
  String facebookId = "255052714235461";

  var imageBackground ="images/background.jpg";
  String imageBackgroundPath = "";
  String videoBackgroundPath = "";

  @override
  void initState() {
    super.initState();
    copyBundleAssets();
  }

  Future<void> copyBundleAssets() async {
    imageBackgroundPath = await copyImage(imageBackground);
    //videoBackgroundPath = await copyImage(videoBackground);
    print('imageBackgroundPath: '+imageBackgroundPath);
  }

  Future<String> copyImage(String filename) async {
    final tempDir = await getTemporaryDirectory();
    ByteData bytes = await rootBundle.load("assets/$filename");
    final assetPath = '${tempDir.path}/$filename';
    File file = await File(assetPath).create(recursive: true);
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file.path;
  }

  Future<String?> pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    var path = file?.path;
    if (path == null) {
      return null;
    }
    return file?.path;
  }

  Future<String?> screenshot() async {
    var data = await screenshotController.capture();
    if (data == null) {
      return null;
    }

    Directory tempDir = await getTemporaryDirectory();
    new Directory(tempDir.path+'/'+'dir').create(recursive: true);
    print('Path of New Dir: '+tempDir.path);
    final assetPath = '${tempDir.path}/temp.png';
    File file = await File(assetPath).create();
    await file.writeAsBytes(data);
    return file.path;
  }

  Future<void> requestPermissions() async {
    // 알림 권한 확인 및 요청
    var notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      await Permission.notification.request();
    }

    //https://pub.dev/documentation/permission_handler/11.1.0/permission_handler/Permission/storage-constant.html

    //저장소요청
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    // 사진 ,카메라 권한
    var cameraStatus = await Permission.camera.status;
    var photosStatus = await Permission.photos.status;

    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }

    if (!photosStatus.isGranted) {
      await Permission.photos.request();
    }
  }


  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Social Share'),
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Instagram",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 40),
                      ElevatedButton(
                        child: Icon(Icons.gradient),
                        onPressed: () async {
                          requestPermissions();
                          var path = await screenshot();
                          if (path == null) {
                            return;
                          }
                          SocialShare.shareInstagramStory(
                            appId: facebookId,
                            imagePath: path,
                            backgroundTopColor: "#ffffff",
                            backgroundBottomColor: "#000000",
                            backgroundResourcePath: imageBackgroundPath,
                            attributionURL: "instagram://app"
                          ).then((data) {
                            print(data);
                          });
                        },
                      ),
                                          ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}