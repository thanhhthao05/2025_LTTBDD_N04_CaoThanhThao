import 'package:flutter/material.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';
import '../search/search_screen.dart';
import 'artist_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() =>
      _LibraryScreenState();
}

class _LibraryScreenState
    extends State<LibraryScreen> {
  // Danh sách nghệ sĩ có sẵn
  final List<Map<String, dynamic>> libraryItems = [
    {
      'name': 'Vũ',
      'type': 'Nghệ sĩ',
      'img': 'imgs/Vũ.jpg',
      'songs': [
        {
          'title': 'Lạ Lùng',
          'artist': 'Vũ',
          'img': 'imgs/La_Lung.jpg',
        },
        {
          'title': 'Bước Qua Nhau',
          'artist': 'Vũ',
          'img': 'imgs/Buoc_Qua_Nhau.jpg',
        },
        {
          'title': 'Mùa Mưa Ngâu Nằm Cạnh',
          'artist': 'Vũ',
          'img': 'imgs/Mua_Mua_Ngau_Nam_Canh.jpg',
        },
      ],
    },
    {
      'name': 'HIEUTHUHAI',
      'type': 'Nghệ sĩ',
      'img': 'imgs/HIEUTHUHAI.jpg',
      'songs': [
        {
          'title': 'Không Thể Say',
          'artist': 'HIEUTHUHAI',
          'img': 'imgs/Khong_The_Say.jpg',
        },
        {
          'title': 'Vệ Tinh',
          'artist': 'HIEUTHUHAI',
          'img': 'imgs/Ve_Tinh.jpg',
        },
        {
          'title': 'Ngáo Ngơ',
          'artist': 'HIEUTHUHAI',
          'img': 'imgs/Ngao_Ngo.jpg',
        },
      ],
    },
    {
      'name': 'MIN',
      'type': 'Nghệ sĩ',
      'img': 'imgs/MIN.jpg',
      'songs': [
        {
          'title': 'Ghen',
          'artist': 'MIN',
          'img': 'imgs/Ghen.jpg',
        },
        {
          'title': 'Có Em Chờ',
          'artist': 'MIN',
          'img': 'imgs/Co_Em_Cho.jpg',
        },
        {
          'title': 'Vì Yêu Cứ Đâm Đầu',
          'artist': 'MIN',
          'img': 'imgs/Vi_Yeu_Cu_Dam_Dau.jpg',
        },
      ],
    },
  ];

  // 🎵 Hàm thêm nghệ sĩ mới
  void _addNewArtist() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final imgController = TextEditingController();

        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).addArtist,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Tên nghệ sĩ",
                ),
              ),
              TextField(
                controller: imgController,
                decoration: const InputDecoration(
                  labelText:
                      "Đường dẫn ảnh (ví dụ: imgs/NewArtist.jpg)",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context).cancel,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    libraryItems.add({
                      'name': nameController.text,
                      'type': 'Nghệ sĩ',
                      'img':
                          imgController.text.isNotEmpty
                          ? imgController.text
                          : 'imgs/default_artist.jpg',
                      'songs': [],
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(
                AppLocalizations.of(context).add,
              ),
            ),
          ],
        );
      },
    );
  }

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
          AppLocalizations.of(context).libraryTitle,
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
              Icons.search,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SearchScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Nút "Nghệ sĩ"
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: Text(
                AppLocalizations.of(context).artists,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Tiêu đề "Tìm kiếm gần đây"
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.swap_vert,
                  color:
                      Theme.of(context).iconTheme.color
                          ?.withOpacity(0.7) ??
                      Colors.black54,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(
                    context,
                  ).searchHistory,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.7) ??
                            Colors.black54,
                      ) ??
                      const TextStyle(
                        color: Colors.black54,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Danh sách nghệ sĩ
            Expanded(
              child: ListView.builder(
                itemCount:
                    libraryItems.length +
                    1, // chỉ thêm "Thêm nghệ sĩ"
                itemBuilder: (context, index) {
                  if (index < libraryItems.length) {
                    final item = libraryItems[index];
                    return _buildLibraryItem(
                      context,
                      item,
                    );
                  } else {
                    return _buildAddItem(
                      AppLocalizations.of(
                        context,
                      ).addArtist,
                      _addNewArtist,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 Hàm tạo item nghệ sĩ
  Widget _buildLibraryItem(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: AssetImage(item['img']!),
      ),
      title: Text(
        item['name']!,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        item['type']!,
        style:
            Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ) ??
            const TextStyle(color: Colors.black54),
      ),
      onTap: () {
        if (item['type'] == 'Nghệ sĩ' &&
            item['songs'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtistDetailScreen(
                artistName: item['name']!,
                songs: List<Map<String, String>>.from(
                  item['songs'],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // 🧩 Hàm tạo nút “Thêm nghệ sĩ”
  Widget _buildAddItem(
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.surfaceVariant,
        child: Icon(
          Icons.add,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
    );
  }
}
