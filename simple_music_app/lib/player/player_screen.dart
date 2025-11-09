import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
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
  bool isPlaying = false;
  bool isFavorite = false;
  bool isLoop = false;
  double currentTime = 0;
  double totalTime = 0;
  late AnimationController _rotationController;
  Timer? _timer;
  late AudioPlayer _audioPlayer;
  String? _errorMessage;

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
    );

    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
    _setupAudioListeners();

    _checkFavorite();
    // Register the currently playing song in recently played
    // Use post-frame callback to avoid updating ValueNotifier during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = SongModel(
        title: currentSong['title'] ?? '',
        artist: currentSong['artist'] ?? '',
        image: currentSong['img'] ?? '',
      );
      RecentlyPlayedManager.instance.add(s);
    });
  }

  void _setupAudioListeners() {
    _audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          currentTime = position.inSeconds.toDouble();
        });
      }
    });

    _audioPlayer.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() {
          totalTime = duration.inSeconds.toDouble();
        });
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
          if (isPlaying) {
            _rotationController.repeat();
          } else {
            _rotationController.stop();
          }
        });

        // Auto next song when finished
        if (state.processingState ==
            ProcessingState.completed) {
          if (isLoop) {
            _audioPlayer.seek(Duration.zero);
            _audioPlayer.play();
          } else {
            nextSong();
          }
        }
      }
    });
  }

  Future<void> _initAudioPlayer() async {
    String? audioUrl = currentSong['previewUrl'];

    // Nếu không có preview URL, hiển thị thông báo lỗi
    if (audioUrl == null || audioUrl.isEmpty) {
      setState(() {
        _errorMessage =
            'Không có bản xem trước cho bài hát này';
        totalTime = 0;
        isPlaying = false;
      });
      return;
    }

    try {
      // Nếu là file local từ folder mock, sử dụng AssetSource
      if (audioUrl.startsWith('lib/mock/')) {
        // Với Flutter assets, đường dẫn asset phải khớp với cấu trúc folder
        // Nếu pubspec.yaml khai báo lib/mock/, thì asset path là lib/mock/...
        await _audioPlayer.setAsset(audioUrl);
      } else {
        // Nếu là URL từ Spotify hoặc URL khác
        await _audioPlayer.setUrl(audioUrl);
      }
      setState(() {
        _errorMessage = null;
      });
      // Auto play on load
      await _audioPlayer.play();
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể phát bài hát: $e';
        totalTime = 0;
        isPlaying = false;
      });
    }
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

  Future<void> nextSong() async {
    await _audioPlayer.stop();
    setState(() {
      currentIndex =
          (currentIndex + 1) % widget.songs.length;
      currentTime = 0;
    });
    await _initAudioPlayer();
    _checkFavorite();
    // add to recently played (use post-frame callback to avoid build issues)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = SongModel(
        title: currentSong['title'] ?? '',
        artist: currentSong['artist'] ?? '',
        image: currentSong['img'] ?? '',
      );
      RecentlyPlayedManager.instance.add(s);
    });
  }

  Future<void> previousSong() async {
    await _audioPlayer.stop();
    setState(() {
      currentIndex =
          (currentIndex - 1 + widget.songs.length) %
          widget.songs.length;
      currentTime = 0;
    });
    await _initAudioPlayer();
    _checkFavorite();
    // add to recently played (use post-frame callback to avoid build issues)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = SongModel(
        title: currentSong['title'] ?? '',
        artist: currentSong['artist'] ?? '',
        image: currentSong['img'] ?? '',
      );
      RecentlyPlayedManager.instance.add(s);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(double seconds) {
    int m = (seconds / 60).floor();
    int s = (seconds % 60).floor();
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  Widget _buildBackgroundImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[900],
          child: const Center(
            child: Icon(
              Icons.music_note,
              size: 100,
              color: Colors.white30,
            ),
          ),
        ),
      );
    }
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey[900],
        child: const Center(
          child: Icon(
            Icons.music_note,
            size: 100,
            color: Colors.white30,
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumImage(
    String imageUrl, {
    required double width,
    required double height,
  }) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: Colors.grey[800],
          child: const Icon(
            Icons.music_note,
            size: 80,
            color: Colors.white30,
          ),
        ),
      );
    }
    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: Colors.grey[800],
        child: const Icon(
          Icons.music_note,
          size: 80,
          color: Colors.white30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final song = currentSong;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(song['img']!),
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
                    child: _buildAlbumImage(
                      song['img']!,
                      width: 280,
                      height: 280,
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
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(
                          16,
                        ),
                        margin:
                            const EdgeInsets.symmetric(
                              horizontal: 32,
                            ),
                        decoration: BoxDecoration(
                          color: Colors.orange
                              .withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                          border: Border.all(
                            color: Colors.orange
                                .withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.music_off,
                              color: Colors.orange,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                              textAlign:
                                  TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Bài hát này chưa có file audio',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              textAlign:
                                  TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  Navigator.pop(
                                    context,
                                  ),
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 18,
                              ),
                              label: const Text(
                                'Chọn bài khác',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.orange,
                                foregroundColor:
                                    Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        20,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                        value: currentTime.clamp(
                          0.0,
                          totalTime > 0
                              ? totalTime
                              : 1.0,
                        ),
                        min: 0,
                        max: totalTime > 0
                            ? totalTime
                            : 1.0,
                        onChanged: (v) async {
                          setState(
                            () => currentTime = v,
                          );
                          await _audioPlayer.seek(
                            Duration(
                              seconds: v.toInt(),
                            ),
                          );
                        },
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
                        onTap: () async {
                          if (_errorMessage != null) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _errorMessage!,
                                ),
                                backgroundColor:
                                    Colors.red,
                              ),
                            );
                            return;
                          }
                          if (isPlaying) {
                            await _audioPlayer.pause();
                          } else {
                            await _audioPlayer.play();
                          }
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
