import 'package:flutter/material.dart';
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
  final List<String> suggestions = [
    'nghe gần đây',
    'hot',
    'gợi ý bài hát',
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
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
                decoration: const InputDecoration(
                  hintText:
                      'Tìm kiếm bài hát, nghệ sĩ...',
                  hintStyle: TextStyle(
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
              const Text(
                'Đề xuất cho bạn',
                style: TextStyle(
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
                  return ActionChip(
                    label: Text(s),
                    backgroundColor: Colors.grey[200],
                    onPressed: () {
                      List<Map<String, String>>
                      selectedSongs = [];

                      if (s == 'nghe gần đây') {
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
                                title: s,
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
                    const Text(
                      'Tìm kiếm gần đây',
                      style: TextStyle(
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
                      child: const Text(
                        'XÓA',
                        style: TextStyle(
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
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      "Không tìm thấy kết quả phù hợp 😢",
                      style: TextStyle(
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
                                "🎶 Đã thêm '${item['title']}' vào danh sách phát.",
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
