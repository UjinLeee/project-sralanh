import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:project_sralanh/models/phrase.dart';
import 'package:project_sralanh/providers/word_book_provider.dart';
import 'package:project_sralanh/screens/phrase_study_screen.dart';
import 'package:project_sralanh/theme/app_theme.dart';
import 'package:project_sralanh/widgets/blurred_sralanh_top_bar.dart';
import 'package:project_sralanh/widgets/phrase_journal_list_tile.dart';

/// 단어장: 내 저장 목록 · 주제별 학습 (TabBar + 칩 필터).
class WordBookScreen extends StatefulWidget {
  const WordBookScreen({super.key});

  @override
  State<WordBookScreen> createState() => _WordBookScreenState();
}

class _WordBookScreenState extends State<WordBookScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Phrase> _phrases = [];
  bool _loading = true;
  String? _error;
  String? _topicCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPhrases();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPhrases() async {
    try {
      final raw = await rootBundle.loadString('assets/data/phrases.json');
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => Phrase.fromJson(e as Map<String, dynamic>))
          .toList();
      if (!mounted) return;
      setState(() {
        _phrases = list;
        _loading = false;
        _error = null;
        final cats = _orderedCategories(list);
        _topicCategory ??= cats.isEmpty ? null : cats.first;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  List<String> _orderedCategories(List<Phrase> phrases) {
    const order = ['greeting', 'kids', 'church'];
    final set = phrases.map((p) => p.category).toSet();
    final out = <String>[];
    for (final c in order) {
      if (set.contains(c)) out.add(c);
    }
    for (final c in set) {
      if (!out.contains(c)) out.add(c);
    }
    return out;
  }

  void _openStudy(List<Phrase> phrases, int index) {
    if (phrases.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PhraseStudyScreen(
          args: PhraseStudyArgs(
            phrases: phrases,
            initialIndex: index.clamp(0, phrases.length - 1),
            lessonNumber: 1,
          ),
        ),
      ),
    );
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
                            '문구를 불러오지 못했습니다.\n$_error',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKr(
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: topPad),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: _WordBookTabBar(controller: _tabController),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _MyWordBookTab(
                                  phrases: _phrases,
                                  bottomInset: bottomInset,
                                  onOpenStudy: _openStudy,
                                ),
                                _TopicStudyTab(
                                  phrases: _phrases,
                                  categories: _orderedCategories(_phrases),
                                  selectedCategory: _topicCategory,
                                  bottomInset: bottomInset,
                                  onCategorySelected: (c) =>
                                      setState(() => _topicCategory = c),
                                  onOpenStudy: _openStudy,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BlurredSralanhTopBar(title: '단어장'),
          ),
        ],
      ),
    );
  }
}

class _WordBookTabBar extends StatelessWidget {
  const _WordBookTabBar({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.accentTeal,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentTeal.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.mutedSlate,
        labelStyle: GoogleFonts.notoSansKr(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.notoSansKr(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: const [
          Tab(text: '내 단어장'),
          Tab(text: '주제별 학습'),
        ],
      ),
    );
  }
}

class _MyWordBookTab extends StatelessWidget {
  const _MyWordBookTab({
    required this.phrases,
    required this.bottomInset,
    required this.onOpenStudy,
  });

  final List<Phrase> phrases;
  final double bottomInset;
  final void Function(List<Phrase> phrases, int index) onOpenStudy;

  @override
  Widget build(BuildContext context) {
    return Consumer<WordBookProvider>(
      builder: (context, wordBook, _) {
        final saved = wordBook.resolveSaved(phrases);

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 120 + bottomInset),
              sliver: SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '저장한 단어',
                            style: GoogleFonts.gowunDodum(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              foregroundColor: AppColors.accentTeal,
                              backgroundColor: AppColors.accentTealSurface,
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.search_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (saved.isEmpty)
                        _EmptySavedPanel(
                          onStudyTap: () => onOpenStudy(phrases, 0),
                        )
                      else
                        ...saved.asMap().entries.map(
                              (e) => PhraseJournalListTile(
                                phrase: e.value,
                                onTap: () => onOpenStudy(saved, e.key),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptySavedPanel extends StatelessWidget {
  const _EmptySavedPanel({required this.onStudyTap});

  final VoidCallback onStudyTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.bookmarks_outlined,
            size: 48,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            '저장한 단어가 없습니다',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '학습 중 마음에 드는 표현을 저장하면 여기에 모입니다.',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              fontSize: 14,
              height: 1.45,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onStudyTap,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(
              '학습하러 가기',
              style: GoogleFonts.notoSansKr(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicStudyTab extends StatelessWidget {
  const _TopicStudyTab({
    required this.phrases,
    required this.categories,
    required this.selectedCategory,
    required this.bottomInset,
    required this.onCategorySelected,
    required this.onOpenStudy,
  });

  final List<Phrase> phrases;
  final List<String> categories;
  final String? selectedCategory;
  final double bottomInset;
  final void Function(String category) onCategorySelected;
  final void Function(List<Phrase> phrases, int index) onOpenStudy;

  @override
  Widget build(BuildContext context) {
    final cat = selectedCategory ??
        (categories.isNotEmpty ? categories.first : null);
    final filtered = cat == null
        ? <Phrase>[]
        : phrases.where((p) => p.category == cat).toList();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 120 + bottomInset),
          sliver: SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '주제별 학습',
                    style: GoogleFonts.gowunDodum(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final c in categories) ...[
                          _CategoryChip(
                            label: categoryDisplayName(c),
                            selected: c == cat,
                            onTap: () => onCategorySelected(c),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        '이 주제에 해당하는 문장이 없습니다.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSansKr(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    ...filtered.asMap().entries.map(
                          (e) => PhraseJournalListTile(
                            phrase: e.value,
                            onTap: () => onOpenStudy(filtered, e.key),
                          ),
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

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accentTeal : AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(
            label,
            style: GoogleFonts.notoSansKr(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
