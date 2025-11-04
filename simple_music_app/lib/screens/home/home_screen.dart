import 'package:flutter/material.dart';
import './notifications/whats_new_screen.dart';
import '../../player/recently_played_screen.dart';
import '../../player/song_model.dart';
import '../../player/player_screen.dart';
import '../song_options_menu.dart';
import '../../player/all_songs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> goiYBaiHat =
      List.from(allSongs);

  final List<Map<String, String>> ngheGanDayList =
      ngheGanDay;

  final List<Map<String, String>> hotList = hot;

  final List<Map<String, String>> chartsList = charts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Xin chào',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const WhatsNewScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔘 Thanh chọn Music / Album
            Row(
              children: [
                FilterChip(
                  label: const Text("Âm nhạc"),
                  selected: true,
                  backgroundColor: Colors.white,
                  selectedColor: const Color.fromARGB(
                    255,
                    253,
                    119,
                    177,
                  ).withOpacity(0.1),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  onSelected: (_) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text("Album"),
                  selected: false,
                  backgroundColor: Colors.white,
                  labelStyle: const TextStyle(
                    color: Colors.black54,
                  ),
                  onSelected: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🎶 Gợi ý bài hát (giữ nguyên header của bạn)
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Gợi ý bài hát",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayerScreen(
                                  songs: allSongs,
                                  currentIndex:
                                      0, // Bắt đầu từ bài đầu tiên
                                ),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.play_circle_fill,
                        color: Color.fromARGB(
                          255,
                          253,
                          119,
                          177,
                        ),
                      ),
                      label: const Text(
                        "Phát tất cả",
                        style: TextStyle(
                          color: Color.fromARGB(
                            255,
                            253,
                            119,
                            177,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          goiYBaiHat
                            ..clear()
                            ..addAll(allSongs)
                            ..shuffle();
                        });
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "✨ Danh sách gợi ý đã làm mới!",
                            ),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.refresh,
                        color: Color.fromARGB(
                          255,
                          253,
                          119,
                          177,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🎵 Gợi ý bài hát - layout ngang nhiều cột như bạn có
            SizedBox(
              height: 280,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: List.generate((goiYBaiHat.length / 3).ceil(), (
                    colIndex,
                  ) {
                    return Column(
                      mainAxisAlignment:
                          MainAxisAlignment.start,
                      children: List.generate(3, (
                        rowIndex,
                      ) {
                        int index =
                            colIndex * 3 + rowIndex;
                        if (index >= goiYBaiHat.length)
                          return const SizedBox();
                        final song = goiYBaiHat[index];

                        // --- đây là phần item: giữ layout của bạn, nhưng đặt SongOptionsMenu đúng chỗ ---
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlayerScreen(
                                      songs:
                                          goiYBaiHat,
                                      currentIndex:
                                          index,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            width: 180,
                            height: 80,
                            margin:
                                const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  BorderRadius.circular(
                                    12,
                                  ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .center,
                              children: [
                                const SizedBox(
                                  width: 6,
                                ),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(
                                        8,
                                      ),
                                  child: Image.asset(
                                    song['img']!,
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        song['title']!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        song['artist'] ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors
                                              .grey,
                                        ),
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                // <-- đặt SongOptionsMenu ở đây, dùng 'song' và index hiện tại
                                SongOptionsMenu(
                                  song: song,
                                  onPlay: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PlayerScreen(
                                              songs:
                                                  goiYBaiHat,
                                              currentIndex:
                                                  index,
                                            ),
                                      ),
                                    );
                                  },
                                  onAddToPlaylist: () {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Đã thêm '${song['title']}' vào danh sách phát.",
                                        ),
                                      ),
                                    );
                                  },
                                  onDelete: () {
                                    setState(() {
                                      goiYBaiHat
                                          .removeAt(
                                            index,
                                          );
                                    });
                                  },
                                ),
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

            const SizedBox(height: 30),

            // 🕓 Nghe gần đây (giữ nguyên phần còn lại của màn hình)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const RecentlyPlayedScreen(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Nghe gần đây",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ngheGanDay.length,
                itemBuilder: (context, index) {
                  final item = ngheGanDay[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 12,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayerScreen(
                                  songs: ngheGanDay,
                                  currentIndex: index,
                                ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                                  12,
                                ),
                            child: Image.asset(
                              item['img']!,
                              height: 110,
                              width: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 100,
                            child: Text(
                              item['title']!,
                              textAlign:
                                  TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                              overflow: TextOverflow
                                  .ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // 🎧 Hot nhất hôm nay
            const Text(
              "Hot nhất hôm nay",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hot.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 12,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayerScreen(
                                  songs: ngheGanDay,
                                  currentIndex: index,
                                ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                                  10,
                                ),
                            child: Image.asset(
                              hot[index]['img']!,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            hot[index]['title']!,
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // 📊 Chill (charts)
            const Text(
              "Chill",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: charts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 12,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                                10,
                              ),
                          child: Image.asset(
                            charts[index]['img']!,
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          charts[index]['title']!,
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
