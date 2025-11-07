// menu ba chấm cho từng bài hát trong danh sách
import 'package:flutter/material.dart';

class SongOptionsMenu extends StatelessWidget {
  final Map<String, String> song;
  final VoidCallback onPlay;
  final VoidCallback onAddToPlaylist;
  final VoidCallback onDelete;

  const SongOptionsMenu({
    super.key,
    required this.song,
    required this.onPlay,
    required this.onAddToPlaylist,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black87),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 6,
      onSelected: (value) {
        switch (value) {
          case 'play':
            onPlay();
            break;
          case 'add':
            onAddToPlaylist();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        // Tiêu đề bài hát hiển thị trên đầu menu
        PopupMenuItem(
          enabled: false,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _buildImage(song['img']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song['title'] ?? 'Không có tên bài hát',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      song['artist'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const PopupMenuDivider(),

        // Phát bài hát
        PopupMenuItem(
          value: 'play',
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.play_arrow_rounded, color: Colors.purple),
            title: const Text('Phát bài hát'),
          ),
        ),

        // Thêm vào danh sách phát
        PopupMenuItem(
          value: 'add',
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.playlist_add_rounded, color: Colors.blue),
            title: const Text('Thêm vào danh sách phát'),
          ),
        ),

        // Xóa khỏi danh sách
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            dense: true,
            leading: const Icon(Icons.delete_outline, color: Colors.grey),
            title: const Text('Xóa khỏi danh sách'),
          ),
        ),
      ],
    );
  }
}

Widget _buildImage(String? source) {
  const double size = 40;
  if (source == null || source.isEmpty) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: const Icon(Icons.music_note, color: Colors.white70),
    );
  }
  if (source.startsWith('http')) {
    return Image.network(
      source,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: size,
        height: size,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported, color: Colors.white70),
      ),
    );
  }
  return Image.asset(source, width: size, height: size, fit: BoxFit.cover);
}
