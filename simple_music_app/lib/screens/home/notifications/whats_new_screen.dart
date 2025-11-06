import 'package:flutter/material.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../player/player_screen.dart';
import '../../../player/song_model.dart';
import '../../account/favorite_manager.dart';

class WhatsNewScreen extends StatefulWidget {
  const WhatsNewScreen({super.key});

  @override
  State<WhatsNewScreen> createState() =>
      _WhatsNewScreenState();
}

class _WhatsNewScreenState
    extends State<WhatsNewScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allSongs = [
      {
        "image": "imgs/Người_Đầu_Tiên.jpg",
        "title": "Người Đầu Tiên",
        "artist": "Juky San",
        "date": DateTime.now(),
      },
      {
        "image": "imgs/Mất_Kết_Nối.jpg",
        "title": "Mất Kết Nối",
        "artist": "Dương Domic",
        "date": DateTime.now().subtract(
          const Duration(days: 1),
        ),
      },
      {
        "image": "imgs/Vũ.jpg",
        "title": "Bình Yên",
        "artist": "Vũ.",
        "date": DateTime(2024, 10, 12),
      },
      {
        "image": "imgs/HIEUTHUHAI.jpg",
        "title": "Vệ tinh",
        "artist": "HIEUTHUHAI",
        "date": DateTime(2024, 7, 5),
      },
      {
        "image": "imgs/QuanAP.jpg",
        "title": "Bông hoa đẹp nhất",
        "artist": "Quân A.P.",
        "date": DateTime(2024, 5, 15),
      },
    ];

    final today = DateTime.now();
    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    final todaySongs = allSongs
        .where(
          (s) => DateUtils.isSameDay(s['date'], today),
        )
        .toList();
    final yesterdaySongs = allSongs
        .where(
          (s) => DateUtils.isSameDay(
            s['date'],
            yesterday,
          ),
        )
        .toList();
    final earlierSongs = allSongs
        .where(
          (s) => (s['date'] as DateTime).isBefore(
            yesterday,
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor,
      body: Column(
        children: [
          // 🟢 PHẦN TIÊU ĐỀ
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 18,
              left: 16,
              right: 16,
              bottom: 5,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Color.fromARGB(255, 253, 206, 237),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(
                          context,
                        ).iconTheme.color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(
                        context,
                      ).whatsNew,
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.bold,
                              ) ??
                          const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildTab(
                      AppLocalizations.of(
                        context,
                      ).songsTab,
                      true,
                    ),
                    const SizedBox(width: 25),
                    _buildTab(
                      AppLocalizations.of(
                        context,
                      ).albumTab,
                      false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🟢 DANH SÁCH BÀI HÁT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (todaySongs.isNotEmpty) ...[
                    Text(
                      AppLocalizations.of(
                        context,
                      ).today,
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ) ??
                          const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: todaySongs.map((song) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                                bottom: 16,
                              ),
                          child: _buildMusicCard(
                            context: context,
                            image: song["image"],
                            title: song["title"],
                            artist: song["artist"],
                            date: DateFormat(
                              'MMM d',
                            ).format(song["date"]),
                            allSongs: allSongs,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (yesterdaySongs.isNotEmpty) ...[
                    Text(
                      AppLocalizations.of(
                        context,
                      ).yesterday,
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ) ??
                          const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: yesterdaySongs.map((
                        song,
                      ) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                                bottom: 16,
                              ),
                          child: _buildMusicCard(
                            context: context,
                            image: song["image"],
                            title: song["title"],
                            artist: song["artist"],
                            date: DateFormat(
                              'MMM d',
                            ).format(song["date"]),
                            allSongs: allSongs,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (earlierSongs.isNotEmpty) ...[
                    Text(
                      AppLocalizations.of(
                        context,
                      ).earlier,
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ) ??
                          const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: earlierSongs.map((
                        song,
                      ) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                                bottom: 16,
                              ),
                          child: _buildMusicCard(
                            context: context,
                            image: song["image"],
                            title: song["title"],
                            artist: song["artist"],
                            date: DateFormat(
                              'MMM d',
                            ).format(song["date"]),
                            allSongs: allSongs,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟣 Tab
  Widget _buildTab(String text, bool isSelected) {
    return Column(
      children: [
        Text(
          text,
          style:
              Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ) ??
              TextStyle(
                fontSize: 16,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 3,
            width: 50,
            color:
                Theme.of(
                  context,
                ).textTheme.titleMedium?.color ??
                Colors.black,
          ),
      ],
    );
  }

  // 🟣 Card bài hát (đã thêm tim)
  Widget _buildMusicCard({
    required BuildContext context,
    required String image,
    required String title,
    required String artist,
    required String date,
    required List<Map<String, dynamic>> allSongs,
  }) {
    final songModel = SongModel(
      title: title,
      artist: artist,
      image: image,
    );

    return ValueListenableBuilder(
      valueListenable: FavoriteManager.favoriteSongs,
      builder: (context, favorites, _) {
        final isFavorite = FavoriteManager.isFavorite(
          songModel,
        );

        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // 🔹 Tạo danh sách toàn bộ bài hát dưới dạng Map
            final songsList = allSongs
                .map(
                  (s) => {
                    'title': s['title'] as String,
                    'artist': s['artist'] as String,
                    'img': s['image'] as String,
                  },
                )
                .toList();

            // 🔹 Xác định vị trí bài hát hiện tại trong danh sách
            final currentIndex = songsList.indexWhere(
              (s) => s['title'] == title,
            );

            // 🔹 Mở PlayerScreen với danh sách và vị trí hiện tại
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlayerScreen(
                  songs: songsList,
                  currentIndex: currentIndex,
                ),
              ),
            );
          },

          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).brightness ==
                          Brightness.light
                      ? Colors.grey.withOpacity(0.15)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  child: Image.asset(
                    image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style:
                            Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).hintColor,
                                  fontSize: 12,
                                ) ??
                            const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style:
                            Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ) ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                      ),
                      Text(
                        artist,
                        style:
                            Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withOpacity(
                                            0.7,
                                          ) ??
                                      Colors.black54,
                                  fontSize: 13,
                                ) ??
                            const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Single",
                        style:
                            Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).hintColor,
                                  fontSize: 12,
                                ) ??
                            const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: isFavorite
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () {
                    FavoriteManager.toggleFavorite(
                      songModel,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? "Đã xóa '$title' khỏi danh sách yêu thích"
                              : "Đã thêm '$title' vào danh sách yêu thích",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
