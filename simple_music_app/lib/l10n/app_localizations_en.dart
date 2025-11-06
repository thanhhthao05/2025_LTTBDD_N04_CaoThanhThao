// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Simple Music App';

  @override
  String get homeTitle => 'Home';

  @override
  String get searchTitle => 'Search';

  @override
  String get libraryTitle => 'Library';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get darkModeTitle => 'Dark Mode';

  @override
  String get darkModeSubtitle => 'Toggle dark theme';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSettingTitle => 'Display language';

  @override
  String get saveDataTitle => 'Save Data';

  @override
  String get saveDataSubtitle => 'Reduce audio quality and hide images';

  @override
  String get suggestedSongs => 'Suggested songs';

  @override
  String get playAll => 'Play all';

  @override
  String get recentlyPlayed => 'Recently played';

  @override
  String get hotToday => 'Top today';

  @override
  String get chill => 'Chill';

  @override
  String get accountTitle => 'Account';

  @override
  String get nowPlaying => 'Now playing';

  @override
  String get suggestionsRefreshed => '✨ Suggestions refreshed!';

  @override
  String addedToPlaylist(Object title) {
    return 'Added \'$title\' to playlist.';
  }

  @override
  String get musicLabel => 'Music';

  @override
  String get searchHint => 'Search songs, artists...';

  @override
  String get searchHistory => 'Search history';

  @override
  String get clear => 'CLEAR';

  @override
  String get noResults => 'No matching results 😢';

  @override
  String get whatsNew => 'What\'s new';

  @override
  String get songsTab => 'Songs';

  @override
  String get albumTab => 'Albums';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get earlier => 'Earlier';

  @override
  String get artists => 'Artists';

  @override
  String get addArtist => 'Add artist';

  @override
  String get add => 'Add';

  @override
  String get cancel => 'Cancel';

  @override
  String get yourPlaylists => 'Your Playlists';

  @override
  String get suggestedPlaylists => 'Suggested playlists';

  @override
  String get favoriteMusic => 'Favorite music';

  @override
  String get addNewSong => 'Add new song';

  @override
  String get playingSongSnackbar => 'Playing song';

  @override
  String get addedToPlaylistShort => 'Added to playlist';

  @override
  String get removedFromPlaylist => 'Removed from playlist';

  @override
  String get loginButton => 'LOGIN';

  @override
  String get signupButton => 'SIGN UP';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get nameHint => 'Name';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get haveAccount => 'Already have an account? Login';

  @override
  String get greeting => 'Hello';

  @override
  String get loginPrompt => 'Login to save favorite music\nand create personal playlists!';

  @override
  String get loginCardPrompt => 'Login to save favorite music and create personal playlists!';

  @override
  String get imagePathHint => 'Image path (e.g., imgs/NewSong.jpg)';

  @override
  String get logout => 'Logout';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';
}
