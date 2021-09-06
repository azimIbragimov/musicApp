import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicapp/database.dart';
import 'package:musicapp/google_sign_in_provider.dart';
import 'package:musicapp/loginpage.dart';
import 'package:musicapp/musicPage.dart';
import 'package:musicapp/registerPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static String id = '/homePage';
  static String imageURL =
      "https://images.unsplash.com/photo-1500462918059-b1a0cb512f1d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUp();
  }

  void setUp() async {
    MusicPage.prefs = await SharedPreferences.getInstance();

    for (var i = 0; i < entries.length; i++) {
      if (MusicPage.prefs.containsKey(entries[i].name + "IsLiked") == false) {
        MusicPage.prefs.setBool(entries[i].name + "IsLiked", false);
        entries[i].isLiked = false;
        print(entries[i].name + "IsLiked set to false");
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushNamed(context, MusicPage.id);
            });
          }
          return Material(
            type: MaterialType.transparency,
            child: (Stack(
              alignment: Alignment.center,
              children: [
                // This is background image
                ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black54.withOpacity(0.7), BlendMode.darken),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(HomePage.imageURL),
                              fit: BoxFit.cover)),
                    )),
                // This is column for buttons

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.music_note_sharp,
                                color: Colors.white,
                                size: 120,
                              ),
                              Text(
                                "Music\nWorld",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          CurvyButton(
                            colorButton: (Colors.green[800]),
                            text: "Login",
                            colorText: Colors.white54,
                            onTap: () {
                              Navigator.pushNamed(context, LoginPage.id);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CurvyButton(
                            colorButton: Colors.white60,
                            colorText: Colors.black54,
                            text: "Register",
                            onTap: () {
                              Navigator.pushNamed(context, RegisterPage.id);
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )),
          );
        });
  }
}

class CurvyButton extends StatelessWidget {
  Color colorButton;
  String text;
  Color colorText;
  final VoidCallback onTap;

  CurvyButton({this.colorButton, this.text, this.colorText, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: colorText, fontSize: 20, fontWeight: FontWeight.w400),
          ),
          height: 55,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: colorButton,
          ),
        ),
      ),
    );
  }
}
