import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../screens/account/favorite_manager.dart';
import 'dart:async';
import 'dart:ui';
import 'share_song.dart';
import 'song_model.dart';

class PlayerScreen extends StatefulWidget {
  final List<Map<String, String>> songs;
  final int currentIndex;

  const PlayerScreen({
    super.key,
    required this.songs,
    required this.currentIndex,
  });

  @override
  State<PlayerScreen> createState() =>
      _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  bool isPlaying = true;
  bool isFavorite = false;
  bool isLoop = false;
  double currentTime = 0;
  double totalTime = 188;
  late AnimationController _rotationController;
  Timer? _timer;

  late int currentIndex;
  Map<String, String> get currentSong =>
      widget.songs[currentIndex];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    startTimer();

    // 🔹 Kiểm tra bài hát hiện tại có nằm trong danh sách yêu thích không
    final song = SongModel(
      title: currentSong['title'] ?? '',
      artist: currentSong['artist'] ?? '',
      image: currentSong['img'] ?? '',
    );
    setState(() {
      isFavorite = FavoriteManager.isFavorite(song);
    });
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (isPlaying) {
          setState(() {
            currentTime += 1;
            if (currentTime >= totalTime) {
              if (isLoop) {
                currentTime = 0;
              } else {
                nextSong();
              }
            }
          });
        }
      },
    );
  }

  void nextSong() {
    setState(() {
      currentIndex =
          (currentIndex + 1) % widget.songs.length;
      currentTime = 0;
      isPlaying = true;
      _rotationController.repeat();
    });
  }

  void previousSong() {
    setState(() {
      currentIndex =
          (currentIndex - 1 + widget.songs.length) %
          widget.songs.length;
      currentTime = 0;
      isPlaying = true;
      _rotationController.repeat();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  String formatTime(double seconds) {
    int m = (seconds / 60).floor();
    int s = (seconds % 60).floor();
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final song = currentSong;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🌆 Nền mờ từ ảnh
          Image.asset(song['img']!, fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 25,
              sigmaY: 25,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () =>
                            Navigator.pop(context),
                      ),
                      const Text(
                        "Đang phát",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Ảnh nhạc xoay
                RotationTransition(
                  turns: _rotationController,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(180),
                    child: Image.asset(
                      song['img']!,
                      width: 280,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Thông tin bài hát
                Column(
                  children: [
                    Text(
                      song['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      song['artist'] ?? "",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 50,
                          ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white
                                  .withOpacity(0.9),
                              size: 28,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor:
                                    Colors.black87,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.vertical(
                                        top:
                                            Radius.circular(
                                              20,
                                            ),
                                      ),
                                ),
                                builder: (context) => Padding(
                                  padding:
                                      const EdgeInsets.all(
                                        16,
                                      ),
                                  child: Column(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min,
                                    children: [
                                      const Text(
                                        'Chia sẻ qua',
                                        style: TextStyle(
                                          color: Colors
                                              .white,
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      ListTile(
                                        leading: const FaIcon(
                                          FontAwesomeIcons
                                              .facebook,
                                          color: Colors
                                              .white,
                                        ),
                                        title: const Text(
                                          'Facebook',
                                          style: TextStyle(
                                            color: Colors
                                                .white70,
                                          ),
                                        ),
                                        onTap: () {
                                          shareSong(
                                            title:
                                                song['title'] ??
                                                'Bài hát',
                                            artist:
                                                song['artist'] ??
                                                'Không rõ',
                                            platform:
                                                'facebook',
                                          );
                                          Navigator.pop(
                                            context,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const FaIcon(
                                          FontAwesomeIcons
                                              .facebookMessenger,
                                          color: Colors
                                              .blueAccent,
                                        ),
                                        title: const Text(
                                          'Messenger',
                                          style: TextStyle(
                                            color: Colors
                                                .white70,
                                          ),
                                        ),
                                        onTap: () {
                                          shareSong(
                                            title:
                                                song['title'] ??
                                                'Bài hát',
                                            artist:
                                                song['artist'] ??
                                                'Không rõ',
                                            platform:
                                                'messenger',
                                          );
                                          Navigator.pop(
                                            context,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const FaIcon(
                                          FontAwesomeIcons
                                              .instagram,
                                          color: Colors
                                              .pinkAccent,
                                        ),
                                        title: const Text(
                                          'Instagram',
                                          style: TextStyle(
                                            color: Colors
                                                .white70,
                                          ),
                                        ),
                                        onTap: () {
                                          shareSong(
                                            title:
                                                song['title'] ??
                                                'Bài hát',
                                            artist:
                                                song['artist'] ??
                                                'Không rõ',
                                            platform:
                                                'instagram',
                                          );
                                          Navigator.pop(
                                            context,
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const FaIcon(
                                          FontAwesomeIcons
                                              .commentDots,
                                          color: Colors
                                              .greenAccent,
                                        ),
                                        title: const Text(
                                          'Zalo',
                                          style: TextStyle(
                                            color: Colors
                                                .white70,
                                          ),
                                        ),
                                        onTap: () {
                                          shareSong(
                                            title:
                                                song['title'] ??
                                                'Bài hát',
                                            artist:
                                                song['artist'] ??
                                                'Không rõ',
                                            platform:
                                                'zalo',
                                          );
                                          Navigator.pop(
                                            context,
                                          );
                                        },
                                      ),

                                      const Divider(
                                        color: Colors
                                            .white24,
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons
                                              .more_horiz,
                                          color: Colors
                                              .white,
                                        ),
                                        title: const Text(
                                          'Khác...',
                                          style: TextStyle(
                                            color: Colors
                                                .white70,
                                          ),
                                        ),
                                        onTap: () {
                                          shareSong(
                                            title:
                                                song['title'] ??
                                                'Bài hát',
                                            artist:
                                                song['artist'] ??
                                                'Không rõ',
                                          );
                                          Navigator.pop(
                                            context,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons
                                        .favorite_border_outlined,
                              color: isFavorite
                                  ? Colors.purpleAccent
                                  : Colors.white70,
                              size: 28,
                            ),
                            onPressed: () async {
                              final song = SongModel(
                                title:
                                    currentSong['title'] ??
                                    '',
                                artist:
                                    currentSong['artist'] ??
                                    '',
                                image:
                                    currentSong['img'] ??
                                    '',
                              );

                              await FavoriteManager.toggleFavorite(
                                song,
                              );
                              final fav =
                                  await FavoriteManager.isFavorite(
                                    song,
                                  );

                              setState(
                                () => isFavorite = fav,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Thanh tiến trình
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Column(
                    children: [
                      Slider(
                        value: currentTime,
                        min: 0,
                        max: totalTime,
                        onChanged: (v) => setState(
                          () => currentTime = v,
                        ),
                        activeColor: Colors.white,
                        inactiveColor: Colors.white24,
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Text(
                            formatTime(currentTime),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            formatTime(totalTime),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Nút điều khiển
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 25,
                    top: 5,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.shuffle,
                          color: Colors.purpleAccent
                              .withOpacity(0.8),
                          size: 22,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: previousSong,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPlaying = !isPlaying;
                            if (isPlaying) {
                              _rotationController
                                  .repeat();
                            } else {
                              _rotationController
                                  .stop();
                            }
                          });
                        },
                        child: Icon(
                          isPlaying
                              ? Icons
                                    .pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: nextSong,
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.repeat,
                          color: isLoop
                              ? Colors.purpleAccent
                              : Colors.white
                                    .withOpacity(0.7),
                          size: 22,
                        ),
                        onPressed: () => setState(
                          () => isLoop = !isLoop,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
