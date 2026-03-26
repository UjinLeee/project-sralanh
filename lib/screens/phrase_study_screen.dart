import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_sralanh/models/phrase.dart';
import 'package:project_sralanh/theme/app_theme.dart';

/// Layout helpers: spacing/fonts scale with the shortest logical side; card
/// height is capped using viewport so 4:5 cards do not blow past small screens.
class _StudyResponsive {
  _StudyResponsive(this.context);

  final BuildContext context;

  MediaQueryData get _mq => MediaQuery.of(context);

  double get _w => _mq.size.width;

  double get _h => _mq.size.height;

  double get _short => math.min(_w, _h);

  /// Base scale (~400dp shortest side → 1.0).
  double get scale => (_short / 400).clamp(0.78, 1.22);

  double sp(double logical) => logical * scale;

  double horizontalPadding() => (_w * 0.05).clamp(12, 26);

  double contentMaxWidth() => math.min(512, _w * 0.94);

  double bodyTopPadding(double topInset) => topInset + sp(70);

  double scrollBottomPadding(double bottomInset) =>
      math.max(sp(96), _h * 0.13) + bottomInset;

  double gapAfterProgress() => sp(32);

  double gapBeforeChips() => sp(48);

  /// Prefer 4:5 by width, but never exceed available vertical space under chrome.
  double studyCardHeight(double cardWidth) {
    final pad = _mq.padding;
    final usableH = _h - pad.vertical;
    final chrome = usableH * 0.36;
    final maxByViewport = math.max(sp(210), usableH - chrome);
    final byAspect = cardWidth * 5 / 4;
    return math
        .min(byAspect, maxByViewport)
        .clamp(sp(200), math.min(sp(560), maxByViewport));
  }

  /// Fine-tune typography inside the card when it is shorter than design baseline.
  double studyCardInnerScale(double cardHeight) =>
      (cardHeight / 380).clamp(0.68, 1.05);
}

class PhraseStudyArgs {
  const PhraseStudyArgs({
    required this.phrases,
    this.initialIndex = 0,
    this.lessonNumber,
  });

  final List<Phrase> phrases;
  final int initialIndex;
  final int? lessonNumber;
}

class PhraseStudyScreen extends StatefulWidget {
  const PhraseStudyScreen({super.key, required this.args});

  final PhraseStudyArgs args;

  @override
  State<PhraseStudyScreen> createState() => _PhraseStudyScreenState();
}

class _PhraseStudyScreenState extends State<PhraseStudyScreen> {
  late int _index;

  @override
  void initState() {
    super.initState();
    final len = widget.args.phrases.length;
    _index = len == 0 ? 0 : widget.args.initialIndex.clamp(0, len - 1);
  }

  void _prev() {
    if (_index <= 0) return;
    setState(() => _index--);
  }

  void _next() {
    final len = widget.args.phrases.length;
    if (_index >= len - 1) return;
    setState(() => _index++);
  }

  (int start, int end) _visibleIndicatorRange(int total, int maxVisible) {
    if (total <= maxVisible) return (0, total);
    var start = _index - maxVisible ~/ 2;
    if (start < 0) start = 0;
    if (start + maxVisible > total) start = total - maxVisible;
    return (start, start + maxVisible);
  }

  @override
  Widget build(BuildContext context) {
    final phrases = widget.args.phrases;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final topInset = MediaQuery.paddingOf(context).top;
    final lessonNum = widget.args.lessonNumber ?? 1;
    final lessonLabel =
        'Lesson ${lessonNum.toString().padLeft(2, '0')}';

    if (phrases.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('학습'),
        ),
        body: Center(
          child: Text(
            '학습할 문장이 없습니다.',
            style: GoogleFonts.notoSansKr(color: AppColors.onSurfaceVariant),
          ),
        ),
      );
    }

    final phrase = phrases[_index];
    final total = phrases.length;
    final current = _index + 1;
    final progress = current / total;
    final r = _StudyResponsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                r.horizontalPadding(),
                r.bodyTopPadding(topInset),
                r.horizontalPadding(),
                r.scrollBottomPadding(bottomInset),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: r.contentMaxWidth()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProgressHeader(
                        lessonLabel: lessonLabel,
                        current: current,
                        total: total,
                        progress: progress,
                      ),
                      SizedBox(height: r.gapAfterProgress()),
                      _StudyCard(
                        phrase: phrase,
                        onPlayAudio: () {},
                      ),
                      SizedBox(height: r.gapBeforeChips()),
                      _HintChips(category: phrase.category),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _StudyTopBar(
              title: '${phrase.khmer} • ${phrase.korean}',
              topPadding: topInset,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _StudyFooter(
              canPrev: _index > 0,
              canNext: _index < total - 1,
              bottomPadding: bottomInset,
              onPrev: _prev,
              onNext: _next,
              currentIndex: _index,
              visibleRange: _visibleIndicatorRange(total, 7),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudyTopBar extends StatelessWidget {
  const _StudyTopBar({
    required this.title,
    required this.topPadding,
  });

  final String title;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final r = _StudyResponsive(context);
    final barH = r.sp(52).clamp(48.0, 58.0);
    final hPad = r.horizontalPadding();

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(top: topPadding),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            border: Border(
              bottom: BorderSide(
                color: AppColors.accentTealBorder,
              ),
            ),
          ),
          child: SizedBox(
            height: barH,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.gowunDodum(
                        fontSize: (16 * r.scale).clamp(14.0, 19.0),
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        letterSpacing: -0.25,
                      ),
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
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.lessonLabel,
    required this.current,
    required this.total,
    required this.progress,
  });

  final String lessonLabel;
  final int current;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final r = _StudyResponsive(context);
    final labelFs = (10 * r.scale).clamp(9.0, 12.0);
    final barH = r.sp(14).clamp(12.0, 18.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.sp(6)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lessonLabel.toUpperCase(),
                style: GoogleFonts.gowunDodum(
                  fontSize: labelFs,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '$current / $total',
                style: GoogleFonts.gowunDodum(
                  fontSize: labelFs,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: r.sp(10)),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: barH,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: AppColors.surfaceContainerLow),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryContainer
                              .withValues(alpha: 0.35),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StudyCard extends StatelessWidget {
  const _StudyCard({
    required this.phrase,
    required this.onPlayAudio,
  });

  final Phrase phrase;
  final VoidCallback onPlayAudio;

  @override
  Widget build(BuildContext context) {
    final r = _StudyResponsive(context);
    final icon = categoryIcon(phrase.category);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardW = constraints.maxWidth;
        final cardH = r.studyCardHeight(cardW);
        final s = r.studyCardInnerScale(cardH);
        final pad = math.max(12.0, cardW * 0.06);
        final fabNudge = r.sp(28) * s;
        final iconD = r.sp(44) * s;
        final labelFs = (11 * s).clamp(9.0, 12.0);
        final koreanFs = (28 * s).clamp(20.0, 32.0);
        final khmerFs = (30 * s).clamp(22.0, 34.0);
        final pronCaptionFs = (10 * s).clamp(8.5, 11.0);
        final pronBodyFs = (24 * s).clamp(17.0, 28.0);
        final gapMd = r.sp(14) * s;
        final gapSm = r.sp(10) * s;
        final corner = (22 * s).clamp(16.0, 26.0);
        final pronMinW = cardW * 0.55;

        return SizedBox(
          height: cardH,
          width: cardW,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: Container(
                  padding: EdgeInsets.all(pad),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(corner),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF071E27).withValues(alpha: 0.04),
                        blurRadius: r.sp(32),
                        offset: Offset(0, r.sp(16)),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: iconD,
                          height: iconD,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: AppColors.onSecondaryContainer,
                            size: iconD * 0.52,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: gapSm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 11,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'KOREAN',
                                    style: GoogleFonts.notoSansKr(
                                      fontSize: labelFs,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color: AppColors.secondary
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  SizedBox(height: gapMd),
                                  Text(
                                    phrase.korean,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.gowunDodum(
                                      fontSize: koreanFs,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: gapSm * 1.2),
                                  Container(
                                    constraints: BoxConstraints(
                                      minWidth: pronMinW,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: r.sp(18) * s,
                                      vertical: r.sp(9) * s,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryContainer,
                                      borderRadius: BorderRadius.circular(
                                        (16 * s).clamp(12.0, 20.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors
                                              .onSecondaryContainer
                                              .withValues(alpha: 0.12),
                                          blurRadius: r.sp(8),
                                          offset: Offset(0, r.sp(3)),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'PRONUNCIATION',
                                          style: GoogleFonts.notoSansKr(
                                            fontSize: pronCaptionFs,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.6,
                                            color: AppColors
                                                .onSecondaryContainer
                                                .withValues(alpha: 0.72),
                                          ),
                                        ),
                                        SizedBox(height: r.sp(3)),
                                        Text(
                                          '[ ${phrase.pronunciation} ]',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.notoSansKr(
                                            fontSize: pronBodyFs,
                                            fontWeight: FontWeight.w800,
                                            color:
                                                AppColors.onSecondaryContainer,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'KHMER',
                                    style: GoogleFonts.notoSansKr(
                                      fontSize: labelFs,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color: AppColors.primary
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  SizedBox(height: gapMd),
                                  Text(
                                    phrase.khmer,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: khmerTextStyle(
                                      context: context,
                                      fontSize: khmerFs,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface
                                          .withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, fabNudge),
                child: Material(
                  color: AppColors.primary,
                  shape: const CircleBorder(),
                  elevation: 8,
                  shadowColor: AppColors.primary.withValues(alpha: 0.35),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onPlayAudio,
                    child: Padding(
                      padding: EdgeInsets.all(r.sp(18) * s),
                      child: Icon(
                        Icons.volume_up_rounded,
                        color: Colors.white,
                        size: r.sp(32) * s,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HintChips extends StatelessWidget {
  const _HintChips({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final r = _StudyResponsive(context);
    final label = categoryDisplayName(category);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: r.sp(10),
      runSpacing: r.sp(10),
      children: [
        _HintChip(
          icon: Icons.lightbulb_outline_rounded,
          iconColor: AppColors.primary,
          label: label,
          italic: true,
        ),
        _HintChip(
          icon: Icons.verified_outlined,
          iconColor: AppColors.secondary,
          label: 'Essential Phrase',
          italic: false,
        ),
      ],
    );
  }
}

class _HintChip extends StatelessWidget {
  const _HintChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.italic,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final bool italic;

  @override
  Widget build(BuildContext context) {
    final r = _StudyResponsive(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.sp(16),
        vertical: r.sp(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: (16 * r.scale).clamp(14.0, 20.0),
            color: iconColor,
          ),
          SizedBox(width: r.sp(8)),
          Text(
            label,
            style: GoogleFonts.notoSansKr(
              fontSize: (13 * r.scale).clamp(11.0, 15.0),
              fontWeight: FontWeight.w600,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudyFooter extends StatelessWidget {
  const _StudyFooter({
    required this.canPrev,
    required this.canNext,
    required this.bottomPadding,
    required this.onPrev,
    required this.onNext,
    required this.currentIndex,
    required this.visibleRange,
  });

  final bool canPrev;
  final bool canNext;
  final double bottomPadding;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final int currentIndex;
  final (int start, int end) visibleRange;

  @override
  Widget build(BuildContext context) {
    final (start, end) = visibleRange;
    final r = _StudyResponsive(context);
    final hPad = r.horizontalPadding();
    final topPad = r.sp(26);
    final botPad = r.sp(32) + bottomPadding;
    final radius = r.sp(44).clamp(28.0, 48.0);
    final prevCircle = r.sp(48).clamp(44.0, 58.0);
    final dotH = r.sp(8).clamp(6.0, 10.0);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            left: hPad,
            right: hPad,
            top: topPad,
            bottom: botPad,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(radius)),
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
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: r.contentMaxWidth()),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: canPrev ? onPrev : null,
                    child: Opacity(
                      opacity: canPrev ? 1 : 0.35,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.sp(8),
                          vertical: r.sp(6),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: prevCircle,
                              height: prevCircle,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: (22 * r.scale).clamp(20.0, 26.0),
                                color: canPrev
                                    ? const Color(0xFF6F7977)
                                    : AppColors.outlineVariant,
                              ),
                            ),
                            SizedBox(height: r.sp(3)),
                            Text(
                              'PREVIOUS',
                              style: GoogleFonts.notoSansKr(
                                fontSize: (10 * r.scale).clamp(9.0, 12.0),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                color: const Color(0xFF6F7977),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = start; i < end; i++)
                      Padding(
                        padding: EdgeInsets.only(right: r.sp(7)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: i == currentIndex ? r.sp(22) : dotH,
                          height: dotH,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(
                              alpha: i == currentIndex ? 1 : 0.2,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                  ],
                ),
                Material(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(999),
                  elevation: 6,
                  shadowColor:
                      AppColors.onSecondaryContainer.withValues(alpha: 0.2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: canNext ? onNext : null,
                    child: Opacity(
                      opacity: canNext ? 1 : 0.45,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.sp(18),
                          vertical: r.sp(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'NEXT',
                              style: GoogleFonts.gowunDodum(
                                fontSize: (12 * r.scale).clamp(11.0, 14.0),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: AppColors.onSecondaryContainer,
                              ),
                            ),
                            SizedBox(width: r.sp(6)),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.onSecondaryContainer,
                              size: (20 * r.scale).clamp(18.0, 24.0),
                            ),
                          ],
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
