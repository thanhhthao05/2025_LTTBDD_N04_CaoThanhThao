/// WARNING: Storing secrets in client-side code is insecure. Move these values
/// to a secure backend before releasing the app.
const String spotifyClientId = 'b8e20a7d60dc4c6e9ee2b70c5aa7e797';
const String spotifyClientSecret = '2c10094554604df6a874c0525d28788c';
const String spotifyTokenEndpoint = 'https://accounts.spotify.com/api/token';
const String spotifyApiBaseUrl = 'https://api.spotify.com/v1';

/// Proxy server URL to avoid CORS issues on web
/// Set to null to use direct API calls (only works on mobile/desktop)
/// For web, you need to run the proxy server: cd spotify-proxy && npm install && npm start
const String? spotifyProxyUrl = 'http://localhost:3001';

/// Genre seeds for building recommendation sections on the home screen.
/// Values must exist in Spotify's /recommendations/available-genre-seeds list.
const List<String> spotifySuggestedSeedGenres = ['pop', 'dance', 'edm'];
const List<String> spotifyHotSeedGenres = ['k-pop', 'hip-hop', 'pop'];
const List<String> spotifyChillSeedGenres = ['chill', 'indie', 'acoustic'];

/// Artist IDs leveraged in the library screen.
const List<String> spotifyDefaultArtistIds = [
  '2Fl9QUYxpnG2o70x9EXpIr', // Vũ.
  '2q1d40J0FPIvh7KukTqGLf', // HIEUTHUHAI
  '3v3R7rK2KZgRsi3R5pM6fF', // MIN
];
