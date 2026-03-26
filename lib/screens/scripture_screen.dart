import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_sralanh/models/prayer.dart';
import 'package:project_sralanh/theme/app_theme.dart';
import 'package:project_sralanh/widgets/blurred_sralanh_top_bar.dart';

/// `prayers.json` — 주기도문·사도신경. 발음은 `secondaryContainer`(살구) 패널에 항상 표시.
class ScriptureScreen extends StatefulWidget {
  const ScriptureScreen({super.key});

  @override
  State<ScriptureScreen> createState() => _ScriptureScreenState();
}

class _ScriptureScreenState extends State<ScriptureScreen> {
  List<Prayer> _prayers = [];
  bool _loading = true;
  String? _error;
  int _prayerTabIndex = 0;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final raw = await rootBundle.loadString('assets/data/prayers.json');
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => Prayer.fromJson(e as Map<String, dynamic>))
          .toList();
      if (!mounted) return;
      setState(() {
        _prayers = list;
        _loading = false;
        _error = null;
        if (_prayerTabIndex >= _prayers.length) {
          _prayerTabIndex = 0;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _onPrayerTabChanged(int index) {
    if (index == _prayerTabIndex) return;
    setState(() => _prayerTabIndex = index);
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final topPad = MediaQuery.paddingOf(context).top + 72;

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
                            '기도문을 불러오지 못했습니다.\n$_error',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKr(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : _prayers.isEmpty
                        ? Center(
                            child: Text(
                              '표시할 기도문이 없습니다.',
                              style: GoogleFonts.notoSansKr(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          )
                        : CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.fromLTRB(
                                  20,
                                  topPad,
                                  20,
                                  120 + bottomInset,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 560,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          _PrayerTabBar(
                                            prayers: _prayers,
                                            selectedIndex: _prayerTabIndex,
                                            onChanged: _onPrayerTabChanged,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '한국어 → 발음 → 크메르',
                                            style: GoogleFonts.notoSansKr(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.onSurfaceVariant,
                                              height: 1.4,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ..._buildVerseList(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BlurredSralanhTopBar(title: '예배'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildVerseList() {
    final prayer = _prayers[_prayerTabIndex];
    final len = prayer.content.length;
    return prayer.content.asMap().entries.map((e) {
      final i = e.key;
      return Padding(
        padding: EdgeInsets.only(bottom: i < len - 1 ? 14 : 0),
        child: _LiturgyVerseCard(
          verseIndex: i + 1,
          verseTotal: len,
          content: e.value,
        ),
      );
    }).toList();
  }
}

class _PrayerTabBar extends StatelessWidget {
  const _PrayerTabBar({
    required this.prayers,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<Prayer> prayers;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: List.generate(prayers.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: Material(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              elevation: selected ? 2 : 0,
              shadowColor: AppColors.shadowSoft,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onChanged(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    prayers[i].title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.accentTeal
                          : AppColors.mutedSlate,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// `design_system_showcase_final.html` §14 · 살구색 `liturgy-pron-panel--peach`.
class _LiturgyVerseCard extends StatelessWidget {
  const _LiturgyVerseCard({
    required this.verseIndex,
    required this.verseTotal,
    required this.content,
  });

  final int verseIndex;
  final int verseTotal;
  final Content content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '절 $verseIndex / $verseTotal',
            style: GoogleFonts.notoSansKr(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.mutedSlate,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'KOREAN',
              style: GoogleFonts.notoSansKr(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: AppColors.secondary.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content.korean,
            style: GoogleFonts.gowunDodum(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              height: 1.38,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _PeachPronunciationPanel(text: content.pronunciation),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'KHMER',
              style: GoogleFonts.notoSansKr(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content.khmer,
            style: khmerTextStyle(
              context: context,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ).copyWith(height: 1.42),
          ),
        ],
      ),
    );
  }
}

class _PeachPronunciationPanel extends StatelessWidget {
  const _PeachPronunciationPanel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSecondaryContainer.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRONUNCIATION',
            style: GoogleFonts.notoSansKr(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.6,
              color: AppColors.onSecondaryContainer.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1.45,
              letterSpacing: 0.4,
              color: AppColors.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
