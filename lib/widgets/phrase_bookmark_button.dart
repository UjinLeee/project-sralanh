import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_sralanh/models/phrase.dart';
import 'package:project_sralanh/providers/word_book_provider.dart';
import 'package:project_sralanh/theme/app_theme.dart';

/// 단어 카드 우측 상단용 저장(별) 토글.
class PhraseBookmarkButton extends StatelessWidget {
  const PhraseBookmarkButton({
    super.key,
    required this.phrase,
    this.iconSize = 24,
    this.padding = EdgeInsets.zero,
  });

  final Phrase phrase;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Consumer<WordBookProvider>(
      builder: (context, wordBook, _) {
        final saved = wordBook.isSaved(phrase.id);
        return IconButton(
          padding: padding,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          style: IconButton.styleFrom(
            foregroundColor: saved
                ? AppColors.accentTeal
                : AppColors.onSurfaceVariant,
            backgroundColor: saved
                ? AppColors.accentTealSurface
                : AppColors.surfaceContainerLow,
          ),
          tooltip: saved ? '저장 취소' : '단어장에 저장',
          onPressed: () => wordBook.toggleSave(phrase),
          icon: Icon(
            saved ? Icons.star_rounded : Icons.star_outline_rounded,
            size: iconSize,
          ),
        );
      },
    );
  }
}
