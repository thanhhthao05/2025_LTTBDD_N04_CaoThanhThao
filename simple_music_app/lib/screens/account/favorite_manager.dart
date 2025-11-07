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

  // 🟢 Khởi tạo danh sách yêu thích
  static Future<void> init() async {
    final prefs =
        await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      favoriteSongs.value = decoded
          .map(
            (e) => SongModel(
              title: e['title'] ?? '',
              artist: e['artist'] ?? '',
              image: e['image'] ?? '',
            ),
          )
          .toList();
    }
  }

  // 💾 Lưu danh sách yêu thích
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

  // 💖 Thêm bài hát vào danh sách yêu thích
  static Future<void> addFavorite(
    SongModel song,
  ) async {
    if (!favoriteSongs.value.any(
      (s) => s.title == song.title,
    )) {
      favoriteSongs.value = [
        ...favoriteSongs.value,
        song,
      ];
      await _save();
    }
  }

  // 💔 Xóa bài hát khỏi danh sách yêu thích
  static Future<void> removeFavorite(
    SongModel song,
  ) async {
    favoriteSongs.value = favoriteSongs.value
        .where((s) => s.title != song.title)
        .toList();
    await _save();
  }

  // 🔁 Thêm hoặc xóa (toggle)
  static Future<void> toggleFavorite(
    SongModel song,
  ) async {
    if (await isFavorite(song)) {
      await removeFavorite(song);
    } else {
      await addFavorite(song);
    }
  }

  // 🔍 Kiểm tra bài hát có được yêu thích không
  static Future<bool> isFavorite(SongModel song) async {
    return favoriteSongs.value.any(
      (s) =>
          s.title == song.title &&
          s.artist == song.artist &&
          s.image == song.image,
    );
  }
}
