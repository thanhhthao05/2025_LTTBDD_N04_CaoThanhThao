import 'package:flutter/material.dart';
import './song_model.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() =>
      _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState
    extends State<RecentlyPlayedScreen> {
  final Map<String, List<SongModel>> recentlyPlayed = {
    "Hôm nay": [
      SongModel(
        title: "Hẹn Gặp Em Dưới Ánh Trăng",
        artist: "Hurrykng, HieuThuHai, Manbo",
        image: "imgs/Hẹn_Gặp_Em_Dưới_Ánh_Trăng.jpg",
      ),
      SongModel(
        title: "Perfect",
        artist: "Shiki",
        image: "imgs/Perfect.jpg",
      ),
      SongModel(
        title: "3107 3",
        artist: "W/N, Duongg, Nâu, titie",
        image: "imgs/3107_3.jpg",
      ),
      SongModel(
        title: "Đa Nghi",
        artist: "Anh Trai Say Hi 2",
        image: "imgs/Đa_Nghi.jpg",
      ),
    ],
    "Hôm qua": [
      SongModel(
        title: "Ngủ Một Mình",
        artist: "HIEUTHUHAI",
        image: "imgs/HIEUTHUHAI.jpg",
      ),
      SongModel(
        title: "Ếch Ngoài Đáy Giếng",
        artist: "EM XINH 'SAY HI', Phương Mỹ Chi",
        image: "imgs/Ếch_Ngoài_Đáy_Giếng.jpg",
      ),
      SongModel(
        title: "Chăm Hoa",
        artist: "MONO",
        image: "imgs/Chăm_Hoa.jpg",
      ),
      SongModel(
        title: "Muộn Rồi Mà Sao Còn",
        artist: "MTP",
        image: "imgs/Muon_Roi_Ma_Sao_Con.jpg",
      ),
    ],
  };

  // 🧩 Hàm thêm bài hát
  void _addSong(String group, SongModel newSong) {
    setState(() {
      recentlyPlayed[group]?.add(newSong);
    });
  }

  // 🧩 Form thêm bài hát
  void _showAddSongDialog() {
    final titleController = TextEditingController();
    final artistController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thêm bài hát mới"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Tên bài hát",
                ),
              ),
              TextField(
                controller: artistController,
                decoration: const InputDecoration(
                  labelText: "Nghệ sĩ",
                ),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText:
                      "Đường dẫn ảnh (VD: imgs/new_song.jpg)",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  artistController.text.isNotEmpty) {
                _addSong(
                  "Hôm nay",
                  SongModel(
                    title: titleController.text,
                    artist: artistController.text,
                    image:
                        imageController.text.isNotEmpty
                        ? imageController.text
                        : "imgs/default.jpg",
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Recently Played",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: _showAddSongDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: recentlyPlayed.entries.map((entry) {
          String date = entry.key;
          List<SongModel> songs = entry.value;

          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              ...songs.map((song) {
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8),
                      child: Image.asset(
                        song.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      song.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      song.artist,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.pinkAccent,
                      size: 30,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            "🎵 Đang mở: ${song.title}",
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ),
    );
  }
}
