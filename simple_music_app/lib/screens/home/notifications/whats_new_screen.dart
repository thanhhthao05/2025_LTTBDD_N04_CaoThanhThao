import 'package:flutter/material.dart';

class WhatsNewScreen extends StatelessWidget {
  const WhatsNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎵 Danh sách bài hát "Mới phát hành"
    final List<Map<String, String>> newSongs = [
      {
        "image": "imgs/Người_Đầu_Tiên.jpg",
        "title": "Người Đầu Tiên",
        "artist": "Juky San",
        "date": "October 30",
      },
      {
        "image": "imgs/PhuongLy.jpg",
        "title": "Vỗ tay",
        "artist": "Phương Ly",
        "date": "October 18",
      },
      // 👉 Thêm bài mới tại đây
      {
        "image": "imgs/Vũ.jpg",
        "title": "Bình Yên",
        "artist": "Vũ.",
        "date": "October 12",
      },
    ];

    // 🎵 Danh sách bài hát "Trước đó"
    final List<Map<String, String>> earlierSongs = [
      {
        "image": "imgs/HIEUTHUHAI.jpg",
        "title": "Vệ tinh",
        "artist": "HIEUTHUHAI",
        "date": "Jul 5",
      },
      {
        "image": "imgs/QuanAP.jpg",
        "title": "Bông hoa đẹp nhất",
        "artist": "Quân A.P.",
        "date": "May 15",
      },
    ];

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
                  Color.fromARGB(255, 255, 255, 255),
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
                // 🔹 Nút quay lại + tiêu đề
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
                // 🔹 Tab Bài hát / Album
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
                  const Text(
                    "Mới phát hành",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Tự sinh danh sách
                  Column(
                    children: newSongs
                        .map(
                          (song) => Padding(
                            padding:
                                const EdgeInsets.only(
                                  bottom: 16,
                                ),
                            child: _buildMusicCard(
                              image: song["image"]!,
                              title: song["title"]!,
                              artist: song["artist"]!,
                              date: song["date"]!,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    "Trước đó",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: earlierSongs
                        .map(
                          (song) => Padding(
                            padding:
                                const EdgeInsets.only(
                                  bottom: 16,
                                ),
                            child: _buildMusicCard(
                              image: song["image"]!,
                              title: song["title"]!,
                              artist: song["artist"]!,
                              date: song["date"]!,
                            ),
                          ),
                        )
                        .toList(),
                  ),
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
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border,
                ),
              ),
              IconButton(
                onPressed: () {},
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
