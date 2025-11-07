import 'package:flutter/material.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';
import './notifications/whats_new_screen.dart';
import '../../player/recently_played_screen.dart';
import '../../player/player_screen.dart';
import '../song_options_menu.dart';
import '../../config/spotify_config.dart';
import '../../player/recently_played_manager.dart';
import '../../player/song_model.dart';
import '../../player/all_songs.dart';
import '../../services/spotify_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpotifyService _spotifyService = SpotifyService();

  List<SpotifyTrack> _suggested = const [];
  List<SpotifyTrack> _hotTracks = const [];
  List<SpotifyTrack> _chillTracks = const [];
  List<Map<String, String>> _mockSongs = [];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Lọc các bài hát từ folder mock
    _mockSongs = allSongs
        .where(
          (song) =>
              song['previewUrl'] != null &&
              song['previewUrl']!.startsWith('lib/mock/'),
        )
        .toList();
    _loadMockSongsMetadata();
    _loadData();
  }

  /// Tìm kiếm Spotify để lấy metadata cho các bài hát từ mock
  Future<void> _loadMockSongsMetadata() async {
    final updatedSongs = <Map<String, String>>[];

    for (final song in _mockSongs) {
      try {
        // Lấy tên bài hát từ previewUrl (loại bỏ .mp3 và lib/mock/)
        final fileName = song['previewUrl']!
            .replaceFirst('lib/mock/', '')
            .replaceFirst('.mp3', '');

        // Tìm kiếm trên Spotify với query: "tên bài hát HIEUTHUHAI"
        final query = '$fileName HIEUTHUHAI';
        debugPrint('Searching Spotify for: $query');

        final results = await _spotifyService.searchTracks(query, limit: 1);

        if (results.isNotEmpty) {
          final track = results.first;
          // Cập nhật thông tin từ Spotify nhưng giữ previewUrl local
          updatedSongs.add({
            'title': track.title,
            'artist': track.artist,
            'img': track.imageUrl,
            'previewUrl': song['previewUrl']!, // Giữ file MP3 local
          });
          debugPrint('Found: ${track.title} - ${track.artist}');
        } else {
          // Nếu không tìm thấy, giữ nguyên thông tin cũ
          updatedSongs.add(song);
          debugPrint('Not found on Spotify: $fileName');
        }
      } catch (e) {
        // Nếu có lỗi, giữ nguyên thông tin cũ
        debugPrint('Error searching for ${song['title']}: $e');
        updatedSongs.add(song);
      }
    }

    if (mounted) {
      setState(() {
        _mockSongs = updatedSongs;
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final results = await Future.wait([
        _spotifyService.fetchRecommendations(
          seedGenres: spotifySuggestedSeedGenres,
          limit: 30,
        ),
        _spotifyService.fetchRecommendations(
          seedGenres: spotifyHotSeedGenres,
          limit: 20,
        ),
        _spotifyService.fetchRecommendations(
          seedGenres: spotifyChillSeedGenres,
          limit: 20,
        ),
      ]);

      setState(() {
        _suggested = results[0];
        _hotTracks = results[1];
        _chillTracks = results[2];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _loading = false;
      });
    }
  }

  void _openPlayer(List<SpotifyTrack> tracks, int index) {
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).homeTitle,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WhatsNewScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spotify error',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FilterChip(
                          label: Text(AppLocalizations.of(context).musicLabel),
                          selected: true,
                          backgroundColor: theme.cardColor,
                          selectedColor: const Color.fromARGB(
                            255,
                            253,
                            119,
                            177,
                          ).withOpacity(0.1),
                          labelStyle: theme.textTheme.bodyMedium,
                          onSelected: (_) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Hiển thị bài hát từ mock trước
                    if (_mockSongs.isNotEmpty) ...[
                      _buildMockSongsSection(context),
                      const SizedBox(height: 24),
                    ],
                    _buildSuggestedSection(context),
                    const SizedBox(height: 24),
                    _buildRecentlyPlayedSection(context),
                    const SizedBox(height: 24),
                    _buildHorizontalTracks(
                      title: AppLocalizations.of(context).hotToday,
                      tracks: _hotTracks,
                    ),
                    const SizedBox(height: 24),
                    _buildHorizontalTracks(
                      title: AppLocalizations.of(context).chill,
                      tracks: _chillTracks,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _openMockPlayer(List<Map<String, String>> songs, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(songs: songs, currentIndex: index),
      ),
    );
  }

  Widget _buildMockSongsSection(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HIEUTHUHAI',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: _mockSongs.isEmpty
                  ? null
                  : () => _openMockPlayer(_mockSongs, 0),
              icon: const Icon(
                Icons.play_circle_fill,
                color: Color.fromARGB(255, 253, 119, 177),
              ),
              label: Text(
                loc.playAll,
                style: const TextStyle(
                  color: Color.fromARGB(255, 253, 119, 177),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _mockSongs.length,
            itemBuilder: (context, index) {
              final song = _mockSongs[index];
              return GestureDetector(
                onTap: () => _openMockPlayer(_mockSongs, index),
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildNetworkOrAssetImage(
                              song['img'] ?? '',
                              150,
                              150,
                            ),
                          ),
                          // Indicator cho bài có preview
                          if (song['previewUrl'] != null)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        song['title'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        song['artist'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedSection(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc.suggestedSongs,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _suggested.isEmpty
                      ? null
                      : () => _openPlayer(_suggested, 0),
                  icon: const Icon(
                    Icons.play_circle_fill,
                    color: Color.fromARGB(255, 253, 119, 177),
                  ),
                  label: Text(
                    loc.playAll,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 253, 119, 177),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _suggested = List.of(_suggested)..shuffle();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.suggestionsRefreshed)),
                    );
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Color.fromARGB(255, 253, 119, 177),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_suggested.isEmpty)
          Text(loc.noResults)
        else
          SizedBox(
            height:
                310, // Increased from 280 to accommodate 3 rows with margins
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate((_suggested.length / 3).ceil(), (
                  colIndex,
                ) {
                  return Column(
                    children: List.generate(3, (rowIndex) {
                      final index = colIndex * 3 + rowIndex;
                      if (index >= _suggested.length) return const SizedBox();
                      final track = _suggested[index];
                      return GestureDetector(
                        onTap: () => _openPlayer(_suggested, index),
                        child: Container(
                          width: 200,
                          height: 90,
                          margin: const EdgeInsets.symmetric(
                            vertical: 4, // Reduced from 6 to 4
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      track.imageUrl,
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                  // Indicator cho bài có preview
                                  if (track.previewUrl != null)
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      track.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      track.artist,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SongOptionsMenu(
                                song: track.toSongMap(),
                                onPlay: () => _openPlayer(_suggested, index),
                                onAddToPlaylist: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        loc.addedToPlaylist(track.title),
                                      ),
                                    ),
                                  );
                                },
                                onDelete: () {
                                  setState(() {
                                    _suggested = List.of(_suggested)
                                      ..removeAt(index);
                                  });
                                },
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentlyPlayedSection(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecentlyPlayedScreen()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.recentlyPlayed,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<Map<String, List<SongModel>>>(
          valueListenable:
              RecentlyPlayedManager.instance.recentlyPlayedNotifier,
          builder: (context, value, _) {
            final tracks = value.values.expand((songs) => songs).toList();
            if (tracks.isEmpty) {
              return const Text('Chưa có lịch sử nghe.');
            }
            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final song = tracks[index];
                  return GestureDetector(
                    onTap: () {
                      final maps = tracks.map((e) => e.toMap()).toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PlayerScreen(songs: maps, currentIndex: index),
                        ),
                      );
                    },
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildNetworkOrAssetImage(
                              song.image,
                              110,
                              110,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHorizontalTracks({
    required String title,
    required List<SpotifyTrack> tracks,
  }) {
    if (tracks.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return GestureDetector(
                onTap: () => _openPlayer(tracks, index),
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              track.imageUrl,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                          // Indicator cho bài có preview
                          if (track.previewUrl != null)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        track.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkOrAssetImage(String path, double width, double height) {
    if (path.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.music_note, color: Colors.grey),
      );
    }
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.music_note, color: Colors.grey),
      ),
    );
  }
}
