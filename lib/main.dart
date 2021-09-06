import 'package:flutter/material.dart';
import 'package:musicapp/loginpage.dart';
import 'package:musicapp/playPage.dart';
import 'homepage.dart';
import 'registerPage.dart';
import 'package:provider/provider.dart';
import 'google_sign_in_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'musicPage.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: Colors.transparent,
      child: Text(
        details.toString(),
        style: TextStyle(fontSize: 1.0, color: Colors.transparent),
      ),
    );
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MusicApp());
}

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => SignInProvider(),
      child: MaterialApp(
        routes: {
          HomePage.id: (context) => HomePage(),
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          MusicPage.id: (context) => MusicPage(),
          PlayPage.id: (context) => PlayPage()
        },
        initialRoute: HomePage.id,
      ));
}
