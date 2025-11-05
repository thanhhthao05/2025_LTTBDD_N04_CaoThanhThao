import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../player/player_screen.dart';
import '../../../player/song_model.dart';

class WhatsNewScreen extends StatelessWidget {
  const WhatsNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎵 Danh sách bài hát có ngày phát hành
    final List<Map<String, dynamic>> allSongs = [
      {
        "image": "imgs/Người_Đầu_Tiên.jpg",
        "title": "Người Đầu Tiên",
        "artist": "Juky San",
        "date": DateTime.now(), // hôm nay
      },
      {
        "image": "imgs/Mất_Kết_Nối.jpg",
        "title": "Mất Kết Nối",
        "artist": "Dương Domic",
        "date": DateTime.now().subtract(
          const Duration(days: 1),
        ), // hôm qua
      },
      {
        "image": "imgs/Vũ.jpg",
        "title": "Bình Yên",
        "artist": "Vũ.",
        "date": DateTime(2024, 10, 12), // ngày cũ
      },
      {
        "image": "imgs/HIEUTHUHAI.jpg",
        "title": "Vệ tinh",
        "artist": "HIEUTHUHAI",
        "date": DateTime(2024, 7, 5),
      },
      {
        "image": "imgs/QuanAP.jpg",
        "title": "Bông hoa đẹp nhất",
        "artist": "Quân A.P.",
        "date": DateTime(2024, 5, 15),
      },
    ];

    // 📅 Lấy ngày hôm nay & hôm qua
    final today = DateTime.now();
    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    // 🧩 Phân loại bài hát
    final todaySongs = allSongs
        .where(
          (s) => DateUtils.isSameDay(s['date'], today),
        )
        .toList();
    final yesterdaySongs = allSongs
        .where(
          (s) => DateUtils.isSameDay(
            s['date'],
            yesterday,
          ),
        )
        .toList();
    final earlierSongs = allSongs
        .where(
          (s) => (s['date'] as DateTime).isBefore(
            yesterday,
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🟢 PHẦN TIÊU ĐỀ
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 18,
              left: 16,
              right: 16,
              bottom: 5,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Color.fromARGB(255, 253, 206, 237),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Có gì mới",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildTab("Bài hát", true),
                    const SizedBox(width: 25),
                    _buildTab("Album", false),
                  ],
                ),
              ],
            ),
          ),

          // 🟢 DANH SÁCH BÀI HÁT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (todaySongs.isNotEmpty) ...[
                    const Text(
                      "Hôm nay",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: todaySongs.map((song) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                                bottom: 16,
                              ),
                          child: _buildMusicCard(
                            context: context,
                            image: song["image"],
                            title: song["title"],
                            artist: song["artist"],
                            date: DateFormat(
                              'MMM d',
                            ).format(song["date"]),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (yesterdaySongs.isNotEmpty) ...[
                    const Text(
                      "Hôm qua",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: yesterdaySongs.map((
                        song,
                      ) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                                bottom: 16,
                              ),
                          child: _buildMusicCard(
                            context: context,
                            image: song["image"],
                            title: song["title"],
                            artist: song["artist"],
                            date: DateFormat(
                              'MMM d',
                            ).format(song["date"]),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (earlierSongs.isNotEmpty) ...[
                    const Text(
                      "Trước đó",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: earlierSongs.map((
                        song,
                      ) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                                bottom: 16,
                              ),
                          child: _buildMusicCard(
                            context: context,
                            image: song["image"],
                            title: song["title"],
                            artist: song["artist"],
                            date: DateFormat(
                              'MMM d',
                            ).format(song["date"]),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟣 Tab "Bài hát" / "Album"
  Widget _buildTab(String text, bool isSelected) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal,
            color: Colors.black,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 3,
            width: 50,
            color: Colors.black,
          ),
      ],
    );
  }

  // 🟣 Card hiển thị thông tin bài hát
  Widget _buildMusicCard({
    required BuildContext context,
    required String image,
    required String title,
    required String artist,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  artist,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Single",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Đã thêm '$title' vào danh sách yêu thích",
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.favorite_border,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(
                        songs: [
                          {
                            'title': title,
                            'artist': artist,
                            'img': image,
                          },
                        ],
                        currentIndex: 0,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
