import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_sralanh/models/phrase.dart';
import 'package:project_sralanh/theme/app_theme.dart';
import 'package:project_sralanh/widgets/phrase_bookmark_button.dart';

/// design_system_showcase_final.html `.saved-item` + JournalBlock 도트 패턴 응용.
class PhraseJournalListTile extends StatelessWidget {
  const PhraseJournalListTile({
    super.key,
    required this.phrase,
    this.onTap,
    this.showBookmark = true,
  });

  final Phrase phrase;
  final VoidCallback? onTap;
  final bool showBookmark;

  @override
  Widget build(BuildContext context) {
    final meta = categoryTagLabel(phrase.category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _JournalDotsPainter(
                        color: AppColors.onSurface,
                        opacity: 0.035,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    phrase.khmer,
                                    style: khmerTextStyle(
                                      context: context,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    meta,
                                    style: GoogleFonts.notoSansKr(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (showBookmark)
                              PhraseBookmarkButton(
                                phrase: phrase,
                                iconSize: 22,
                                padding: const EdgeInsets.all(4),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          phrase.korean,
                          style: GoogleFonts.notoSansKr(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.onSecondaryContainer
                                      .withValues(alpha: 0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'PRONUNCIATION',
                                  style: GoogleFonts.notoSansKr(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.6,
                                    color: AppColors.onSecondaryContainer
                                        .withValues(alpha: 0.72),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '[ ${phrase.pronunciation} ]',
                                  style: GoogleFonts.notoSansKr(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.4,
                                    color: AppColors.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

class _JournalDotsPainter extends CustomPainter {
  _JournalDotsPainter({
    required this.color,
    required this.opacity,
  });

  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..isAntiAlias = true;
    const double step = 14;
    for (double y = 0; y < size.height + step; y += step) {
      for (double x = 0; x < size.width + step; x += step) {
        canvas.drawCircle(Offset(x, y), 1.1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _JournalDotsPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.opacity != opacity;
  }
}
