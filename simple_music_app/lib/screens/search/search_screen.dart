import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các danh mục
    final List<Map<String, String>> categories = [
      {'title': 'Podcast', 'img': 'imgs/Podcast.jpg'},
      {
        'title': 'Top Songs Global',
        'img': 'imgs/Top_Songs_Global.jpg',
      },
      {
        'title': 'Nhạc Chill Yêu Đời',
        'img': 'imgs/Nhạc_Chill_Yêu_Đời.jpg',
      },
      {
        'title': 'Top Thinh Hành',
        'img': 'imgs/Top_Thịnh_Hành.jpg',
      },
      {
        'title': 'Nhạc Trung',
        'img': 'imgs/Nhạc_Trung.jpg',
      },
      {'title': 'K-Pop', 'img': 'imgs/K_Pop.jpg'},
      {
        'title': 'Quang Hùng MasterD',
        'img': 'imgs/Quang_Hùng _MasterD.jpg',
      },
      {
        'title': 'Tâm trạng',
        'img': 'imgs/Tâm_trạng.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white, // ✅ Nền trắng
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Tìm kiếm",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(
              Icons.camera_alt_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 48, // Lề hai bên
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Ô tìm kiếm
            TextField(
              decoration: InputDecoration(
                hintText: "Bạn muốn nghe gì?",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              "Đề xuất cho bạn",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // 🧱 Lưới danh mục
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 cột
                      crossAxisSpacing:
                          36, // Khoảng cách ngang giữa các mục
                      mainAxisSpacing:
                          36, // Khoảng cách dọc giữa các mục
                      childAspectRatio: 1.2,
                    ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(
                          category['img']!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(
                        10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(
                              0.5,
                            ),
                            Colors.transparent,
                          ],
                          begin:
                              Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: Text(
                        category['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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
