// màn hình “Nhạc yêu thích”
import 'package:flutter/material.dart';
import 'favorite_manager.dart';
import '../../player/player_screen.dart';

class FavoriteSongsScreen extends StatelessWidget {
  const FavoriteSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhạc yêu thích'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ValueListenableBuilder(
        valueListenable: FavoriteManager.favoriteSongs,
        builder: (context, favorites, _) {
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có bài hát yêu thích nào 💜',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final song = favorites[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  child: Image.asset(
                    song.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(song.title),
                subtitle: Text(song.artist),
                onTap: () {
                  // Truyền danh sách yêu thích sang PlayerScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(
                        songs: favorites
                            .map(
                              (s) => {
                                'title': s.title,
                                'artist': s.artist,
                                'img': s.image,
                              },
                            )
                            .toList(),
                        currentIndex: index,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
