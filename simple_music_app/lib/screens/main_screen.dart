import 'package:flutter/material.dart';
import 'package:simple_music_app/flutter_gen/gen_l10n/app_localizations.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'library/library_screen.dart';
import 'account/account_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({
    super.key,
    this.initialIndex = 3,
  }); // Mặc định chọn tab

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget
        .initialIndex; // Khởi tạo chỉ số tab được chọn
  }

  // Danh sách các màn hình
  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, //  hiển thị 4 icon đều nhau, giãn cân đối
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(
          255,
          253,
          119,
          177,
        ),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(
              context,
            ).homeTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: AppLocalizations.of(
              context,
            ).searchTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_music),
            label: AppLocalizations.of(
              context,
            ).libraryTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: AppLocalizations.of(
              context,
            ).accountTitle,
          ),
        ],
      ),
    );
  }
}
