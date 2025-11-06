// Minimal fallback AppLocalizations shim to satisfy imports until `flutter gen-l10n` is run.
// This file is intentionally small and returns a few keys used by the app.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final instance =
        Localizations.of<AppLocalizations>(
          context,
          AppLocalizations,
        );
    assert(
      instance != null,
      'No AppLocalizations found in context. Did you add localizationsDelegates?',
    );
    return instance!;
  }

  static const LocalizationsDelegate<AppLocalizations>
  delegate = _AppLocalizationsDelegate();

  // Provide a small set of keys used across the app. Add more as needed.
  String get appTitle => locale.languageCode == 'en'
      ? 'Simple Music App'
      : 'Simple Music App';
  String get homeTitle => locale.languageCode == 'en'
      ? 'Home'
      : 'Xin chào';
  String get accountTitle =>
      locale.languageCode == 'en'
      ? 'Account'
      : 'Tài khoản';
  String get searchTitle => locale.languageCode == 'en'
      ? 'Search'
      : 'Tìm kiếm';
  String get libraryTitle =>
      locale.languageCode == 'en'
      ? 'Library'
      : 'Thư viện';
  String get settingsTitle =>
      locale.languageCode == 'en'
      ? 'Settings'
      : 'Cài đặt';
  String get darkModeTitle =>
      locale.languageCode == 'en'
      ? 'Dark Mode'
      : 'Chế độ tối';
  String get darkModeSubtitle =>
      locale.languageCode == 'en'
      ? 'Toggle dark theme'
      : 'Bật/tắt giao diện nền tối';
  String get languageTitle =>
      locale.languageCode == 'en'
      ? 'Language'
      : 'Ngôn ngữ';
  String get languageSettingTitle =>
      locale.languageCode == 'en'
      ? 'Display language'
      : 'Ngôn ngữ hiển thị';
  String get saveDataTitle =>
      locale.languageCode == 'en'
      ? 'Save Data'
      : 'Tiết kiệm dữ liệu';
  String get saveDataSubtitle =>
      locale.languageCode == 'en'
      ? 'Reduce audio quality and hide images'
      : 'Giảm chất lượng âm thanh và ẩn hình ảnh';
  String get logout => locale.languageCode == 'en'
      ? 'Logout'
      : 'Đăng xuất';

  // Settings specific
  String get videoPodcasts =>
      locale.languageCode == 'en'
      ? 'Video Podcasts'
      : 'Video Podcasts';
  String get downloadAudioOnlyTitle =>
      locale.languageCode == 'en'
      ? 'Download audio only'
      : 'Chỉ tải âm thanh';
  String get downloadAudioOnlySubtitle =>
      locale.languageCode == 'en'
      ? 'Only save video podcasts as audio.'
      : 'Chỉ lưu podcast video ở dạng âm thanh.';
  String get streamAudioOnlyTitle =>
      locale.languageCode == 'en'
      ? 'Stream audio only when no Wi‑Fi'
      : 'Chỉ phát âm thanh khi không có Wi‑Fi';
  String get streamAudioOnlySubtitle =>
      locale.languageCode == 'en'
      ? 'Play video podcasts as audio when there is no Wi‑Fi.'
      : 'Phát podcast video dưới dạng âm thanh khi không có Wi‑Fi.';

  String get premiumUpgradePrompt =>
      locale.languageCode == 'en'
      ? 'Upgrade for the best experience'
      : 'Nâng cấp để có trải nghiệm tốt nhất';
  String get upgradePremiumButton =>
      locale.languageCode == 'en'
      ? 'Upgrade to Premium'
      : 'Nâng cấp Premium';
  String get freeUser => locale.languageCode == 'en'
      ? 'Free user'
      : 'Người dùng miễn phí';

  String get chooseLanguage =>
      locale.languageCode == 'en'
      ? 'Choose language'
      : 'Chọn ngôn ngữ';
  String get englishLabel =>
      locale.languageCode == 'en'
      ? 'English'
      : 'English';
  String get vietnameseLabel =>
      locale.languageCode == 'en'
      ? 'Tiếng Việt'
      : 'Tiếng Việt';

  // Keys added for HomeScreen
  String get suggestedSongs =>
      locale.languageCode == 'en'
      ? 'Suggested songs'
      : 'Gợi ý bài hát';
  String get playAll => locale.languageCode == 'en'
      ? 'Play all'
      : 'Phát tất cả';
  String get recentlyPlayed =>
      locale.languageCode == 'en'
      ? 'Recently played'
      : 'Nghe gần đây';
  String get hotToday => locale.languageCode == 'en'
      ? 'Top today'
      : 'Hot nhất hôm nay';
  String get chill =>
      locale.languageCode == 'en' ? 'Chill' : 'Chill';
  String get nowPlaying => locale.languageCode == 'en'
      ? 'Now playing'
      : 'Đang phát';
  String get suggestionsRefreshed =>
      locale.languageCode == 'en'
      ? '✨ Suggestions refreshed!'
      : '✨ Danh sách gợi ý đã làm mới!';
  String addedToPlaylist(String title) =>
      locale.languageCode == 'en'
      ? "Added '$title' to playlist."
      : "Đã thêm '$title' vào danh sách phát.";
  String get musicLabel => locale.languageCode == 'en'
      ? 'Music'
      : 'Âm nhạc';
  String get searchHint => locale.languageCode == 'en'
      ? 'Search songs, artists...'
      : 'Tìm kiếm bài hát, nghệ sĩ...';
  String get searchHistory =>
      locale.languageCode == 'en'
      ? 'Search history'
      : 'Lịch sử tìm kiếm';
  String get clear =>
      locale.languageCode == 'en' ? 'CLEAR' : 'XÓA';
  String get noResults => locale.languageCode == 'en'
      ? 'No matching results 😢'
      : 'Không tìm thấy kết quả phù hợp 😢';
  String get whatsNew => locale.languageCode == 'en'
      ? "What's new"
      : 'Có gì mới';
  String get songsTab => locale.languageCode == 'en'
      ? 'Songs'
      : 'Bài hát';
  String get albumTab =>
      locale.languageCode == 'en' ? 'Albums' : 'Album';
  String get today => locale.languageCode == 'en'
      ? 'Today'
      : 'Hôm nay';
  String get yesterday => locale.languageCode == 'en'
      ? 'Yesterday'
      : 'Hôm qua';
  String get earlier => locale.languageCode == 'en'
      ? 'Earlier'
      : 'Trước đó';
  String get artists => locale.languageCode == 'en'
      ? 'Artists'
      : 'Nghệ sĩ';
  String get addArtist => locale.languageCode == 'en'
      ? 'Add artist'
      : 'Thêm nghệ sĩ';
  String get add =>
      locale.languageCode == 'en' ? 'Add' : 'Thêm';
  String get cancel =>
      locale.languageCode == 'en' ? 'Cancel' : 'Hủy';
  String get yourPlaylists =>
      locale.languageCode == 'en'
      ? 'Your Playlists'
      : 'Playlist của bạn';
  String get suggestedPlaylists =>
      locale.languageCode == 'en'
      ? 'Suggested playlists'
      : 'Playlist được gợi ý';
  String get favoriteMusic =>
      locale.languageCode == 'en'
      ? 'Favorite music'
      : 'Nhạc yêu thích';

  String get addNewSong => locale.languageCode == 'en'
      ? 'Add new song'
      : 'Thêm bài hát mới';
  String get playingSongSnackbar =>
      locale.languageCode == 'en'
      ? 'Playing song...'
      : '🎧 Đang phát bài hát...';
  String get addedToPlaylistShort =>
      locale.languageCode == 'en'
      ? 'Added to playlist'
      : '➕ Đã thêm vào danh sách phát';
  String get removedFromPlaylist =>
      locale.languageCode == 'en'
      ? 'Removed from playlist'
      : '🗑 Đã xóa khỏi danh sách phát';
  String get loginButton => locale.languageCode == 'en'
      ? 'LOGIN'
      : 'ĐĂNG NHẬP';
  String get signupButton =>
      locale.languageCode == 'en'
      ? 'SIGN UP'
      : 'ĐĂNG KÝ';
  String get emailHint =>
      locale.languageCode == 'en' ? 'Email' : 'Email';
  String get passwordHint =>
      locale.languageCode == 'en'
      ? 'Password'
      : 'Mật khẩu';
  String get nameHint =>
      locale.languageCode == 'en' ? 'Name' : 'Tên';
  String get dontHaveAccount =>
      locale.languageCode == 'en'
      ? "Don't have an account? Sign up"
      : 'Chưa có tài khoản? Đăng ký';
  String get haveAccount => locale.languageCode == 'en'
      ? 'Already have an account? Login'
      : 'Đã có tài khoản? Đăng nhập';
  String get greeting => locale.languageCode == 'en'
      ? 'Hello'
      : 'Xin chào';
  String get loginPrompt => locale.languageCode == 'en'
      ? 'Login to save favorite music\nand create personal playlists!'
      : 'Đăng nhập để lưu nhạc yêu thích\nvà tạo playlist cá nhân của bạn!';
  String get loginCardPrompt =>
      locale.languageCode == 'en'
      ? 'Login to save favorite music and create personal playlists!'
      : 'Đăng nhập để lưu nhạc yêu thích và tạo playlist cá nhân của bạn!';
  String get imagePathHint =>
      locale.languageCode == 'en'
      ? 'Image path (e.g., imgs/NewSong.jpg)'
      : 'Đường dẫn ảnh (ví dụ: imgs/NewSong.jpg)';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // SynchronousFuture avoids async gap and is OK for this small shim.
    return SynchronousFuture<AppLocalizations>(
      AppLocalizations(locale),
    );
  }

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<AppLocalizations>
    old,
  ) => false;
}
