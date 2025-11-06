// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Simple Music App';

  @override
  String get homeTitle => 'Trang chủ';

  @override
  String get searchTitle => 'Tìm kiếm';

  @override
  String get libraryTitle => 'Thư viện';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get darkModeTitle => 'Chế độ tối';

  @override
  String get darkModeSubtitle => 'Bật/tắt giao diện nền tối';

  @override
  String get languageTitle => 'Ngôn ngữ';

  @override
  String get languageSettingTitle => 'Ngôn ngữ hiển thị';

  @override
  String get saveDataTitle => 'Tiết kiệm dữ liệu';

  @override
  String get saveDataSubtitle => 'Giảm chất lượng âm thanh và ẩn hình ảnh';

  @override
  String get suggestedSongs => 'Gợi ý bài hát';

  @override
  String get playAll => 'Phát tất cả';

  @override
  String get recentlyPlayed => 'Nghe gần đây';

  @override
  String get hotToday => 'Hot nhất hôm nay';

  @override
  String get chill => 'Chill';

  @override
  String get accountTitle => 'Tài khoản';

  @override
  String get nowPlaying => 'Đang phát';

  @override
  String get suggestionsRefreshed => '✨ Danh sách gợi ý đã làm mới!';

  @override
  String addedToPlaylist(Object title) {
    return 'Đã thêm \'$title\' vào danh sách phát.';
  }

  @override
  String get musicLabel => 'Âm nhạc';

  @override
  String get searchHint => 'Tìm kiếm bài hát, nghệ sĩ...';

  @override
  String get searchHistory => 'Lịch sử tìm kiếm';

  @override
  String get clear => 'XÓA';

  @override
  String get noResults => 'Không tìm thấy kết quả phù hợp 😢';

  @override
  String get whatsNew => 'Có gì mới';

  @override
  String get songsTab => 'Bài hát';

  @override
  String get albumTab => 'Album';

  @override
  String get today => 'Hôm nay';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get earlier => 'Trước đó';

  @override
  String get artists => 'Nghệ sĩ';

  @override
  String get addArtist => 'Thêm nghệ sĩ';

  @override
  String get add => 'Thêm';

  @override
  String get cancel => 'Hủy';

  @override
  String get yourPlaylists => 'Playlist của bạn';

  @override
  String get suggestedPlaylists => 'Playlist được gợi ý';

  @override
  String get favoriteMusic => 'Nhạc yêu thích';

  @override
  String get addNewSong => 'Thêm bài hát mới';

  @override
  String get playingSongSnackbar => 'Đang phát bài hát';

  @override
  String get addedToPlaylistShort => 'Đã thêm vào danh sách phát';

  @override
  String get removedFromPlaylist => 'Đã xóa khỏi danh sách phát';

  @override
  String get loginButton => 'ĐĂNG NHẬP';

  @override
  String get signupButton => 'ĐĂNG KÝ';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Mật khẩu';

  @override
  String get nameHint => 'Tên';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản? Đăng ký';

  @override
  String get haveAccount => 'Đã có tài khoản? Đăng nhập';

  @override
  String get greeting => 'Xin chào';

  @override
  String get loginPrompt => 'Đăng nhập để lưu nhạc yêu thích\nvà tạo playlist cá nhân của bạn!';

  @override
  String get loginCardPrompt => 'Đăng nhập để lưu nhạc yêu thích và tạo playlist cá nhân của bạn!';

  @override
  String get imagePathHint => 'Đường dẫn ảnh (ví dụ: imgs/NewSong.jpg)';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get addedToFavorites => 'Đã thêm vào Yêu thích';

  @override
  String get removedFromFavorites => 'Đã xóa khỏi Yêu thích';
}
