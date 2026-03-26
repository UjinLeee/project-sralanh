import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_sralanh/theme/app_theme.dart';

/// BlurredTopBar — design_system_showcase_final.html (홈 스타일).
class BlurredSralanhTopBar extends StatelessWidget {
  const BlurredSralanhTopBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.only(top: top),
          decoration: BoxDecoration(
            color: AppColors.glassMint,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowSoft,
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
                  leading ??
                      IconButton(
                        style: IconButton.styleFrom(
                          foregroundColor: AppColors.accentTeal,
                          backgroundColor: AppColors.accentTealSurface,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.menu_rounded),
                      ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.gowunDodum(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleSlate,
                      ),
                    ),
                  ),
                  trailing ??
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
