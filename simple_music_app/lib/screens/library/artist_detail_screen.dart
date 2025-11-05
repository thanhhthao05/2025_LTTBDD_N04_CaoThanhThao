// màn hình chi tiết nghệ sĩ
import 'package:flutter/material.dart';
import '../../player/player_screen.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String artistName;
  final List<Map<String, String>> songs;

  const ArtistDetailScreen({
    super.key,
    required this.artistName,
    required this.songs,
  });

  @override
  State<ArtistDetailScreen> createState() =>
      _ArtistDetailScreenState();
}

class _ArtistDetailScreenState
    extends State<ArtistDetailScreen> {
  late List<Map<String, String>> _songs;

  @override
  void initState() {
    super.initState();
    _songs = List.from(widget.songs);
  }

  // 🧩 Hàm thêm bài hát mới
  void _addNewSong() {
    final titleController = TextEditingController();
    final imgController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thêm bài hát mới"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Tên bài hát",
              ),
            ),
            TextField(
              controller: imgController,
              decoration: const InputDecoration(
                labelText:
                    "Đường dẫn ảnh (ví dụ: imgs/NewSong.jpg)",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  _songs.add({
                    'title': titleController.text,
                    'artist': widget.artistName,
                    'img':
                        imgController.text.isNotEmpty
                        ? imgController.text
                        : 'imgs/default_song.jpg',
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Thêm"),
          ),
        ],
      ),
    );
  }

  // 🧩 Giao diện chi tiết nghệ sĩ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.artistName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: _addNewSong,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📸 Ảnh bìa nghệ sĩ
          Container(
            width: double.infinity,
            height: 230,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'imgs/${widget.artistName}.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ▶️ Nút phát tất cả
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(
                      songs: _songs,
                      currentIndex: 0,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              label: const Text(
                'Phát tất cả',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 🎵 Danh sách bài hát
          Expanded(
            child: ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];

                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                  leading: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8),
                    child: Image.asset(
                      song['img']!,
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    widget.artistName,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.more_vert,
                    color: Colors.black54,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlayerScreen(
                              songs: _songs,
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
