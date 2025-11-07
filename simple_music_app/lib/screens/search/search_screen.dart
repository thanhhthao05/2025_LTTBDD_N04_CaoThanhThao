import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/spotify_config.dart';
import '../../player/player_screen.dart';
import '../../player/recently_played_manager.dart';
import '../../screens/song_options_menu.dart';
import '../../services/spotify_service.dart';
import '../main_screen.dart';
import 'search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SpotifyService _spotifyService = SpotifyService();
  Timer? _debounce;
  // suggestion keys - map to localized labels below
  final List<String> suggestions = ['recentlyPlayed', 'hot', 'suggestedSongs'];
  String searchQuery = '';
  final List<String> _searchHistory = [];
  List<SpotifyTrack> _searchResults = const [];
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _recordHistory(String title) {
    final normalized = title.trim();
    if (normalized.isEmpty) return;
    setState(() {
      _searchHistory.removeWhere(
        (item) => item.toLowerCase() == normalized.toLowerCase(),
      );
      _searchHistory.insert(0, normalized);
    });
  }

  void _clearHistory() {
    if (_searchHistory.isEmpty) return;
    setState(() {
      _searchHistory.clear();
    });
  }

  void _onQueryChanged(String value) {
    setState(() {
      searchQuery = value;
      if (value.isEmpty) {
        _searchResults = const [];
        _errorMessage = null;
      }
    });

    _debounce?.cancel();
    if (value.trim().isEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _performSearch(value);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final results = await _spotifyService.searchTracks(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _loading = false;
      });
    }
  }

  void _openTracks(List<SpotifyTrack> tracks, int index) {
    if (tracks.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(
          songs: tracks.map((e) => e.toSongMap()).toList(),
          currentIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainScreen(initialIndex: 1),
                  ),
                  (route) => false,
                );
              },
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchHint,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: _onQueryChanged,
                onSubmitted: (value) {
                  _recordHistory(value);
                  _performSearch(value);
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).suggestedSongs,
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
                    label = AppLocalizations.of(context).recentlyPlayed;
                  } else if (s == 'hot') {
                    label = AppLocalizations.of(context).hotToday;
                  } else {
                    label = AppLocalizations.of(context).suggestedSongs;
                  }

                  return ActionChip(
                    label: Text(label),
                    backgroundColor: Theme.of(context).cardColor,
                    onPressed: () => _handleSuggestionTap(context, s, label),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // 🕘 Lịch sử tìm kiếm
              if (searchQuery.isEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).searchHistory,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _clearHistory();
                      },
                      child: Text(
                        AppLocalizations.of(context).clear,
                        style: const TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_searchHistory.isEmpty)
                  Text(
                    AppLocalizations.of(context).noResults,
                    style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).hintColor,
                        ) ??
                        const TextStyle(color: Colors.grey),
                  )
                else
                  Column(
                    children: _searchHistory.map((keyword) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.history),
                        title: Text(keyword),
                        onTap: () {
                          setState(() {
                            searchQuery = keyword;
                            _searchController.text = keyword;
                          });
                          _performSearch(keyword);
                        },
                      );
                    }).toList(),
                  ),
              ],

              // 📝 Kết quả tìm kiếm
              if (_loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                )
              else if (_searchResults.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                      AppLocalizations.of(context).noResults,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                          ) ??
                          const TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                Column(
                  children: _searchResults.asMap().entries.map((entry) {
                    final index = entry.key;
                    final track = entry.value;
                    final songMap = track.toSongMap();
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              track.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                          // Indicator cho bài có preview
                          if (track.previewUrl != null)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        track.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        track.artist,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        _recordHistory(track.title);
                        _openTracks(_searchResults, index);
                      },
                      trailing: SongOptionsMenu(
                        song: songMap,
                        onPlay: () {
                          _recordHistory(track.title);
                          _openTracks(_searchResults, index);
                        },
                        onAddToPlaylist: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                ).addedToPlaylist(track.title),
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          setState(() {
                            _searchResults = List.of(_searchResults)
                              ..removeAt(index);
                          });
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

  Future<void> _handleSuggestionTap(
    BuildContext context,
    String key,
    String label,
  ) async {
    List<Map<String, String>> songs = [];
    if (key == 'recentlyPlayed') {
      final data = RecentlyPlayedManager.instance.recentlyPlayedNotifier.value;
      final collected = data.values.expand((element) => element).toList();
      if (collected.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chưa có lịch sử nghe gần đây.')),
          );
        }
        return;
      }
      songs = collected.map((song) => song.toMap()).toList();
    } else {
      try {
        setState(() {
          _loading = true;
          _errorMessage = null;
        });
        final tracks = await _spotifyService.fetchRecommendations(
          seedGenres: key == 'hot'
              ? spotifyHotSeedGenres
              : spotifySuggestedSeedGenres,
          limit: 30,
        );
        songs = tracks.map((e) => e.toSongMap()).toList();
        if (mounted) {
          setState(() {
            _loading = false;
            _searchResults = tracks;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _loading = false;
            _errorMessage = e.toString();
          });
        }
        return;
      }
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultScreen(title: label, songs: songs),
      ),
    );
  }
}
