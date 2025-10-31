import 'package:flutter/material.dart';
import './notifications/whats_new_screen.dart';
import './recent/recently_played_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎵 Gợi ý bài hát
    final goiYBaiHat = [
      {
        'title': 'Hẹn Gặp Em Dưới Ánh Trăng',
        'artist': 'Hurrykng, HieuThuHai, Manbo',
        'img': 'imgs/Hẹn_Gặp_Em_Dưới_Ánh_Trăng.jpg',
      },
      {
        'title': 'Kho Báu',
        'artist': '(S)Trong',
        'img': 'imgs/Kho_Báu.jpg',
      },
      {
        'title': 'Ếch Ngoài Đáy Giếng',
        'artist': 'EM XINH "SAY HI", Phương Mỹ Chi',
        'img': 'imgs/Ếch_Ngoài_Đáy_Giếng.jpg',
      },
      {
        'title': '3107 3',
        'artist': 'W/N, Duongg, Nâu, titie',
        'img': 'imgs/3107_3.jpg',
      },
      {
        'title': 'Chăm Hoa',
        'artist': 'MONO',
        'img': 'imgs/Chăm_Hoa.jpg',
      },
      {
        'title': 'Perfect',
        'artist': 'Shiki',
        'img': 'imgs/Perfect.jpg',
      },
      {
        'title': 'Đa Nghi',
        'artist': 'Anh Trai Say Hi 2',
        'img': 'imgs/Đa_Nghi.jpg',
      },
    ];

    // 🎧 Nghe gần đây
    final ngheGanDay = [
      {
        'title': 'Không Thể Say',
        'img': 'imgs/HIEUTHUHAI.jpg',
      },
      {
        'title': 'Chăm Hoa',
        'img': 'imgs/Chăm_hoa.jpg',
      },
      {'title': 'Perfect', 'img': 'imgs/Perfect.jpg'},
      {'title': '3107 3', 'img': 'imgs/3107_3.jpg'},
      {'title': 'K-Pop', 'img': 'imgs/K_POP.jpg'},
    ];

    final hot = [
      {
        'title': 'Mashup Nhạc Việt',
        'img': 'imgs/Mashup_Nhạc_Việt.jpg',
      },
      {'title': 'Cupid', 'img': 'imgs/cupid.jpg'},
      {
        'title': 'Ain’t My Fault',
        'img': 'imgs/aint_my_fault.jpg',
      },
      {
        'title': 'V-Pop Gây Bão',
        'img': 'imgs/V_Pop_Gây_Bão.jpg',
      },
    ];

    final charts = [
      {
        'title': 'Nhạc Lofi Chill',
        'img': 'imgs/Nhạc_Lofi_Chill.jpg',
      },
      {
        'title': 'Nhạc Buồn',
        'img': 'imgs/Nhạc_Buồn.jpg',
      },
      {'title': 'APT', 'img': 'imgs/Charts_Asia.jpg'},
      {'title': '3107 3', 'img': 'imgs/3107_3.jpg'},
      {
        'title': 'Playlist này Chill Phết',
        'img': 'imgs/Playlist_này_Chill_Phết.jpg',
      },
    ];

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
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
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

            // 🎶 Gợi ý bài hát
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
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "🎵 Đang phát tất cả bài hát!",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.play_circle_fill,
                        color: const Color.fromARGB(
                          255,
                          253,
                          119,
                          177,
                        ),
                      ),
                      label: const Text(
                        "Phát tất cả",
                        style: TextStyle(
                          color: const Color.fromARGB(
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
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "🔄 Danh sách đã làm mới!",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: const Color.fromARGB(
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

            // 🎵 Gợi ý bài hát
            SizedBox(
              height:
                  280, // Chiều cao cố định để chứa các cột
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: List.generate(
                    (goiYBaiHat.length / 3)
                        .ceil(), // số cột
                    (colIndex) {
                      return Column(
                        mainAxisAlignment:
                            MainAxisAlignment.start,
                        children: List.generate(3, (
                          rowIndex,
                        ) {
                          int index =
                              colIndex * 3 + rowIndex;
                          if (index >=
                              goiYBaiHat.length)
                            return const SizedBox();

                          final song =
                              goiYBaiHat[index];
                          return Container(
                            width: 180,
                            height:
                                80, // Chiều cao mỗi mục
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                            ), // Khoảng cách giữa các mục
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
                                        song['artist']!,
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
                                const Icon(
                                  Icons.more_vert,
                                  color:
                                      Colors.black54,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🕓 Nghe gần đây
            // 🕓 Nghe gần đây
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
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // 📊 Chill
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
