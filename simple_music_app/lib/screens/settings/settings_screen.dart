import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';
import '../../models/app_settings.dart';
import '../auth/auth_state.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String userName;
  const SettingsScreen({
    super.key,
    required this.userName,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  bool saveData = false;
  bool downloadAudioOnly = false;
  bool streamAudioOnly = false;

  // 🌙 Thêm biến cho chỉnh sáng & ngôn ngữ
  // local copies removed - use AppSettings instead

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(
      context,
    );
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: appSettings.darkMode
          ? Colors.black
          : const Color(0xfff7f7f7),
      appBar: AppBar(
        title: Text(
          loc.settingsTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: appSettings.darkMode
            ? Colors.grey[900]
            : Colors.white,
        elevation: 0.8,
        iconTheme: IconThemeData(
          color: appSettings.darkMode
              ? Colors.white
              : Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPremiumCard(),
            const SizedBox(height: 25),
            _buildUserCard(),
            const SizedBox(height: 25),

            // 📶 Data Saver Section
            _buildSectionTitle(loc.saveDataTitle),
            _buildSwitchTile(
              icon: Icons.data_saver_on_outlined,
              title: loc.saveDataTitle,
              subtitle: loc.saveDataSubtitle,
              value: saveData,
              onChanged: (val) =>
                  setState(() => saveData = val),
            ),

            const SizedBox(height: 15),

            // 🎥 Video Podcasts Section
            _buildSectionTitle(loc.videoPodcasts),
            _buildSwitchTile(
              icon:
                  Icons.download_for_offline_outlined,
              title: loc.downloadAudioOnlyTitle,
              subtitle: loc.downloadAudioOnlySubtitle,
              value: downloadAudioOnly,
              onChanged: (val) => setState(
                () => downloadAudioOnly = val,
              ),
            ),
            _buildSwitchTile(
              icon: Icons.wifi_off_outlined,
              title: loc.streamAudioOnlyTitle,
              subtitle: loc.streamAudioOnlySubtitle,
              value: streamAudioOnly,
              onChanged: (val) => setState(
                () => streamAudioOnly = val,
              ),
            ),

            const SizedBox(height: 15),

            // 💡 Brightness Section
            _buildSectionTitle(loc.darkModeTitle),
            _buildSwitchTile(
              icon: Icons.dark_mode_outlined,
              title: loc.darkModeTitle,
              subtitle: loc.darkModeSubtitle,
              value: appSettings.darkMode,
              onChanged: (val) =>
                  appSettings.setDarkMode(val),
            ),

            const SizedBox(height: 15),

            // 🌍 Language Section
            _buildSectionTitle(loc.languageTitle),
            _buildSettingTile(
              icon: Icons.language_outlined,
              title: loc.languageSettingTitle,
              subtitle:
                  appSettings.locale.languageCode ==
                      'en'
                  ? loc.englishLabel
                  : loc.vietnameseLabel,
              onTap: () =>
                  _showLanguageDialog(appSettings),
            ),

            const SizedBox(height: 30),

            // 🚪 Logout
            Center(
              child: TextButton.icon(
                onPressed: _logout,
                icon: const Icon(
                  Icons.logout,
                  color: Color.fromARGB(
                    255,
                    255,
                    164,
                    209,
                  ),
                ),
                label: Text(
                  loc.logout,
                  style: const TextStyle(
                    color: Color.fromARGB(
                      255,
                      255,
                      164,
                      209,
                    ),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🌈 PREMIUM CARD
  Widget _buildPremiumCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 252, 218, 227),
            Color.fromARGB(255, 255, 164, 209),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.userName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(
              context,
            ).premiumUpgradePrompt,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            child: Text(
              AppLocalizations.of(
                context,
              ).upgradePremiumButton,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 👤 USER CARD
  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xfff0f0f0),
            child: Icon(
              Icons.person,
              color: Colors.black54,
              size: 35,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                widget.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context).freeUser,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // 🔖 SECTION TITLE
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  // 🔘 SWITCH TILE
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 2,
        ),
        secondary: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: Icon(
            icon,
            color: Colors.black87,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color.fromARGB(
          255,
          255,
          164,
          209,
        ),
      ),
    );
  }

  // ⚙️ NORMAL TILE
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 2,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: Icon(
            icon,
            color: Colors.black87,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  // 🌍 Chọn ngôn ngữ
  void _showLanguageDialog(AppSettings appSettings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).chooseLanguage,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(
                AppLocalizations.of(
                  context,
                ).vietnameseLabel,
              ),
              value: 'vi',
              groupValue:
                  appSettings.locale.languageCode,
              onChanged: (v) {
                appSettings.setLocale(
                  const Locale('vi'),
                );
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(
                AppLocalizations.of(
                  context,
                ).englishLabel,
              ),
              value: 'en',
              groupValue:
                  appSettings.locale.languageCode,
              onChanged: (v) {
                appSettings.setLocale(
                  const Locale('en'),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🚪 LOGOUT FUNCTION
  void _logout() {
    AuthState.isLoggedIn.value = false;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }
}
