// quản lý dữ liệu bài hát yêu thích
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../player/song_model.dart';

class FavoriteManager {
  static const String _key = 'favorite_songs';

  // Danh sách bài hát yêu thích
  static final ValueNotifier<List<SongModel>>
  favoriteSongs = ValueNotifier<List<SongModel>>([]);

  //🟢 Khởi tạo danh sách bài hát yêu thích từ SharedPreferences
  static Future<void> init() async {
    final prefs =
        await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      favoriteSongs.value = decoded
          .map(
            (e) => SongModel(
              title: e['title'],
              artist: e['artist'] ?? '',
              image: e['image'] ?? '',
            ),
          )
          .toList();
    }
  }

  //🟢 Lưu danh sách bài hát yêu thích vào SharedPreferences
  static Future<void> _save() async {
    final prefs =
        await SharedPreferences.getInstance();
    final data = favoriteSongs.value
        .map(
          (s) => {
            'title': s.title,
            'artist': s.artist,
            'image': s.image,
          },
        )
        .toList();
    await prefs.setString(_key, jsonEncode(data));
  }

  // ❤️ Thêm hoặc xóa khỏi yêu thích
  static Future<void> toggleFavorite(
    SongModel song,
  ) async {
    final exists = favoriteSongs.value.any(
      (s) => s.title == song.title,
    );
    if (exists) {
      favoriteSongs.value = favoriteSongs.value
          .where((s) => s.title != song.title)
          .toList();
    } else {
      favoriteSongs.value = [
        ...favoriteSongs.value,
        song,
      ];
    }
    await _save();
  }

  // Kiểm tra bài hát có trong yêu thích không
  static bool isFavorite(SongModel song) {
    return favoriteSongs.value.any(
      (s) => s.title == song.title,
    );
  }
}
