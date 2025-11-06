import 'package:flutter/material.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';
import '../main_screen.dart';
import '../../screens/song_options_menu.dart';
import '../../player/player_screen.dart';
import '../../player/all_songs.dart';
import 'search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // suggestion keys - map to localized labels below
  final List<String> suggestions = [
    'recentlyPlayed',
    'hot',
    'suggestedSongs',
  ];
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSongs = allSongs
        .where(
          (song) =>
              song['title']!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              song['artist']!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
        )
        .toList();

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
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(
                  context,
                ).iconTheme.color,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainScreen(
                      initialIndex: 1,
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(
                    context,
                  ).searchHint,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(
                  context,
                ).suggestedSongs,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // 🏷️ Chip đề xuất
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: suggestions.map((s) {
                  String label;
                  if (s == 'recentlyPlayed') {
                    label = AppLocalizations.of(
                      context,
                    ).recentlyPlayed;
                  } else if (s == 'hot') {
                    label = AppLocalizations.of(
                      context,
                    ).hotToday;
                  } else {
                    label = AppLocalizations.of(
                      context,
                    ).suggestedSongs;
                  }

                  return ActionChip(
                    label: Text(label),
                    backgroundColor: Theme.of(
                      context,
                    ).cardColor,
                    onPressed: () {
                      List<Map<String, String>>
                      selectedSongs = [];

                      if (s == 'recentlyPlayed') {
                        selectedSongs = ngheGanDay;
                      } else if (s == 'hot') {
                        selectedSongs = hot;
                      } else {
                        selectedSongs = allSongs;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SearchResultScreen(
                                title: label,
                                songs: selectedSongs,
                              ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // 🕘 Lịch sử tìm kiếm
              if (searchQuery.isEmpty) ...[
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      ).searchHistory,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          allSongs.clear();
                        });
                      },
                      child: Text(
                        AppLocalizations.of(
                          context,
                        ).clear,
                        style: const TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              // 📝 Kết quả tìm kiếm
              if (filteredSongs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).noResults,
                      style:
                          Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).hintColor,
                              ) ??
                          const TextStyle(
                            color: Colors.grey,
                          ),
                    ),
                  ),
                )
              else
                Column(
                  children: filteredSongs.asMap().entries.map((
                    entry,
                  ) {
                    final index = entry.key;
                    final item = entry.value;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(8),
                        child: Image.asset(
                          item['img']!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        item['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        item['artist']!,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PlayerScreen(
                                  songs: filteredSongs,
                                  currentIndex: index,
                                ),
                          ),
                        );
                      },
                      trailing: SongOptionsMenu(
                        song: item,
                        onPlay: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PlayerScreen(
                                    songs:
                                        filteredSongs,
                                    currentIndex:
                                        index,
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
                                ).addedToPlaylist(
                                  item['title'] ?? '',
                                ),
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          setState(() {
                            allSongs.remove(item);
                          });
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "🗑 Đã xóa khỏi danh sách tìm kiếm",
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
