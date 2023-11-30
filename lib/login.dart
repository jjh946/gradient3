import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:google_sign_in/google_sign_in.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MaterialApp(home: Login()));
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 이미지
        Image.asset(
          'assets/login_background.png',
          fit: BoxFit.cover, // 이미지를 화면에 맞게 조정
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 200,
          child: GestureDetector(
            onTap: () async {
              final userCredential = await signInWithGoogle();
              if (userCredential != null) {
                // 구글 인증이 성공한 경우, TextApp 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => homeApp(),
                  ),
                );
              }
            },
            child: Image.asset(
              'assets/google_button.png', // 버튼 이미지 파일 경로
              width: 200, // 이미지 버튼의 너비
              height: 50, // 이미지 버튼의 높이
            ),
          ),
        ),
      ],
    );
  }

  Future<UserCredential?> signInWithGoogle() async {  //구글 인증
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    try {
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google 로그인에 실패했습니다: $e");
      return null;
    }
  }

}


