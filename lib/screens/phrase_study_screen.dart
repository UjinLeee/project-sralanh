import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_sralanh/models/phrase.dart';
import 'package:project_sralanh/theme/app_theme.dart';

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
  static const _profileImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAfzmmXYTK-QQBGwPxYaA6PD9ostM6ZVkCGKzxt4fknMVQj4tJ65JVG03qRO_clOC3Qt--Rbht7TYj0qfKLNOKDiEYKHO-eqxj_KaIr3znD5aI_0T38Wn9OtJ7fh_j-d5GpvqIUvGSn8en2_cKpSKStY5hfKViEwXr7-IiC1_UDUyZUgvXQNUKPuqsftHOIe-7UzpGukj8xgNNlTKA56Z0AG5Zv5Yq-1tXtamo0lvx37UlUIUIrA6YoYDr1i6B5zvLzQdPk6EdS1r9Z';

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
            style: GoogleFonts.beVietnamPro(color: AppColors.onSurfaceVariant),
          ),
        ),
      );
    }

    final phrase = phrases[_index];
    final total = phrases.length;
    final current = _index + 1;
    final progress = current / total;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24,
                topInset + 80,
                24,
                140 + bottomInset,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 512),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProgressHeader(
                        lessonLabel: lessonLabel,
                        current: current,
                        total: total,
                        progress: progress,
                      ),
                      const SizedBox(height: 48),
                      _StudyCard(
                        phrase: phrase,
                        onPlayAudio: () {},
                      ),
                      const SizedBox(height: 80),
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
              profileImageUrl: _profileImageUrl,
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
    required this.profileImageUrl,
    required this.topPadding,
  });

  final String title;
  final String profileImageUrl;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(top: topPadding),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFCCFBF1).withValues(alpha: 0.35),
              ),
            ),
          ),
          child: SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        letterSpacing: -0.25,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipOval(
                      child: Image.network(
                        profileImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ColoredBox(
                          color: AppColors.surfaceContainerLow,
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.primary,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lessonLabel.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '$current / $total',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 16,
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
    final icon = categoryIcon(phrase.category);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        AspectRatio(
          aspectRatio: 4 / 5,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF071E27).withValues(alpha: 0.04),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.onSecondaryContainer,
                      size: 26,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 11,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'KHMER',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: AppColors.primary.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              phrase.khmer,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: khmerTextStyle(
                                context: context,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface.withValues(alpha: 0.9),
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
                              'KOREAN',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: AppColors.secondary.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              phrase.korean,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              constraints: const BoxConstraints(minWidth: 220),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.onSecondaryContainer
                                        .withValues(alpha: 0.12),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'PRONUNCIATION',
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.8,
                                      color: AppColors.onSecondaryContainer
                                          .withValues(alpha: 0.72),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '[ ${phrase.pronunciation} ]',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.onSecondaryContainer,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, 32),
          child: Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            elevation: 8,
            shadowColor: AppColors.primary.withValues(alpha: 0.35),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPlayAudio,
              child: const Padding(
                padding: EdgeInsets.all(22),
                child: Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HintChips extends StatelessWidget {
  const _HintChips({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final label = categoryDisplayName(category);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
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

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            left: 32,
            right: 32,
            top: 32,
            bottom: 40 + bottomPadding,
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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 512),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: canPrev
                                    ? const Color(0xFF6F7977)
                                    : AppColors.outlineVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'PREVIOUS',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 11,
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
                        padding: const EdgeInsets.only(right: 8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: i == currentIndex ? 24 : 8,
                          height: 8,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'NEXT',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: AppColors.onSecondaryContainer,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.onSecondaryContainer,
                              size: 22,
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
