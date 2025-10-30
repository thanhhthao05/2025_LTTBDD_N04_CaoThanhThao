import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../auth/auth_state.dart';

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
    final List<Map<String, dynamic>> playlists = [
      {
        'icon': Icons.music_note,
        'title': 'My Chill Vibes',
        'songs': 18,
      },
      {
        'icon': Icons.favorite,
        'title': 'Nhạc yêu thích',
        'songs': 24,
      },
    ];

    final List<Map<String, String>> suggested = [
      {
        'title': 'Nhạc Chill Yêu Đời',
        'img': 'imgs/Nhạc_Chill_Yêu_Đời.jpg',
      },
      {
        'title': 'HIEUTHUHAI',
        'img': 'imgs/HIEUTHUHAI.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Tài khoản của tôi",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),

            // Thông tin người dùng
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xFFD9C6FF),
                ),
                const SizedBox(width: 15),
                Text(
                  "Xin chào, ${userData['name']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            const Text(
              "Playlist của bạn",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            for (final p in playlists)
              ListTile(
                leading: Icon(
                  p['icon'] as IconData,
                  color: Colors.black87,
                ),
                title: Text(p['title'] as String),
                subtitle: Text(
                  "${p['songs']} bài hát",
                ),
                dense: true,
                contentPadding: EdgeInsets.zero,
                onTap: () {},
              ),

            const SizedBox(height: 10),
            const Divider(
              thickness: 1,
              color: Colors.black12,
            ),
            const SizedBox(height: 10),

            const Text(
              "Playlist được gợi ý",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

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
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {},
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Nút đăng xuất
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    AuthState.isLoggedIn.value = false;
                    AuthState.username = '';
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Đăng xuất"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(
                          255,
                          248,
                          157,
                          210,
                        ),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Giao diện CHƯA đăng nhập
  Widget _buildLoggedOutUI(BuildContext context) {
    final suggested = [
      {
        'title': 'Nhạc Chill Yêu Đời',
        'img': 'imgs/Nhạc_Chill_Yêu_Đời.jpg',
      },
      {
        'title': 'HIEUTHUHAI',
        'img': 'imgs/HIEUTHUHAI.jpg',
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
              const Text(
                "Đăng nhập để lưu nhạc yêu thích\nvà tạo playlist cá nhân của bạn!",
                textAlign: TextAlign.center,
                style: TextStyle(
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
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(
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
                    child: const Text(
                      "Đăng ký",
                      style: TextStyle(
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
                child: const Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Colors.black45,
                        size: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Đăng nhập để lưu nhạc yêu thích\nvà tạo playlist cá nhân của bạn!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {},
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
