import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_sralanh/models/phrase.dart';
import 'package:project_sralanh/screens/phrase_study_screen.dart';
import 'package:project_sralanh/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _profileImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAcZbV2lM2JH791vk0h2LeBCB2mIivp9w9kyO25iLtbaAOagJhEN1keX19oTsPMLQVDsxfDBx6UfeUpJlYABIqSroQ61np6ta0fmuYTF0ueCqYtZFoBVJVWZ760z83Y_R674CeYPPXZmyA2UhKKopItuUxb6nMjdgTp4IOkIFEWqLq6tivFGGNUs8-20KCC6w9RqHQCLOJbylgNen2mMUWkzykYaq3w4CbOonOdyQdnLxQ0PWW7k3uK-lH0lvQYKbWTTMwnljVMm9ev';

  static const _lessonImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAmHK8BcdCd_MyPyK4JJlJ0Hn9UnMOuTTfbI5Vzb57rVlOPWwt3ZdzHpSCUI1v070lCZWH5hhvvQJw7wB-0ebaC0sRBxeC70rcsjb262CV796NJmTeI9pgpRbZxc6VvksqOrq3UB8wKMTg2_JMAu5S7lJmNhX3h0fX-DrWjHhtTfx2ay1XL5S0qE3YFFV81HB5_Bxjf2pWgx1sYObqQtH-QqwX0qcPm-gpmTft89GZngVbLjV62PcHfjsW2lp5RQjX0j9THNiipIXDb';

  Phrase? _phraseOfDay;
  List<Phrase> _phrases = [];
  bool _loading = true;
  String? _error;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPhrases();
  }

  Future<void> _loadPhrases() async {
    try {
      final raw = await rootBundle.loadString('assets/data/phrases.json');
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => Phrase.fromJson(e as Map<String, dynamic>))
          .toList();
      final now = DateTime.now();
      final startOfYear = DateTime(now.year);
      final dayIndex = now.difference(startOfYear).inDays;
      if (!mounted) return;
      setState(() {
        _phrases = list;
        _phraseOfDay = list.isEmpty ? null : list[dayIndex % list.length];
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _openPhraseStudy(BuildContext context) {
    if (_phrases.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PhraseStudyScreen(
          args: PhraseStudyArgs(
            phrases: _phrases,
            initialIndex: 0,
            lessonNumber: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            '문구를 불러오지 못했습니다.\n$_error',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.beVietnamPro(color: AppColors.onSurface),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          MediaQuery.paddingOf(context).top + 72,
                          24,
                          140 + bottomInset,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 40,
                            children: [
                              _TodayGoalSection(goalPercent: 0.85),
                              _PhraseOfDayCard(
                                phrase: _phraseOfDay!,
                              ),
                              _QuickActions(
                                onStudyStart: () =>
                                    _openPhraseStudy(context),
                              ),
                              _FeaturedLesson(
                                imageUrl: _lessonImageUrl,
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _BlurredTopBar(
              profileImageUrl: _profileImageUrl,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomNavBar(
              selectedIndex: _navIndex,
              onSelect: (i) => setState(() => _navIndex = i),
              bottomPadding: bottomInset,
            ),
          ),
          if (!_loading && _error == null)
            Positioned(
              right: 24,
              bottom: 128 + bottomInset,
              child: Material(
                elevation: 8,
                shadowColor: Colors.black26,
                shape: const CircleBorder(),
                color: AppColors.tertiaryContainer,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 28,
                      color: AppColors.onTertiaryContainer,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BlurredTopBar extends StatelessWidget {
  const _BlurredTopBar({required this.profileImageUrl});

  final String profileImageUrl;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.only(top: top),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDFA).withValues(alpha: 0.82),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF071E27).withValues(alpha: 0.06),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      foregroundColor: const Color(0xFF0D9488),
                      backgroundColor: const Color(0xFFCCFBF1).withValues(alpha: 0.5),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.menu_rounded),
                  ),
                  Expanded(
                    child: Text(
                      '홈',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  Material(
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.network(
                          profileImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: AppColors.surfaceContainerLow,
                            child: const Icon(Icons.person_outline),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TodayGoalSection extends StatelessWidget {
  const _TodayGoalSection({required this.goalPercent});

  final double goalPercent;

  @override
  Widget build(BuildContext context) {
    final pct = (goalPercent * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '오늘의 목표',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              '$pct%',
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 16,
            child: Stack(
              children: [
                Container(color: AppColors.surfaceContainerLow),
                FractionallySizedBox(
                  widthFactor: goalPercent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryContainer.withValues(alpha: 0.45),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          '조금만 더 힘내세요! 오늘의 학습 완료까지 얼마 남지 않았습니다.',
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _PhraseOfDayCard extends StatelessWidget {
  const _PhraseOfDayCard({required this.phrase});

  final Phrase phrase;

  @override
  Widget build(BuildContext context) {
    final tag1 = categoryTagLabel(phrase.category);
    const tag2 = '#학습';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryFixed.withValues(alpha: 0.35),
                    AppColors.secondaryFixed.withValues(alpha: 0.35),
                  ],
                ),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, 0),
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF071E27).withValues(alpha: 0.04),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 24,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Text(
                          '오늘의 문장',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: AppColors.primary,
                      shape: const CircleBorder(),
                      elevation: 6,
                      shadowColor: AppColors.primary.withValues(alpha: 0.4),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Icon(
                            Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    Text(
                      phrase.khmer,
                      style: khmerTextStyle(
                        context: context,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      phrase.korean,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _ChipTag(label: tag1),
                    _ChipTag(label: tag2),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChipTag extends StatelessWidget {
  const _ChipTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.beVietnamPro(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onStudyStart});

  final VoidCallback onStudyStart;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
              elevation: 8,
              shadowColor: AppColors.primary.withValues(alpha: 0.35),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onStudyStart,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.play_circle_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            'ចាប់ផ្តើមភ្លាមៗ',
                            style: khmerTextStyle(
                              context: context,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          Text(
                            '학습 시작',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              spacing: 16,
              children: [
                Expanded(
                  child: _SmallActionTile(
                    background: AppColors.secondaryContainer,
                    iconColor: AppColors.secondary,
                    icon: Icons.menu_book_rounded,
                    label: '단어장',
                    labelColor: AppColors.onSecondaryContainer,
                  ),
                ),
                Expanded(
                  child: _SmallActionTile(
                    background: AppColors.surfaceContainerHighest,
                    iconColor: AppColors.primary,
                    icon: Icons.history_rounded,
                    label: '기록',
                    labelColor: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallActionTile extends StatelessWidget {
  const _SmallActionTile({
    required this.background,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.labelColor,
  });

  final Color background;
  final Color iconColor;
  final IconData icon;
  final String label;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      color: labelColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedLesson extends StatelessWidget {
  const _FeaturedLesson({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24,
      children: [
        Text(
          '추천 레슨',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        Material(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ColoredBox(
                          color: AppColors.primaryContainer,
                          child: Icon(
                            Icons.storefront_rounded,
                            color: AppColors.primary,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          'នៅផ្សារ',
                          style: khmerTextStyle(
                            context: context,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '시장 구경하기',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          '15개 단어 • 5분',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.outlineVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.selectedIndex,
    required this.onSelect,
    required this.bottomPadding,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final double bottomPadding;

  static const _items = <({IconData icon, String labelKm})>[
    (icon: Icons.school_rounded, labelKm: 'មេរៀន'),
    (icon: Icons.menu_book_rounded, labelKm: 'វចនានុក្រម'),
    (icon: Icons.translate_rounded, labelKm: 'ការអនុវត្ត'),
    (icon: Icons.person_rounded, labelKm: 'ប្រវត្តិរូប'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: 24 + bottomPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
            border: Border(
              top: BorderSide(
                color: const Color(0xFFCCFBF1).withValues(alpha: 0.35),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF071E27).withValues(alpha: 0.06),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = i == selectedIndex;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: selected
                        ? const Color(0xFF0D9488)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => onSelect(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 4,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.icon,
                              size: 24,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.labelKm,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
