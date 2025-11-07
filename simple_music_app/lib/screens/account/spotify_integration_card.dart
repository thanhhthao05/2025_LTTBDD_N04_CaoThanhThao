import 'package:flutter/material.dart';

import '../../services/spotify_service.dart';

class SpotifyIntegrationCard extends StatefulWidget {
  const SpotifyIntegrationCard({super.key});

  @override
  State<SpotifyIntegrationCard> createState() => _SpotifyIntegrationCardState();
}

class _SpotifyIntegrationCardState extends State<SpotifyIntegrationCard> {
  final SpotifyService _service = SpotifyService();
  Future<List<SpotifyPlaylistSummary>>? _featuredFuture;
  String? _errorMessage;

  void _loadFeaturedPlaylists() {
    setState(() {
      _errorMessage = null;
      _featuredFuture = _service.fetchFeaturedPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Spotify new releases',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: _loadFeaturedPlaylists,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Lấy dữ liệu'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Ví dụ gọi Spotify Web API (new releases) bằng Client Credentials Flow. '
              'Không yêu cầu đăng nhập người dùng.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            if (_featuredFuture == null)
              Center(
                child: Column(
                  children: const [
                    Icon(Icons.music_note, size: 48, color: Colors.purpleAccent),
                    SizedBox(height: 8),
                    Text('Nhấn "Lấy dữ liệu" để xem album mới phát hành.'),
                  ],
                ),
              )
            else
              FutureBuilder<List<SpotifyPlaylistSummary>>(
                future: _featuredFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    _errorMessage = snapshot.error?.toString();
                    return Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    );
                  }
                  final data = snapshot.data;
                  if (data == null || data.isEmpty) {
                    return const Text('Không có album nào được trả về.');
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    separatorBuilder: (_, __) => const Divider(height: 20),
                    itemBuilder: (context, index) {
                      final playlist = data[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (playlist.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                playlist.imageUrl!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                              ),
                            )
                          else
                            Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.purple.shade100,
                              ),
                              child: const Icon(Icons.music_note, color: Colors.white70),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playlist.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                if (playlist.description.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      playlist.description,
                                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

