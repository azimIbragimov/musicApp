final entries = [
  Song(
    0,
    "Butter",
    "BTS",
    "https://upload.wikimedia.org/wikipedia/en/d/db/BTS_-_Butter.png",
    "Butter.mp3",
  ),
  Song(
      1,
      "Afterglow",
      "Ed Sheeran",
      "https://i2.wp.com/1acapella.com/wp-content/uploads/2021/05/Ed-Sheeran-Afterglow-Studio-Acapella.jpg?fit=600%2C600&ssl=1",
      "Afterglow.mp3"),
  Song(
      2,
      "Bad Habits",
      "Ed Sheeran",
      "https://images-na.ssl-images-amazon.com/images/I/714pe6yLuKS._SL1200_.jpg",
      "Bad-Habits.mp3"),
  Song(
      3,
      "Fake Love",
      "Bts",
      "https://ih1.redbubble.net/image.677006565.4911/flat,750x1000,075,f.u9.jpg",
      "fake-love.mp3"),
  Song(
      4,
      "Galway Girl",
      "Ed Sheeran",
      "https://i1.sndcdn.com/artworks-000590407391-kwkc1f-t500x500.jpg",
      "Galway-Girl.mp3"),
  Song(
      5,
      "Drivers Licence",
      "Olivia Rodrigez",
      "https://media.vanityfair.com/photos/60086d321cedef6c1950c802/master/pass/OliviaRodrigo-Erica%20Hernandez.jpg",
      "drivers-licence.mp3"),
  Song(
      6,
      "STAY",
      "Justin Bieber",
      "https://i.scdn.co/image/ab67616d0000b2738e6551a2944764bc8e33a960",
      "stay.mp3"),
  Song(
      7,
      "good 4 u",
      "Olivia Rodrigo",
      "https://upload.wikimedia.org/wikipedia/en/thumb/3/3e/Olivia_Rodrigo_-_Good_4_U.png/220px-Olivia_Rodrigo_-_Good_4_U.png",
      "good4u.mp3"),
  Song(
      8,
      "Beggin'",
      "ManeSkin",
      "https://i.scdn.co/image/ab67616d0000b273fa0ab3a28b5c52d8a5f97045",
      "beggin.mp3"),
  Song(
      9,
      "I WANNA BE YOUR SLAVE",
      "ManeSkin",
      "https://images.genius.com/ccdaea348e81db380b955fcb4a72b21d.1000x1000x1.png",
      "iwannabeyourslave.mp3")
];

class Song {
  static int notPlaying = 0;
  static int paused = 1;
  static int playing = 2;

  String name;
  String author;
  String url;
  String address;
  int isPlaying = Song.notPlaying;
  double completionProgress = 0.0;
  Duration currentMoment = Duration(seconds: 0);
  Duration duration;
  bool isLiked = false;
  String length;

  // Todo: Add indexes here
  int index;

  Song(this.index, this.name, this.author, this.url, this.address);

  String getName() {
    return this.name;
  }

  String getAuthor() {
    return this.author;
  }

  String getImage() {
    return this.url;
  }

  String getSongAdress() {
    return address;
  }

  int getStatus() {
    return isPlaying;
  }
}
