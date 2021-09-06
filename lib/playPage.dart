import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'database.dart';
import 'musicPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayPage extends StatefulWidget {
  static String id = "/playPage";
  Song currentSong;
  PlayPage({Key key, this.currentSong}) : super(key: key);

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  double songProgress = 0;
  bool showProgress;

  Future<int> loadFile() {
    try {
      return MusicPage.audioCache
          .load(widget.currentSong.address)
          .then((value) {})
          .then((value) => MusicPage.audioPlayer.getDuration());
    } catch (e) {}
    ;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void setup() async {
    MusicPage.audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        widget.currentSong.duration = d;
      });

      MusicPage.audioPlayer.onAudioPositionChanged.listen((p) {
        setState(() {
          widget.currentSong.currentMoment = p;
          songProgress = widget.currentSong.currentMoment.inSeconds /
              widget.currentSong.duration.inSeconds;
          widget.currentSong.completionProgress = songProgress;
          if (widget.currentSong.currentMoment == widget.currentSong.duration) {
            widget.currentSong.currentMoment = Duration(seconds: 0);
            widget.currentSong.isPlaying = Song.notPlaying;
            widget.currentSong = entries[widget.currentSong.index + 1];
            widget.currentSong.isPlaying = Song.playing;
            MusicPage.audioCache.play(widget.currentSong.address);
          }
        });
      });

      MusicPage.audioPlayer.onSeekComplete.listen((event) {
        print("Music is over");
        setState(() {
          widget.currentSong.currentMoment = Duration(seconds: 0);
          widget.currentSong.isPlaying = Song.notPlaying;
          widget.currentSong = entries[widget.currentSong.index + 1];
          widget.currentSong.isPlaying = Song.playing;
        });
      });
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();

    new Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios_new_sharp),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MusicPage()),
                );
              },
            ),
            elevation: 0,
          ),
          body: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black54.withOpacity(0.6), BlendMode.darken),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.indigo[200]),
                    )),
                Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.only(top: 100),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              widget.currentSong.url != null
                                  ? Image(
                                      image:
                                          NetworkImage(widget.currentSong.url),
                                      height: 300,
                                      width: 300,
                                    )
                                  : Container(
                                      width: 300,
                                      height: 300,
                                    ),
                            ]),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.transparent),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.currentSong.getName(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              widget.currentSong.getAuthor(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (widget
                                                        .currentSong.isLiked ==
                                                    true) {
                                                  widget.currentSong.isLiked =
                                                      false;
                                                } else {
                                                  widget.currentSong.isLiked =
                                                      true;
                                                }

                                                await MusicPage.prefs.setBool(
                                                    (widget.currentSong.name +
                                                        "IsLiked"),
                                                    widget.currentSong.isLiked);
                                                setState(() {});
                                              },
                                              child: GestureDetector(
                                                onTap: () async {
                                                  if (widget
                                                      .currentSong.isLiked) {
                                                    widget.currentSong.isLiked =
                                                        false;
                                                  } else {
                                                    widget.currentSong.isLiked =
                                                        true;
                                                  }

                                                  MusicPage.prefs.setBool(
                                                      widget.currentSong.name +
                                                          "IsLiked",
                                                      widget
                                                          .currentSong.isLiked);

                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  MusicPage.prefs.getBool(widget
                                                              .currentSong
                                                              .name +
                                                          "IsLiked")
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.white,
                                                  size: 45,
                                                ),
                                              ),
                                            ),
                                          ]),
                                    )
                                  ]),
                              SizedBox(
                                height: 40,
                              ),
                              Visibility(
                                visible: widget.currentSong.isPlaying ==
                                        Song.notPlaying
                                    ? false
                                    : true,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                widget.currentSong
                                                            .currentMoment ==
                                                        null
                                                    ? "0:00"
                                                    : widget.currentSong
                                                        .currentMoment
                                                        .toString()
                                                        .split(".")[0]
                                                        .substring(3),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16),
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                widget.currentSong.duration
                                                    .toString()
                                                    .split(".")[0]
                                                    .substring(3),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16),
                                                textAlign: TextAlign.left,
                                              )
                                            ]),
                                      ),
                                      LinearProgressIndicator(
                                        color: Colors.white,
                                        backgroundColor: Colors.grey,
                                        value: widget
                                            .currentSong.completionProgress,
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      try {
                                        if (widget.currentSong.isPlaying ==
                                            Song.playing) {
                                          widget.currentSong.isPlaying =
                                              Song.notPlaying;
                                          widget.currentSong = entries[widget
                                                      .currentSong.index ==
                                                  entries.first.index
                                              ? entries.last.index
                                              : widget.currentSong.index - 1];
                                          widget.currentSong.isPlaying =
                                              Song.playing;
                                          MusicPage.audioCache
                                              .play(widget.currentSong.address);
                                        } else {
                                          widget.currentSong = entries[widget
                                                      .currentSong.index ==
                                                  entries.first.index
                                              ? entries.last.index
                                              : widget.currentSong.index - 1];
                                        }
                                      } catch (e) {}
                                    },
                                    child: Icon(
                                      Icons.skip_previous_rounded,
                                      size: 100,
                                      color: Colors.green[400],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (widget.currentSong.isPlaying ==
                                          Song.notPlaying) {
                                        for (var i = 0;
                                            i < entries.length;
                                            i++) {
                                          entries[i].isPlaying =
                                              Song.notPlaying;
                                          entries[i].completionProgress = 0.0;
                                        }
                                        MusicPage.audioCache
                                            .play(widget.currentSong.address);
                                        widget.currentSong.isPlaying =
                                            Song.playing;
                                        showProgress = true;
                                      } else if (widget.currentSong.isPlaying ==
                                          Song.playing) {
                                        MusicPage.audioPlayer.pause();
                                        widget.currentSong.isPlaying =
                                            Song.paused;
                                        showProgress = false;
                                      } else if (widget.currentSong.isPlaying ==
                                          Song.paused) {
                                        MusicPage.audioPlayer.resume();
                                        widget.currentSong.isPlaying =
                                            Song.playing;
                                        showProgress = true;
                                      }

                                      setState(() {});
                                    },
                                    child: Icon(
                                      widget.currentSong.isPlaying ==
                                              Song.playing
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: 100,
                                      color: Colors.green[400],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      try {
                                        if (widget.currentSong.isPlaying ==
                                            Song.playing) {
                                          widget.currentSong.isPlaying =
                                              Song.notPlaying;
                                          widget.currentSong = entries[widget
                                                      .currentSong.index ==
                                                  entries.last.index
                                              ? 0
                                              : widget.currentSong.index + 1];
                                          widget.currentSong.isPlaying =
                                              Song.playing;
                                          MusicPage.audioCache
                                              .play(widget.currentSong.address);
                                        } else {
                                          widget.currentSong = entries[widget
                                                      .currentSong.index ==
                                                  entries.last.index
                                              ? 0
                                              : widget.currentSong.index + 1];
                                        }
                                      } catch (e) {}
                                    },
                                    child: Icon(
                                      Icons.skip_next_rounded,
                                      size: 100,
                                      color: Colors.green[400],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 0,
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
