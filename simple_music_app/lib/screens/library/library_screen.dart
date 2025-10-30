import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các nghệ sĩ và playlist
    final List<Map<String, String>> libraryItems = [
      {
        'name': 'Vũ.',
        'type': 'Nghệ sĩ',
        'img': 'imgs/Vũ.jpg',
      },
      {
        'name': 'HIEUTHUHAI',
        'type': 'Nghệ sĩ',
        'img': 'imgs/HIEUTHUHAI.jpg',
      },
      {
        'name': 'Nhạc Chill',
        'type': 'Playlist',
        'img': 'imgs/Nhạc_Chill_Yêu_Đời.jpg',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Thư viện của bạn",
          // Tiêu đề AppBar
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 15),
          Icon(Icons.add, color: Colors.black),
          SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút "Nghệ sĩ
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: const Text(
                "Nghệ sĩ",
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // thanh ngang mảnh
            const Divider(
              color: Colors.black26,
              thickness: 1,
              height: 20,
            ),

            // Tiêu đề "Tìm kiếm gần đây"
            const Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.swap_vert,
                      color: Colors.black54,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Tìm Kiếm gần đây",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.grid_view_rounded,
                  color: Colors.black54,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Danh sách nghệ sĩ / playlist
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (
                      int i = 0;
                      i < libraryItems.length;
                      i++
                    ) ...[
                      ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(
                            libraryItems[i]['img']!,
                          ),
                        ),
                        title: Text(
                          libraryItems[i]['name']!,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          libraryItems[i]['type']!,
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],

                    // Thêm 2 nút Add
                    const ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Colors.black12,
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(
                        "Thêm nghệ sĩ",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Colors.black12,
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(
                        "Thêm podcast và chương trình",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
