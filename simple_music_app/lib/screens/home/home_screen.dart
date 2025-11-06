import 'package:flutter/material.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';
import './notifications/whats_new_screen.dart';
import '../../player/recently_played_screen.dart';
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
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(
              context,
            ).appBarTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).homeTitle,
          style: const TextStyle(
            // color will follow theme's text style
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              // color will follow theme
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
            // 🔘 Thanh chọn Music
            Row(
              children: [
                FilterChip(
                  label: Text(
                    AppLocalizations.of(
                      context,
                    ).musicLabel,
                  ),
                  selected: true,
                  backgroundColor: Theme.of(
                    context,
                  ).cardColor,
                  selectedColor: const Color.fromARGB(
                    255,
                    253,
                    119,
                    177,
                  ).withOpacity(0.1),
                  labelStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium,
                  onSelected: (_) {},
                ),
                const SizedBox(width: 8),
              ],
            ),

            const SizedBox(height: 16),

            // 🎶 Gợi ý bài hát
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(
                    context,
                  ).suggestedSongs,
                  style: const TextStyle(
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
                                  currentIndex: 0,
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
                      label: Text(
                        AppLocalizations.of(
                          context,
                        ).playAll,
                        style: const TextStyle(
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
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(
                                context,
                              ).suggestionsRefreshed,
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

            // 🎵 Gợi ý bài hát - layout ngang nhiều cột
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
                                          AppLocalizations.of(
                                            context,
                                          ).addedToPlaylist(
                                            song['title'] ??
                                                '',
                                          ),
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
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    ).recentlyPlayed,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
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
            Text(
              AppLocalizations.of(context).hotToday,
              style: const TextStyle(
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

            // 📊 Chill
            Text(
              AppLocalizations.of(context).chill,
              style: const TextStyle(
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
