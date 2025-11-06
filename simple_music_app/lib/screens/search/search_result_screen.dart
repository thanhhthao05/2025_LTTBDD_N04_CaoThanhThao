//màn hình kết quả tìm kiếm
import 'package:flutter/material.dart';
import '../../player/player_screen.dart';
import '../../screens/song_options_menu.dart';

class SearchResultScreen extends StatelessWidget {
  final String title;
  final List<Map<String, String>> songs;

  const SearchResultScreen({
    super.key,
    required this.title,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor:
            Theme.of(
              context,
            ).appBarTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor,
      body: songs.isEmpty
          ? Center(
              child: Text(
                "Không có bài hát nào 😢",
                style:
                    Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).hintColor,
                    ) ??
                    const TextStyle(
                      color: Colors.grey,
                    ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8),
                    child: Image.asset(
                      song['img']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    song['artist'] ??
                        'Không rõ nghệ sĩ',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerScreen(
                          songs: songs,
                          currentIndex: index,
                        ),
                      ),
                    );
                  },
                  trailing: SongOptionsMenu(
                    song: song,
                    onPlay: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerScreen(
                            songs: songs,
                            currentIndex: index,
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
                            "🎶 Đã thêm '${song['title']}' vào danh sách phát.",
                          ),
                        ),
                      );
                    },
                    onDelete: () {},
                  ),
                );
              },
            ),
    );
  }
}
