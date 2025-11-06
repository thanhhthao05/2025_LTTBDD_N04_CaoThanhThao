import 'package:flutter/material.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../auth/auth_state.dart';
import '../home/notifications/whats_new_screen.dart';
import '../settings/settings_screen.dart';
import '../../player/recently_played_screen.dart';
import '../../player/player_screen.dart';
import '../../player/song_model.dart';
import 'favorite_songs_screen.dart';
import 'favorite_manager.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() =>
      _AccountScreenState();
}

class _AccountScreenState
    extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AuthState.isLoggedIn,
      builder: (context, isLoggedIn, _) {
        if (isLoggedIn) {
          // Lấy dữ liệu người dùng từ AuthState
          final userData = {
            'name': AuthState.username,
            'email': AuthState.email,
          };
          return _buildLoggedInUI(context, userData);
        }
        return _buildLoggedOutUI(context);
      },
    );
  }

  // Giao diện ĐÃ đăng nhập
  Widget _buildLoggedInUI(
    BuildContext context,
    Map<String, dynamic> userData,
  ) {
    final loc = AppLocalizations.of(context);
    // Danh sách playlist được gợi ý
    final List<Map<String, String>> suggested = [
      {
        'title': 'Tràn Bộ Nhớ',
        'img': 'imgs/Tràn_Bộ_Nhớ.jpg',
      },
      {
        'title': 'Bước Qua Nhau',
        'img': 'imgs/Buoc_Qua_Nhau.jpg',
      },
      {'title': 'Perfect', 'img': 'imgs/Perfect.jpg'},
      {'title': '3107 3', 'img': 'imgs/3107_3.jpg'},
    ];

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
          AppLocalizations.of(context).accountTitle,
          style:
              Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              // 👉 Chuyển sang màn hình What's New
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const WhatsNewScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              // 👉 Chuyển sang màn hình Settings
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    userName: AuthState.username,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 15),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),

            // Thông tin người dùng
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    Icons
                        .person, // 👤 Biểu tượng mặc định
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  "${loc.greeting}, ${userData['name']}",
                  style:
                      Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w600,
                          ) ??
                      const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            Text(
              AppLocalizations.of(
                context,
              ).yourPlaylists,
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ??
                  const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),

            // 🎧 Playlist của bạn (cập nhật động)
            ValueListenableBuilder<List<SongModel>>(
              valueListenable:
                  FavoriteManager.favoriteSongs,
              builder: (context, favoriteSongs, _) {
                final playlists = [
                  {
                    'icon': Icons.music_note,
                    'title': loc.recentlyPlayed,
                  },
                  {
                    'icon': Icons.favorite,
                    'title': loc.favoriteMusic,
                    'songs': favoriteSongs.length,
                  },
                ];

                return Column(
                  children: playlists.map((p) {
                    return ListTile(
                      leading: Icon(
                        p['icon'] as IconData,
                        color: Theme.of(context)
                            .iconTheme
                            .color
                            ?.withOpacity(0.95),
                      ),
                      title: Text(
                        p['title'] as String,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge,
                      ),
                      subtitle:
                          p['title'] ==
                              loc.favoriteMusic
                          ? Text(
                              "${p['songs']} ${AppLocalizations.of(context).songsTab}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).hintColor,
                                  ),
                            )
                          : null,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        if (p['title'] ==
                            loc.recentlyPlayed) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RecentlyPlayedScreen(),
                            ),
                          );
                        } else if (p['title'] ==
                            loc.favoriteMusic) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FavoriteSongsScreen(),
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 10),
            Divider(
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ),
            const SizedBox(height: 10),

            Text(
              AppLocalizations.of(
                context,
              ).suggestedPlaylists,
              style:
                  Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ??
                  const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),

            // --- Playlist được gợi ý (khi đã đăng nhập) ---
            Expanded(
              child: ListView.builder(
                itemCount: suggested.length,
                itemBuilder: (context, index) {
                  final s = suggested[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8),
                      child: Image.asset(
                        s['img']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(s['title']!),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerScreen(
                            songs: [
                              s,
                            ], // Truyền vào danh sách chứa 1 bài hát
                            currentIndex:
                                0, // Mở từ bài đầu tiên (chính bài được nhấn)
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Giao diện CHƯA đăng nhập
  Widget _buildLoggedOutUI(BuildContext context) {
    final suggested = [
      {
        'title': 'Tràn Bộ Nhớ',
        'img': 'imgs/Tràn_Bộ_Nhớ.jpg',
      },
      {
        'title': 'Bước Qua Nhau',
        'img': 'imgs/Buoc_Qua_Nhau.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Tài khoản",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Icon(
            Icons.notifications_none,
            color: Colors.black,
          ),
          SizedBox(width: 15),
          Icon(
            Icons.settings_outlined,
            color: Colors.black,
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black12,
                child: Icon(
                  Icons.person,
                  color: Colors.black54,
                  size: 55,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                AppLocalizations.of(
                  context,
                ).loginPrompt,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.deepPurple,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(25),
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                    ),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).loginButton,
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(25),
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                    ),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).signupButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 🎵 Thẻ đăng nhập để lưu nhạc yêu thích
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: Colors.black45,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(
                          context,
                        ).loginCardPrompt,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 🎧 Playlist được gợi ý
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Playlist được gợi ý",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // --- Playlist được gợi ý (khi chưa đăng nhập) ---
              Column(
                children: suggested.map((s) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8),
                      child: Image.asset(
                        s['img']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(s['title']!),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerScreen(
                            songs: [
                              s,
                            ], // Truyền vào danh sách chứa 1 bài hát
                            currentIndex:
                                0, // Mở từ bài đầu tiên (chính bài được nhấn)
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildEmptyCard() {
    return Container(
      height: 100,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          color: Colors.black38,
          size: 40,
        ),
      ),
    );
  }
}
