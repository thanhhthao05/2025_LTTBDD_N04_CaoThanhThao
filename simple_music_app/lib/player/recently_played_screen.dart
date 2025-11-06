import 'package:flutter/material.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';
import './song_model.dart';
import './player_screen.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() =>
      _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState
    extends State<RecentlyPlayedScreen> {
  final Map<String, List<SongModel>> recentlyPlayed =
      {};

  @override
  void initState() {
    super.initState();

    final today = _formatDateKey(DateTime.now());
    final yesterday = _formatDateKey(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    recentlyPlayed[today] = [
      SongModel(
        title: "Hẹn Gặp Em Dưới Ánh Trăng",
        artist: "Hurrykng, HieuThuHai, Manbo",
        image: "imgs/Hẹn_Gặp_Em_Dưới_Ánh_Trăng.jpg",
      ),
      SongModel(
        title: "Perfect",
        artist: "Shiki",
        image: "imgs/Perfect.jpg",
      ),
    ];

    recentlyPlayed[yesterday] = [
      SongModel(
        title: "Ngủ Một Mình",
        artist: "HIEUTHUHAI",
        image: "imgs/HIEUTHUHAI.jpg",
      ),
    ];
  }

  /// Định dạng ngày dạng dd/MM/yyyy
  String _formatDateKey(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  /// 🧩 Thêm bài hát mới — tự động di chuyển hôm nay -> hôm qua
  void _addSong(SongModel newSong) {
    final today = _formatDateKey(DateTime.now());
    final yesterdayDate = DateTime.now().subtract(
      const Duration(days: 1),
    );
    final yesterdayKey = _formatDateKey(yesterdayDate);

    setState(() {
      // Nếu có "hôm nay" thì chuyển nó sang "hôm qua"
      if (recentlyPlayed.containsKey(today)) {
        final oldTodaySongs = recentlyPlayed[today]!;

        // Gộp với hôm qua nếu trùng key
        if (recentlyPlayed.containsKey(yesterdayKey)) {
          recentlyPlayed[yesterdayKey]!.insertAll(
            0,
            oldTodaySongs,
          );
        } else {
          recentlyPlayed[yesterdayKey] = List.from(
            oldTodaySongs,
          );
        }

        recentlyPlayed.remove(today);
      }

      // Tạo danh sách mới cho hôm nay chỉ có bài mới
      recentlyPlayed[today] = [newSong];
    });
  }

  void _showAddSongDialog() {
    final titleController = TextEditingController();
    final artistController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).addNewSong,
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Tên bài hát",
                ),
              ),
              TextField(
                controller: artistController,
                decoration: const InputDecoration(
                  labelText: "Nghệ sĩ",
                ),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: "Ảnh (VD: imgs/song.jpg)",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context).cancel,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  artistController.text.isNotEmpty) {
                _addSong(
                  SongModel(
                    title: titleController.text,
                    artist: artistController.text,
                    image:
                        imageController.text.isNotEmpty
                        ? imageController.text
                        : "imgs/default.jpg",
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Text(
              AppLocalizations.of(context).add,
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(
    BuildContext context,
    String dateKey,
  ) {
    final now = DateTime.now();
    final parts = dateKey.split('/');
    if (parts.length != 3) return dateKey;

    final date = DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
    final diff = now.difference(date).inDays;

    if (diff == 0)
      return AppLocalizations.of(context).today;
    if (diff == 1)
      return AppLocalizations.of(context).yesterday;
    return dateKey;
  }

  @override
  Widget build(BuildContext context) {
    final sortedEntries =
        recentlyPlayed.entries.toList()..sort((a, b) {
          DateTime parseDate(String key) {
            final parts = key.split('/');
            return DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          }

          return parseDate(
            b.key,
          ).compareTo(parseDate(a.key));
        });

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(
              context,
            ).appBarTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context).recentlyPlayed,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: _showAddSongDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: sortedEntries.map((entry) {
          String date = entry.key;
          List<SongModel> songs = entry.value;

          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                formatDate(context, date),
                style:
                    Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ) ??
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 10),
              ...songs.map((song) {
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8),
                      child: Image.asset(
                        song.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      song.title,
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.w600,
                                fontSize: 15,
                              ) ??
                          const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                            fontSize: 15,
                          ),
                    ),
                    subtitle: Text(
                      song.artist,
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
                              ) ??
                          const TextStyle(
                            color: Colors.black54,
                          ),
                    ),
                    trailing: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.pinkAccent,
                      size: 30,
                    ),
                    onTap: () {
                      final convertedSongs = songs
                          .map<Map<String, String>>(
                            (s) => {
                              'title': s.title,
                              'artist': s.artist,
                              'img': s.image,
                            },
                          )
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerScreen(
                            songs: convertedSongs,
                            currentIndex: songs
                                .indexOf(song),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ),
    );
  }
}
