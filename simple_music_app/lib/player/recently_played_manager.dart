import 'package:flutter/foundation.dart';
import 'song_model.dart';

class RecentlyPlayedManager {
  RecentlyPlayedManager._internal();

  static final RecentlyPlayedManager _instance =
      RecentlyPlayedManager._internal();

  static RecentlyPlayedManager get instance => _instance;

  /// The map key is a date string like dd/MM/yyyy
  final ValueNotifier<Map<String, List<SongModel>>> _recentlyPlayedNotifier =
      ValueNotifier({});

  ValueNotifier<Map<String, List<SongModel>>> get recentlyPlayedNotifier =>
      _recentlyPlayedNotifier;

  ValueListenable<Map<String, List<SongModel>>> get recentlyPlayed =>
      _recentlyPlayedNotifier;

  String _formatDateKey(DateTime date) =>
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

  void add(SongModel newSong) {
    final map = Map<String, List<SongModel>>.from(
      _recentlyPlayedNotifier.value,
    );
    final today = _formatDateKey(DateTime.now());

    // Remove duplicates anywhere
    for (final entry in map.entries) {
      entry.value.removeWhere(
        (s) => s.title == newSong.title && s.artist == newSong.artist,
      );
    }

    final todayList = map[today] != null
        ? List<SongModel>.from(map[today]!)
        : <SongModel>[];
    todayList.insert(0, newSong);
    map[today] = todayList;

    map.removeWhere((key, value) => value.isEmpty);

    _recentlyPlayedNotifier.value = map;
  }
}
