class SongModel {
  final String title;
  final String artist;
  final String image;

  SongModel({
    required this.title,
    required this.artist,
    required this.image,
  });

  Map<String, String> toMap() {
    return {
      'title': title,
      'artist': artist,
      'img': image,
    };
  }
}
