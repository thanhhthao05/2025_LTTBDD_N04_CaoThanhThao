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
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: songs.isEmpty
          ? const Center(
              child: Text(
                "Không có bài hát nào 😢",
                style: TextStyle(color: Colors.grey),
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
