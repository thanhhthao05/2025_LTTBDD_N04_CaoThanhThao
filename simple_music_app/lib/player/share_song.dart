import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareSong({
  required String title,
  required String artist,
  String?
  platform, // facebook, messenger, zalo, instagram
}) async {
  final message =
      '🎵 Nghe ngay bài hát: $title - $artist';

  switch (platform) {
    case 'facebook':
      final fbUrl = Uri.parse(
        'https://www.facebook.com/sharer/sharer.php?u=$message',
      );
      if (await canLaunchUrl(fbUrl)) {
        await launchUrl(
          fbUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await Share.share(message);
      }
      break;

    case 'messenger':
      final msUrl = Uri.parse(
        'fb-messenger://share?text=$message',
      );
      if (await canLaunchUrl(msUrl)) {
        await launchUrl(
          msUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await Share.share(message);
      }
      break;

    case 'zalo':
      final zaloUrl = Uri.parse('zalo://');
      if (await canLaunchUrl(zaloUrl)) {
        await launchUrl(
          zaloUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await Share.share(message);
      }
      break;

    case 'instagram':
      final instaUrl = Uri.parse('instagram://camera');
      if (await canLaunchUrl(instaUrl)) {
        await launchUrl(
          instaUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await Share.share(message);
      }
      break;

    default:
      await Share.share(message);
  }
}
