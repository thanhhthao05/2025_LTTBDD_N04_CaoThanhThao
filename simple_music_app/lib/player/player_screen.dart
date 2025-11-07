import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/account/favorite_manager.dart';
import '../screens/song_options_menu.dart';
import 'dart:async';
import 'dart:ui';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';
import 'share_song.dart';
import 'song_model.dart';
import 'recently_played_manager.dart';

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
    _checkFavorite();
    // Register the currently playing song in recently played
    final s = SongModel(
      title: currentSong['title'] ?? '',
      artist: currentSong['artist'] ?? '',
      image: currentSong['img'] ?? '',
    );
    RecentlyPlayedManager.instance.add(s);
  }

  Future<void> _checkFavorite() async {
    final song = SongModel(
      title: currentSong['title'] ?? '',
      artist: currentSong['artist'] ?? '',
      image: currentSong['img'] ?? '',
    );
    final fav = await FavoriteManager.isFavorite(song);
    setState(() => isFavorite = fav);
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
    _checkFavorite();
    // add to recently played
    final s = SongModel(
      title: currentSong['title'] ?? '',
      artist: currentSong['artist'] ?? '',
      image: currentSong['img'] ?? '',
    );
    RecentlyPlayedManager.instance.add(s);
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
    _checkFavorite();
    // add to recently played
    final s = SongModel(
      title: currentSong['title'] ?? '',
      artist: currentSong['artist'] ?? '',
      image: currentSong['img'] ?? '',
    );
    RecentlyPlayedManager.instance.add(s);
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
                      Text(
                        AppLocalizations.of(
                          context,
                        ).nowPlaying,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      // 🔹 Menu ⋮ (SongOptionsMenu)
                      SongOptionsMenu(
                        song: {
                          'title':
                              currentSong['title'] ??
                              '',
                          'artist':
                              currentSong['artist'] ??
                              '',
                          'img':
                              currentSong['img'] ?? '',
                        },
                        onPlay: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                ).playingSongSnackbar,
                              ),
                            ),
                          );
                        },
                        onAddToPlaylist: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                ).addedToPlaylistShort,
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                ).removedFromPlaylist,
                              ),
                            ),
                          );
                        },
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

                    // Nút chia sẻ & yêu thích
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
                          // Nút chia sẻ
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white
                                  .withOpacity(0.9),
                              size: 28,
                            ),
                            onPressed: () {
                              shareSong(
                                title:
                                    song['title'] ??
                                    'Bài hát',
                                artist:
                                    song['artist'] ??
                                    'Không rõ',
                              );
                            },
                          ),

                          // Nút yêu thích
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
                              final s = SongModel(
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

                              // Nếu bài đang là yêu thích → xóa
                              if (await FavoriteManager.isFavorite(
                                s,
                              )) {
                                await FavoriteManager.removeFavorite(
                                  s,
                                );
                                setState(() {
                                  isFavorite = false;
                                });
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Đã xóa khỏi danh sách yêu thích ❤️',
                                    ),
                                  ),
                                );
                              } else {
                                // Nếu chưa có → thêm
                                await FavoriteManager.addFavorite(
                                  s,
                                );
                                setState(() {
                                  isFavorite = true;
                                });
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Đã thêm vào danh sách yêu thích ❤️',
                                    ),
                                  ),
                                );
                              }
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

                // Nút điều khiển nhạc
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
