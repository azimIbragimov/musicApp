import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'homepage.dart';
import 'database.dart';
import 'package:audioplayers/audioplayers.dart';
import 'playPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicPage extends StatefulWidget {
  static AudioPlayer audioPlayer = AudioPlayer();
  static AudioCache audioCache = AudioCache(fixedPlayer: audioPlayer);
  static Duration currentMoment;
  static Duration durationSong;
  static SharedPreferences prefs;

  static String id = "/musicPage";
  static String imageURL =
      "https://images.unsplash.com/photo-1535992165812-68d1861aa71e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=937&q=80";

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final user = FirebaseAuth.instance.currentUser;

  void sharedSetUp() async {
    MusicPage.prefs = await SharedPreferences.getInstance();

    for (var i = 0; i < entries.length; i++) {
      if (MusicPage.prefs.containsKey(entries[i].name + "IsLiked")) {
        entries[i].isLiked =
            MusicPage.prefs.getBool(entries[i].name + "IsLiked");
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedSetUp();
  }

  @override
  void dispose() {
    super.dispose();
    MusicPage.audioPlayer.release();
    MusicPage.audioPlayer.dispose();
  }

  Future<int> loadFile(Song song) {
    return MusicPage.audioCache.load(song.address).then((value) {
      print(value);
    }).then((value) => MusicPage.audioPlayer.getDuration());
  }

  playMusic(Song path) async {
    await loadFile(path);
    await MusicPage.audioCache.loop(path.address);
  }

  pause() async {
    MusicPage.audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.black54.withOpacity(0.5), BlendMode.darken),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(MusicPage.imageURL),
                          fit: BoxFit.cover)),
                )),
            Stack(
              children: [
                ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayPage(
                                      currentSong: entries[index],
                                    )),
                          ).then((value) {
                            setState(() {
                              print(entries[index].completionProgress);
                            });
                          });

                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.all(20),
                          height: 100,
                          color: Colors.grey.withOpacity(0.7),
                          child: Column(children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 5,
                                                child: Container(
                                                  margin: EdgeInsets.all(10),
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              entries[index]
                                                                  .getImage()),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 10,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 0, 0),
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            entries[index]
                                                                .getName(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            softWrap: false,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                        Text(
                                                          entries[index]
                                                              .getAuthor(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                          textAlign:
                                                              TextAlign.start,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 30.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (entries[index].isLiked) {
                                                entries[index].isLiked = false;
                                              } else {
                                                entries[index].isLiked = true;
                                              }

                                              MusicPage.prefs.setBool(
                                                  entries[index].name +
                                                      "IsLiked",
                                                  entries[index].isLiked);

                                              setState(() {});
                                            },
                                            child: Icon(
                                                entries[index].isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.white70,
                                                size: 35),
                                          ),
                                        ))
                                  ]),
                            ),
                          ]),
                        ),
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
