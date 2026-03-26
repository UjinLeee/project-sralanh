import 'package:flutter/material.dart';
import 'package:project_sralanh/screens/home_tab_screen.dart';
import 'package:project_sralanh/screens/word_book_screen.dart';
import 'package:project_sralanh/screens/scripture_screen.dart';
import 'package:project_sralanh/widgets/sralanh_bottom_nav_bar.dart';

/// 루트 셸: 홈 · 단어장 · 예배 + Sralanh 하단 네비.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _tab = 0;

  static const List<SralanhNavItem> _navItems = [
    SralanhNavItem(icon: Icons.home_rounded, label: '홈'),
    SralanhNavItem(icon: Icons.bookmarks_rounded, label: '단어장'),
    SralanhNavItem(icon: Icons.church_rounded, label: '예배'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _tab,
              children: [
                HomeTabScreen(
                  onOpenWordBook: () => setState(() => _tab = 1),
                ),
                const WordBookScreen(),
                const ScriptureScreen(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SralanhBottomNavBar(
              currentIndex: _tab,
              onTap: (i) => setState(() => _tab = i),
              items: _navItems,
              bottomPadding: bottomInset,
            ),
          ),
        ],
      ),
    );
  }
}
