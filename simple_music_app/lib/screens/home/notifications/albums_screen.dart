import 'package:flutter/material.dart';
import '../../../player/all_songs.dart';
import 'album_detail_screen.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).albumTab,
          style:
              Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.titleLarge?.color,
              ) ??
              const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor:
            Theme.of(
              context,
            ).appBarTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        iconTheme: Theme.of(context).iconTheme,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          final List<Map<String, String>> songs =
              (album['songs'] as List)
                  .map(
                    (e) => {
                      'title': e['title'] as String,
                      'artist': e['artist'] as String,
                      'img': e['img'] as String,
                    },
                  )
                  .toList();

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AlbumDetailScreen(
                    album: album,
                    songs: songs,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 16,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(
                  12,
                ),
                boxShadow:
                    Theme.of(context).brightness ==
                        Brightness.light
                    ? [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12),
                    child: Image.asset(
                      album['img'],
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      album['title'],
                      style:
                          Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.w700,
                              ) ??
                          const TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w700,
                            height: 1.2,
                          ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context)
                        .iconTheme
                        .color
                        ?.withOpacity(0.7),
                    size: 18,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
