import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/spotify_config.dart';

class SpotifyTrack {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String? previewUrl;

  const SpotifyTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.previewUrl,
  });

  Map<String, String> toSongMap() => {
    'title': title,
    'artist': artist,
    'img': imageUrl,
    if (previewUrl != null) 'previewUrl': previewUrl!,
  };
}

class SpotifyArtist {
  final String id;
  final String name;
  final String imageUrl;

  const SpotifyArtist({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class SpotifyPlaylistSummary {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;

  const SpotifyPlaylistSummary({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });

  factory SpotifyPlaylistSummary.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>?;
    final imageUrl = images != null && images.isNotEmpty
        ? (images.first['url'] as String?)
        : null;

    return SpotifyPlaylistSummary(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Untitled playlist',
      description: json['description'] as String? ?? '',
      imageUrl: imageUrl,
    );
  }
}

class SpotifyService {
  SpotifyService({http.Client? client, FlutterSecureStorage? storage})
    : _client = client ?? http.Client(),
      _secureStorage = storage ?? const FlutterSecureStorage();

  final http.Client _client;
  final FlutterSecureStorage _secureStorage;

  static const _tokenKey = 'spotify_access_token';
  static const _tokenExpiryKey = 'spotify_access_token_expiry';

  /// Check if we should use proxy (web platform and proxy URL is set)
  bool get _shouldUseProxy => kIsWeb && spotifyProxyUrl != null;

  Future<String> _getAccessToken() async {
    final cachedToken = await _secureStorage.read(key: _tokenKey);
    final expiryString = await _secureStorage.read(key: _tokenExpiryKey);
    if (cachedToken != null && expiryString != null) {
      final expiry = DateTime.tryParse(expiryString);
      if (expiry != null &&
          expiry.isAfter(DateTime.now().add(const Duration(minutes: 1)))) {
        return cachedToken;
      }
    }

    final credentials = base64Encode(
      utf8.encode('$spotifyClientId:$spotifyClientSecret'),
    );
    final response = await _client.post(
      Uri.parse(spotifyTokenEndpoint),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to obtain Spotify token (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final token = decoded['access_token'] as String;
    final expiresIn = decoded['expires_in'] as int? ?? 3600;
    final expiry = DateTime.now().add(Duration(seconds: expiresIn));

    await _secureStorage.write(key: _tokenKey, value: token);
    await _secureStorage.write(
      key: _tokenExpiryKey,
      value: expiry.toIso8601String(),
    );

    return token;
  }

  Future<List<SpotifyPlaylistSummary>> fetchFeaturedPlaylists() async {
    if (_shouldUseProxy) {
      final proxyUri = Uri.parse(
        '$spotifyProxyUrl/api/browse/new-releases',
      ).replace(queryParameters: {'limit': '10', 'country': 'US'});
      final response = await _client.get(proxyUri);
      if (response.statusCode == 404) {
        debugPrint('Spotify new releases not found for current params.');
        return const [];
      }
      if (response.statusCode != 200) {
        throw Exception(
          'Spotify API error ${response.statusCode}: ${response.body}',
        );
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final albums = decoded['albums'] as Map<String, dynamic>?;
      final items = albums?['items'] as List<dynamic>? ?? [];
      return items.map((item) {
        final json = item as Map<String, dynamic>;
        final images = json['images'] as List<dynamic>?;
        final imageUrl = images != null && images.isNotEmpty
            ? (images.first['url'] as String?)
            : null;
        return SpotifyPlaylistSummary(
          id: json['id'] as String,
          name: json['name'] as String? ?? 'Unknown release',
          description: (json['artists'] as List<dynamic>? ?? [])
              .map(
                (artist) =>
                    (artist as Map<String, dynamic>)['name'] as String? ?? '',
              )
              .where((name) => name.isNotEmpty)
              .join(', '),
          imageUrl: imageUrl,
        );
      }).toList();
    }

    final token = await _getAccessToken();
    final uri = Uri.https('api.spotify.com', '/v1/browse/new-releases', {
      'limit': '10',
      'country': 'US',
    });
    final response = await _client.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 404) {
      debugPrint('Spotify new releases not found for current params.');
      return const [];
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Spotify API error ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final albums = decoded['albums'] as Map<String, dynamic>?;
    final items = albums?['items'] as List<dynamic>? ?? [];

    return items.map((item) {
      final json = item as Map<String, dynamic>;
      final images = json['images'] as List<dynamic>?;
      final imageUrl = images != null && images.isNotEmpty
          ? (images.first['url'] as String?)
          : null;
      return SpotifyPlaylistSummary(
        id: json['id'] as String,
        name: json['name'] as String? ?? 'Unknown release',
        description: (json['artists'] as List<dynamic>? ?? [])
            .map(
              (artist) =>
                  (artist as Map<String, dynamic>)['name'] as String? ?? '',
            )
            .where((name) => name.isNotEmpty)
            .join(', '),
        imageUrl: imageUrl,
      );
    }).toList();
  }

  /// Fetch tracks by genre using search (recommendations endpoint is deprecated)
  /// This method uses search to find popular tracks in the specified genres
  /// Note: Spotify has reduced preview URLs, so not all tracks will have preview
  Future<List<SpotifyTrack>> fetchRecommendations({
    List<String>? seedGenres,
    List<String>? seedArtists,
    List<String>? seedTracks,
    int limit = 20,
  }) async {
    // Use search instead of recommendations endpoint (which is deprecated)
    // Try multiple search queries to find tracks with preview URLs
    final searchQueries = <String>[];

    if (seedGenres?.isNotEmpty == true) {
      // Try multiple genre-related queries
      for (final genre in seedGenres!.take(3)) {
        searchQueries.add(genre);
        searchQueries.add('$genre hit');
        searchQueries.add('$genre popular');
      }
    } else if (seedArtists?.isNotEmpty == true) {
      searchQueries.add(seedArtists!.first);
    } else {
      searchQueries.add('popular');
      searchQueries.add('top hits');
      searchQueries.add('chart');
    }

    debugPrint(
      'Using search instead of recommendations: ${searchQueries.join(", ")}',
    );

    // Search với nhiều queries và gộp kết quả
    final allResults = <SpotifyTrack>[];
    final searchLimit = (limit * 2).clamp(1, 50);

    for (final query in searchQueries.take(3)) {
      try {
        final results = await searchTracks(query, limit: searchLimit);
        allResults.addAll(results);
        // Nếu đã có đủ bài có preview, dừng lại
        final withPreview = allResults
            .where((t) => t.previewUrl != null && t.previewUrl!.isNotEmpty)
            .length;
        if (withPreview >= limit) break;
      } catch (e) {
        debugPrint('Search query "$query" failed: $e');
      }
    }

    // Loại bỏ duplicates
    final uniqueResults = <String, SpotifyTrack>{};
    for (final track in allResults) {
      if (!uniqueResults.containsKey(track.id)) {
        uniqueResults[track.id] = track;
      }
    }
    final deduplicated = uniqueResults.values.toList();

    // Ưu tiên bài có preview URL
    final withPreview = deduplicated
        .where((t) => t.previewUrl != null && t.previewUrl!.isNotEmpty)
        .toList();
    final withoutPreview = deduplicated
        .where((t) => t.previewUrl == null || t.previewUrl!.isEmpty)
        .toList();

    debugPrint(
      'Recommendations: ${deduplicated.length} total, ${withPreview.length} with preview, ${withoutPreview.length} without preview',
    );

    // Trả về bài có preview trước, sau đó mới đến bài không có preview
    final result = [...withPreview, ...withoutPreview];
    return result.take(limit).toList();
  }

  Future<List<SpotifyTrack>> fetchArtistTopTracks(String artistId) async {
    if (_shouldUseProxy) {
      final proxyUri = Uri.parse(
        '$spotifyProxyUrl/api/artists/$artistId/top-tracks',
      ).replace(queryParameters: {'market': 'US'});
      final response = await _client.get(proxyUri);
      if (response.statusCode != 200) {
        throw Exception(
          'Spotify artist top-tracks error ${response.statusCode}: ${response.body}',
        );
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final items = decoded['tracks'] as List<dynamic>? ?? [];
      return items
          .map((raw) => _trackFromTrackObject(raw as Map<String, dynamic>))
          .whereType<SpotifyTrack>()
          .toList();
    }

    final token = await _getAccessToken();
    final uri = Uri.https(
      'api.spotify.com',
      '/v1/artists/$artistId/top-tracks',
      {'market': 'US'},
    );
    final response = await _client.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Spotify artist top-tracks error ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final items = decoded['tracks'] as List<dynamic>? ?? [];

    return items
        .map((raw) => _trackFromTrackObject(raw as Map<String, dynamic>))
        .whereType<SpotifyTrack>()
        .toList();
  }

  Future<SpotifyArtist?> fetchArtistProfile(String artistId) async {
    if (_shouldUseProxy) {
      final proxyUri = Uri.parse('$spotifyProxyUrl/api/artists/$artistId');
      final response = await _client.get(proxyUri);
      if (response.statusCode != 200) {
        debugPrint(
          'Spotify artist profile error ${response.statusCode}: ${response.body}',
        );
        return null;
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final images = decoded['images'] as List<dynamic>?;
      final imageUrl = images != null && images.isNotEmpty
          ? (images.first['url'] as String?)
          : 'https://via.placeholder.com/300x300.png?text=No+Image';

      return SpotifyArtist(
        id: decoded['id'] as String,
        name: decoded['name'] as String? ?? 'Unknown artist',
        imageUrl:
            imageUrl ?? 'https://via.placeholder.com/300x300.png?text=No+Image',
      );
    }

    final token = await _getAccessToken();
    final response = await _client.get(
      Uri.parse('$spotifyApiBaseUrl/artists/$artistId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      debugPrint(
        'Spotify artist profile error ${response.statusCode}: ${response.body}',
      );
      return null;
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final images = decoded['images'] as List<dynamic>?;
    final imageUrl = images != null && images.isNotEmpty
        ? (images.first['url'] as String?)
        : 'https://via.placeholder.com/300x300.png?text=No+Image';

    return SpotifyArtist(
      id: decoded['id'] as String,
      name: decoded['name'] as String? ?? 'Unknown artist',
      imageUrl:
          imageUrl ?? 'https://via.placeholder.com/300x300.png?text=No+Image',
    );
  }

  Future<List<SpotifyTrack>> searchTracks(
    String query, {
    int limit = 20,
  }) async {
    if (query.trim().isEmpty) return const [];

    if (_shouldUseProxy) {
      final proxyUri = Uri.parse('$spotifyProxyUrl/api/search').replace(
        queryParameters: {'q': query, 'type': 'track', 'limit': '$limit'},
      );
      final response = await _client.get(proxyUri);
      if (response.statusCode != 200) {
        throw Exception(
          'Spotify search error ${response.statusCode}: ${response.body}',
        );
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final tracks = decoded['tracks'] as Map<String, dynamic>?;
      final items = tracks?['items'] as List<dynamic>? ?? [];

      final allTracks = items
          .map((raw) => _trackFromTrackObject(raw as Map<String, dynamic>))
          .whereType<SpotifyTrack>()
          .toList();

      // Filter và ưu tiên bài có preview URL
      final tracksWithPreview = allTracks
          .where((t) => t.previewUrl != null && t.previewUrl!.isNotEmpty)
          .toList();
      final tracksWithoutPreview = allTracks
          .where((t) => t.previewUrl == null || t.previewUrl!.isEmpty)
          .toList();

      debugPrint(
        'Proxy search results: ${allTracks.length} total, ${tracksWithPreview.length} with preview, ${tracksWithoutPreview.length} without preview',
      );

      // Ưu tiên bài có preview, sau đó mới đến bài không có preview
      final result = [...tracksWithPreview, ...tracksWithoutPreview];
      return result.take(limit).toList();
    }

    final token = await _getAccessToken();
    final response = await _client.get(
      Uri.parse(
        '$spotifyApiBaseUrl/search?q=${Uri.encodeComponent(query)}&type=track&limit=$limit',
      ),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Spotify search error ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final tracks = decoded['tracks'] as Map<String, dynamic>?;
    final items = tracks?['items'] as List<dynamic>? ?? [];

    final allTracks = items
        .map((raw) => _trackFromTrackObject(raw as Map<String, dynamic>))
        .whereType<SpotifyTrack>()
        .toList();

    // Filter và ưu tiên bài có preview URL
    final tracksWithPreview = allTracks
        .where((t) => t.previewUrl != null && t.previewUrl!.isNotEmpty)
        .toList();
    final tracksWithoutPreview = allTracks
        .where((t) => t.previewUrl == null || t.previewUrl!.isEmpty)
        .toList();

    debugPrint(
      'Search results: ${allTracks.length} total, ${tracksWithPreview.length} with preview, ${tracksWithoutPreview.length} without preview',
    );

    // Ưu tiên bài có preview, sau đó mới đến bài không có preview
    final result = [...tracksWithPreview, ...tracksWithoutPreview];
    return result.take(limit).toList();
  }

  @visibleForTesting
  Future<void> clearTokenCache() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _tokenExpiryKey);
  }

  SpotifyTrack? _trackFromTrackObject(Map<String, dynamic> json) {
    final album = json['album'] as Map<String, dynamic>?;
    final images = album?['images'] as List<dynamic>?;
    final imageUrl = images != null && images.isNotEmpty
        ? (images.first['url'] as String?)
        : 'https://via.placeholder.com/300x300.png?text=No+Image';
    final artists = json['artists'] as List<dynamic>? ?? [];
    final artistName = artists.isNotEmpty
        ? (artists.first as Map<String, dynamic>)['name'] as String? ?? ''
        : '';

    return SpotifyTrack(
      id: json['id'] as String,
      title: json['name'] as String? ?? 'Unknown track',
      artist: artistName,
      imageUrl:
          imageUrl ?? 'https://via.placeholder.com/300x300.png?text=No+Image',
      previewUrl: json['preview_url'] as String?,
    );
  }
}
