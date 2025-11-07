import 'package:flutter/foundation.dart';
import 'song_model.dart';

class RecentlyPlayedManager {
  RecentlyPlayedManager._internal();

  static final RecentlyPlayedManager _instance =
      RecentlyPlayedManager._internal();

  static RecentlyPlayedManager get instance =>
      _instance;

  /// The map key is a date string like dd/MM/yyyy
  final ValueNotifier<Map<String, List<SongModel>>>
  recentlyPlayed = ValueNotifier({});

  String _formatDateKey(DateTime date) =>
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

  void add(SongModel newSong) {
    final map = Map<String, List<SongModel>>.from(
      recentlyPlayed.value,
    );
    final today = _formatDateKey(DateTime.now());
    final yesterdayKey = _formatDateKey(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    // Remove duplicates anywhere
    for (final entry in map.entries) {
      entry.value.removeWhere(
        (s) =>
            s.title == newSong.title &&
            s.artist == newSong.artist,
      );
    }

    if (map.containsKey(today)) {
      final oldToday = map[today]!;
      if (oldToday.isNotEmpty) {
        if (map.containsKey(yesterdayKey)) {
          map[yesterdayKey] = [
            ...oldToday,
            ...map[yesterdayKey]!,
          ];
        } else {
          map[yesterdayKey] = List.from(oldToday);
        }
      }
      map.remove(today);
    }

    map[today] = [newSong];

    recentlyPlayed.value = map;
  }
}
