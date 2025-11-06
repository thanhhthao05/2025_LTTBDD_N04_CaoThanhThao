import 'package:flutter/material.dart';
import '../../../player/player_screen.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Map<String, dynamic> album;
  final List<Map<String, String>> songs;

  const AlbumDetailScreen({
    super.key,
    required this.album,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
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
          album['title'],
          style:
              Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh album + thông tin
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                  child: Image.asset(
                    album['img'],
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        album['title'],
                        style:
                            Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight.bold,
                                ) ??
                            const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${songs.length} ${AppLocalizations.of(context).musicLabel.toLowerCase()}',
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
                                          ),
                                ) ??
                            const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PlayerScreen(
                                    songs: songs,
                                    currentIndex: 0,
                                  ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),
                        label: Text(
                          AppLocalizations.of(
                            context,
                          ).playAll,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8,
            ),
            child: Text(
              AppLocalizations.of(context).playAll ==
                      'Play all'
                  ? 'Track list'
                  : 'Danh sách bài hát',
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ??
                  const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
          ),

          // Danh sách bài hát
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8),
                    child: Image.asset(
                      song['img']!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song['title']!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    song['artist']!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                  ),
                  trailing: Icon(
                    Icons.play_circle_fill,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary,
                    size: 28,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
